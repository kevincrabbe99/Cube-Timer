//
//  SolvesFromTimeframe.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/26/20.
//

import Foundation
import SwiftUI



class SolvesFromTimeframe: ObservableObject {
    
    @Published var solves: [SolveItem] // array of all the solves
    @Published var size: Int   // amount of solves
    
    
    
    //WILL NEED TO BE UPDATED: should be redundant
    //var timeframe: Timeframe // current timeframe
    
    /*
     *  Inits an empty object
     *  No callers
     */
    init() {
        self.solves = []
        self.size = 0
        //self.timeframe = .Unknown
    }
    
    /*
     *  Inits and sets a timeframe
     *  No known callers
     #1 Removed constructor, no need to set self.timeframe
     
    init(_ tf: Timeframe) {
        self.solves = []
        self.size = 0
        self.timeframe = tf
    }
     */
    
    
    
    
    /*
     *  Returns an array of the solves from the requested timeframe
     *  Called by self.updateTimeFrame
     
     *  NEED TO UPDATE: make it so it just gets the data from the solvesByTimeFrame object
     #1 moved from SolveHandler.swift to (here) SolvesFromTimeframe.swift
     */
    func getSolvesFrom(timeframe: Timeframe) -> [SolveItem] {
        var res: [SolveItem] = []
        
        let now = Date()
        // needed for test .Week calculation
        let dayAgo: Date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        
        switch timeframe {
        case .LastThree:
            let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            let range = monthAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
            /* New Way!
            var i = 0; while (i < 3) {   // loop 3 times
                if solves.count > (i+1) {   // check if solves has a value
                    res.append(solves[i]);  // add solve to return value
                }else { // if there are no more solves
                    i = 3 // cancel while loop
                }
                
                i+=1 // increment i for the while loop
            }
 */
            /* The old way of doing things
            if solves.count >= 3 {
                res = last3
            }
            */
        case .Today:
            for s in solves {
                if Calendar.current.isDateInToday(s.timestamp) {
                    res.append(s)
                }
            }
        case .Week:
            
            let weekAgo: Date = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            let range = weekAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
            
        case .OneMonth:
            
            let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
            let range = monthAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
            
        case .ThreeMonths:
            let threeMonthAgo: Date = Calendar.current.date(byAdding: .month, value: -3, to: now)!
            let range = threeMonthAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
        case .Year:
            let yearAgo: Date = Calendar.current.date(byAdding: .year, value: -1, to: now)!
            let range = yearAgo...now
            for s in solves {
                if range.contains(s.timestamp) {
                    res.append(s)
                }
            }
        case .All:
            res = solves
        default:
            print("fuck")
        }
        
        print("getSolvesFrom(tf: Timeframe) tf = ", timeframe.rawValue);
        print("getSolvesFrom(tf: Timeframe) was called, ", res.count, " items returned!")
        return res
    }
    
    /*
     *  Returns an array of the timeframs which are needed for all the solves
     */
    func getApplicableTimeframes() -> [Timeframe] {
        var res: [Timeframe] = [.LastThree, .Today, .All] // the array to be returned
        let now = Date()
        
        // needed for test .Week calculation
        let dayAgo: Date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        
        // test .Week
        let weekAgo: Date = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let rangeW = weekAgo...dayAgo
        for s in solves {
            if rangeW.contains(s.timestamp) {
                res.append(.Week)
                break
            }
        }
        
        // test .OneMonth
        let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        let rangeM = monthAgo...weekAgo
        for s in solves {
            if rangeM.contains(s.timestamp) {
                res.append(.OneMonth)
                break
            }
        }
        
        // test .ThreeMonths
        let threeMonthAgo: Date = Calendar.current.date(byAdding: .month, value: -3, to: now)!
        let range3M = threeMonthAgo...monthAgo
        for s in solves {
            if range3M.contains(s.timestamp) {
                res.append(.ThreeMonths)
                break
            }
        }
        
        // test .Year
        let yearAgo: Date = Calendar.current.date(byAdding: .year, value: -1, to: now)!
        let rangeY = yearAgo...threeMonthAgo
        for s in solves {
            if rangeY.contains(s.timestamp) {
                res.append(.Year)
                break
            }
        }
        
        // delete the last one added so last and all are not redundant
        // ONLY IF: we have more than 3 and less than 7 buttons active
        if res.count > 3 && res.count < 7 { // if we should delete one
            res.remove(at: res.count - 1) // delete the second to last button
        }
        
        return res
        
    }
    

    
    /*
     *  Adds an array of SolveItems to self.solves
     */
    func add(_ ar: [SolveItem]) {
        for s in ar {
            add(s)
        }
    }
    
    /*
     *  Adds a solve to self.solves
     */
    func add(_ s: SolveItem) {
        solves.append(s)
        self.size += 1
    }
    
    /*
     *  Deletes a provided SolveItem given it exists
     *  Called by: SolveHandler().delete(_s: SolveItem)
     */
    func delete(_ s: SolveItem) {
        solves = solves.filter { $0 != s }
        size -= 1
        print("Deleted from SolvesFromTimeframe.swift reference")
    }
     
    
}

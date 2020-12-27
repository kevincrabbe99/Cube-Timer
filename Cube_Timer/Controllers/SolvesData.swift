//
//  SolvesFromTimeframe.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/26/20.
//

import Foundation
import SwiftUI

enum TimeGroup: String {
    case Unknown = "unknown"
    case today = "today"
    case yesterday = "yesterday"
    case thisWeek = "last week"
    case thisMonth = "this month"
    case lastMonth = "lastMonth"
    
    case jan = "Jan"
    case feb = "Feb"
    case mar = "Mar"
    case apr = "Apr"
    case may = "May"
    case jun = "Jun"
    case jul = "Jul"
    case aug = "Aug"
    case sep = "Sep"
    case oct = "Oct"
    case nov = "Nov"
    case dec = "Dec"
}

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
}

class SolvesFromTimeframe: ObservableObject {
    
    // parent is this clases outlet to the app
        // the CubeType gets parced here
            // timeframe is parced in parent: SolveHandler
   var cTypeHandler: CTypeHandler?
    
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
        
        if cTypeHandler != nil {
            return res.filter { $0.cubeType == cTypeHandler!.selected }
        } else {
            return res
        }
        
        print("getSolvesFrom(tf: Timeframe) tf = ", timeframe.rawValue);
        print("getSolvesFrom(tf: Timeframe) was called, ", res.count, " items returned!")
    }
    
    /*
     *  returns all solves with a provided cubeType, not a based on timeframe
     */
    public func getSolvesFrom(ct: CubeType) -> [SolveItem] {
        var res: [SolveItem] = []
        
        for s in solves {
            if s.cubeType.equals(ct) {
                res.append(s)
            }
        }
        
        return res
    }
    
    
    
    
    /*
     *  Returns a list of solves from the provided timegroup
     */
    public func getSolvesFrom(tg: TimeGroup) -> [SolveItem] {
        
        var res: [SolveItem] = []
        let sGroup = getSolvesFrom(ct: cTypeHandler!.selected!)
        
        for s in sGroup {
            if s.getTimeGroup() == tg {
                res.append(s)
            }
        }
        
        return res
        
        
        /*
        var res: [SolveItem] = []
        let now = Date()
        let cal = Calendar.current
        
        // the solves to be analyzed
        let sGroup = getSolvesFrom(ct: cTypeHandler!.selected!)
        
        let weekAgo: Date = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let dayAgo: Date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        
        switch tg {
            case .today:
                for s in sGroup {
                    if cal.isDateInToday(s.timestamp) {
                        res.append(s)
                    }
                }
            break
            
            case .Unknown:
                break
            case .yesterday:
                for s in sGroup {
                    if cal.isDateInYesterday(s.timestamp) {
                        res.append(s)
                    }
                }
            case .lastWeek:
                // check yesterday - lastweek
                let rangeW = dayAgo...weekAgo
                for s in sGroup {
                    if rangeW.contains(s.timestamp) {
                        res.append(s)
                    }
                }
            case .thisMonth:
                // check last week - this month
                let rangeM = weekAgo...monthAgo
                for s in sGroup {
                    if rangeM.contains(s.timestamp) {
                        res.append(s)
                    }
                }
            case .lastMonth:
                // check this month - last month
                let monthAgo2: Date = Calendar.current.date(byAdding: .month, value: -2, to: now)!
                let range2M = monthAgo...monthAgo2
                for s in sGroup {
                    if range2M.contains(s.timestamp) {
                        res.append(s)
                    }
                }
            default:
                res.append(contentsOf: getSolvesFrom(month: tg))
                break
        }
        
        return res
        */
    }
    
    
    /*
     * returns the solves within a given month
     */
    public func getSolvesFrom(month: TimeGroup) -> [SolveItem] {
        let sGroup = getSolvesFrom(ct: cTypeHandler!.selected!)
        var res: [SolveItem] = []
        for s in sGroup {
            if s.timestamp.month == month.rawValue {
                res.append(s)
            }
        }
        
        return res
    }
    
    
    
    /*
     *  returns the timegroups needed for all views
     */
    public func getApplicableTimeGroups() -> [TimeGroup] {
        
        
        let sGroup = getSolvesFrom(ct: cTypeHandler!.selected!)
        var res: [TimeGroup] = []
        for s in sGroup {
            let tempTG = s.getTimeGroup()
            if !res.contains(tempTG)  {
                res.append(tempTG)
            }
        }
        
        return res
        
        /*
        var res: [TimeGroup] = []
        let now = Date()
        let cal = Calendar.current
        
        // this is the group of solves we want to query
        let sGroup = getSolvesFrom(ct: cTypeHandler!.selected!)
        
        // check today
        for s in sGroup {
            if cal.isDateInToday(s.timestamp) {
                res.append(.today)
                break
            }
        }
        
        // check yesterday
        for s in sGroup {
            if cal.isDateInYesterday(s.timestamp) {
                res.append(.yesterday)
                break
            }
        }
        
        
        // check yesterday - lastweek
        let weekAgo: Date = Calendar.current.date(byAdding: .day, value: -7, to: now)!
        let dayAgo: Date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        let rangeW = weekAgo...dayAgo
        for s in sGroup {
            if rangeW.contains(s.timestamp) {
                res.append(.lastWeek)
                break
            }
        }
        
        
        // check last week - this month
        let monthAgo: Date = Calendar.current.date(byAdding: .month, value: -1, to: now)!
        let rangeM = monthAgo...weekAgo
        for s in sGroup {
            if rangeM.contains(s.timestamp) {
                res.append(.thisMonth)
                break
            }
        }
        
        // check this month - last month
        let monthAgo2: Date = Calendar.current.date(byAdding: .month, value: -2, to: now)!
        let range2M = monthAgo2...monthAgo
        for s in sGroup {
            if range2M.contains(s.timestamp) {
                res.append(.lastMonth)
                break
            }
        }
        
        // add rest of the monts
        res.append(contentsOf: getMonthsWithSolves(excludeLast: 2))
        
        return res
        
        // check last year
        // yeah maybe some other time
        */
    }
    
    
    
    /*
     * returns enum of months with solves in them
     */
    private func getMonthsWithSolves(excludeLast: Int = 0) -> [TimeGroup] {
        
        var res: [TimeGroup] = []
        let now = Date()
        let cal = Calendar.current

        
        // load in months with existing solves
        var monthStrings: [String] = []
        for s in solves {
            let nM: String = s.timestamp.month
            if !monthStrings.contains(nM) {
                monthStrings.append(nM)
            }
        }
        
        // remove last 2 months
        for i in 0..<excludeLast {
            let m: String = cal.date(byAdding: .month, value: i, to: now)!.month // gets month - i
            monthStrings = monthStrings.filter { $0 != m } // remove matching strings
        }
        
        
        // map strings to enum
        for mString in monthStrings {
            let mEnum = TimeGroup(rawValue: mString)
            res.append(mEnum!)
        }
        
        return res
        
    }
    
    
    
    
    
    /*
     *  Returns an array of the timeframs which are needed for all the solves
     
        * I am moving this to SolveHandler so it can take into account the cubeType
 
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
     
  */

    
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

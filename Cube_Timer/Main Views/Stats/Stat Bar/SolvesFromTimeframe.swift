//
//  SolvesFromTimeframe.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/26/20.
//

import Foundation
import SwiftUI


enum Timeframe: String {
    case Unknown = "unknown"
    case LastThree = "3X"
    case Today = "1D"
    case OneMonth = "1M"
    case ThreeMonths = "3M"
    case Year = "1Y"
    case All = "ALL"
}
class SolvesFromTimeframe: ObservableObject {
    
    var solves: [SolveItem] // array of all the solves
    var size: Int   // amount of solves
    
    //WILL NEED TO BE UPDATED: should be redundant
    var timeframe: Timeframe // current timeframe
    
    /*
     *  Inits an empty object
     *  No callers
     */
    init() {
        self.solves = []
        self.size = 0
        self.timeframe = .Unknown
    }
    
    /*
     *  Inits and sets a timeframe
     *  No known callers
     */
    init(_ tf: Timeframe) {
        self.solves = []
        self.size = 0
        self.timeframe = tf
    }
    
    /*
     *  Replaces contents of self.solves with priveded array
     *  Called by SolveHandler().updateTimeFrames();
     
     *  THIS SHOHLD BE DELETED
     */
    func replaceWith(_ ar: [SolveItem]) {
        self.solves = ar
        self.size = ar.count
    }
    
    /*
     *  Returns an array of SingleStatBar objects corresponding to this timeframe
     *  Called by StatsBarView.swift -> body from within a foreach loop
     
     *  THIS SHOULD BE MOVED TO SOLVEHANDLER: and be renamed updateBars()
     */
    func getBars() -> [SingleStatBar] {
        
        if size < 1 {
            return []
        }
        
        var numOfBars: Int {
            /*
            if size <= 9 {
                return size * 2
            } else if size < 20 {
                return 30
            }
 */
            return 30
        }
        
        let orderedSolves = solves.sorted(by:{ $0.timeMS < $1.timeMS })
        
        let singleBarRepresentation: Double = getRange() / Double(numOfBars)
        
        var heightArray = [[SolveItem]](repeating: [], count: numOfBars)
        var barIntervals = [Double](repeating: -1, count: numOfBars)
        
        for i in 0...numOfBars - 1 { // fills the barInterval array with solvetimes
            barIntervals[i] = (getMin().timeMS /* +c is the minimum solve time */ ) + singleBarRepresentation * Double(i)
        }
        
        // place the solveItems in the corresponding heightArray index
        var currentBar: Int = 0
        for s in orderedSolves {
            let ms = s.timeMS
            if ms < barIntervals[currentBar] {
                heightArray[currentBar].append(s)
            } else {
                while (currentBar < heightArray.count - 1) && (ms > barIntervals[currentBar]){ // guart incase we go over
                    currentBar += 1
                }
                heightArray[currentBar].append(s)
            }
        }
        
        // fill the heightArray with the corresponding solveTimes
        var res: [SingleStatBar] = []
        var min: Double = getMin().timeMS
        var range: Double = getRange()
        let maxheight: CGFloat = CGFloat(range)
    
        for height in heightArray {
            
            let pct: Double = Double(height.count) / getMaxBarHeight(heightArray)
            let bar: SingleStatBar = SingleStatBar(maxHeight: maxheight, percentage: pct)
            //print("pct: ", pct)
            res.append(bar)
            
        }
        
        /* prints the height array
        print("==================== HEIGHT ARRAY ==================")
        for (index, h) in heightArray.enumerated() {
            print("Bar \(index), which is solves under \(barIntervals[index]) has \(h.count) solves")
        }
        */
        
        return res
    }
    
    /*
     *  Returns a double representing the number of solves in the heighest bar
     *  Called by self.getBars()
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    private func getMaxBarHeight(_ ar: [[SolveItem]]) -> Double {
        var maxCount:Double = -1
        for i in ar {
            if i.count > Int(maxCount) {
                maxCount = Double(i.count)
            }
        }
        return maxCount
    }
  
    
    /*
     *  Returns the SolveItem with the max solve time
     *  Called by self.getRange() and 1 thigs in StatsBarView.swift->body & 2 things in StatsLast3View.swift->body
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getMax() -> SolveItem {
        var max: Double = -1
        var si: SolveItem = SolveItem()
        for s in solves {
            let solve = s as SolveItem
            if max < solve.timeMS {
                max = solve.timeMS
                si = solve
            }
        }
        
        return si
    }
    
    /*
     *  Returns the SolveItem with the min solve time
     *  Called by self.getBars() & self.getRange() and 1 thigs in StatsBarView.swift->body & 2 things in StatsLast3View.swift->body
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getMin() -> SolveItem {
        var min: Double = 99999999999
        var si: SolveItem = SolveItem()
        for s in solves {
            let solve = s as SolveItem
            if min > solve.timeMS {
                min = solve.timeMS
                si = solve
            }
        }
        
        return si
    }
    
    /*
     *  Returns a TimeCapture of the average solve time
     *  Called 1 thing in StatsBarView.swift->body & 2 things in StatsLast3View.swift->body
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getAverage() -> TimeCapture  {
        var max: Double = 0
        for s in solves {
            let solve = s as SolveItem
            max += solve.timeMS
        }
        
        return TimeCapture(max / Double(size))
    }
    
    /*
     *  Returns the range of solve times as a Double
     *  Called by self.getBars()
     
     *  SHOULD BE MOVED TO SolveHandler.swift
     */
    func getRange() -> Double {
        return getMax().timeMS - getMin().timeMS
    }
    
    /*  No known callers
     *  IDK what this is or does
    func add(_ ar: [SolveItem]) {
        for s in ar {
            add(s)
        }
    }
    
    func add(_ s: SolveItem) {
        solves.append(s)
        self.size += 1
    }
     */
    
}

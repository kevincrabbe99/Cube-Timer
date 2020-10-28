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
    
    var solves: [SolveItem]
    var size: Int
    var timeframe: Timeframe
    
    init() {
        self.solves = []
        self.size = 0
        self.timeframe = .Unknown
    }
    
    init(_ tf: Timeframe) {
        self.solves = []
        self.size = 0
        self.timeframe = tf
    }
    
    func replaceWith(_ ar: [SolveItem]) {
        self.solves = ar
        self.size = ar.count
    }
    
    func getBars() -> [SingleStatBar] {
        
        var numOfBars: Int {
            if size <= 9 {
                return size
            } else if size < 25 {
                return size / 2
            }
            return 25
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
                if currentBar < heightArray.count - 1 { // guart incase we go over
                    currentBar += 1
                        heightArray[currentBar].append(s)
                }
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
        
        print("==================== HEIGHT ARRAY ==================")
        for (index, h) in heightArray.enumerated() {
            print("Bar \(index), which is solves under \(barIntervals[index]) has \(h.count) solves")
        }
        
        return res
    }
    
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
    func getSolvesOrderedByTimeStamp() -> [SolveItem] {
        return solves.sorted
    }
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
    
    func getAverage() -> TimeCapture  {
        var max: Double = 0
        for s in solves {
            let solve = s as SolveItem
            max += solve.timeMS
        }
        
        return TimeCapture(max / Double(size))
    }
    
    func getRange() -> Double {
        return getMax().timeMS - getMin().timeMS
    }
    
    func add(_ ar: [SolveItem]) {
        for s in ar {
            add(s)
        }
    }
    
    func add(_ s: SolveItem) {
        solves.append(s)
        self.size += 1
    }
    
}

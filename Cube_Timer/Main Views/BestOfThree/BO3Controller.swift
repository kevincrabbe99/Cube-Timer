//
//  BO3Controller.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/25/20.
//

import Foundation
import SwiftUI

class BO3Controller: ObservableObject {
    
    
    var CTypeHandler: CTypeHandler!
    var solveHandler: SolveHandler!
    var timerController: TimerController!
    
    /*
    @Published var bestDiff: String = ""
    @Published var worstDiff: String = ""
    @Published var averageDiff: String = ""
    */
    
    @Published var best: TimeCapture  = TimeCapture()
    @Published var worst: TimeCapture = TimeCapture()
    @Published var average: Double = -1
    
    //var body: BestOfThreeView = BestOfThreeView()
    
    @Published var solves: [SolveItem] = []
    
    var clearedTime: Date = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    
    /*
     *  fake constructor
     */
    
    
    /*
    init(s: SolveHandler, t: TimerController) {
        self.body = BestOfThreeView(c: self)
    }
 */
    
    /*
     *  used to creat a "new game"
     */
    public func clear() {
        clearedTime = Date()
        update()
    }
    
    /*
     * loads last 3 solves from solveHandler
     * used when user wants to cancel a game
     */
    public func load3Solves() {
        clearedTime = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        update()
    }
    
    public func add(_ s: SolveItem) {
        solves.append(s)
    }
    
    public func delete(_ s: SolveItem) {
        solves = solves.filter { $0 != s } // delete self copy
        solveHandler.delete(s) // delete global copy
    }
    
    public func update() {
        
        updateSolves()
        
        updateBest()
        updateWorst()
        updateAverage()
        
    }
    
    private func updateSolves() {
     
        print("updating bo4 count: ", solves.count)
        self.solves = [] // clear the array
        for s in solveHandler.last3 {
            if s.timestamp.compare(clearedTime) == .orderedDescending {
                print("appending: \(s.timestamp)")
                self.solves.append(s)
            }
        }
        
    }
    
    private func updateBest() {
        if solves.count <= 0 {
            return
        }
        
        var b = solves[0]
        for solve in solves {
            if solve.timeMS < b.timeMS {
                b = solve
            }
        }
        self.best = b.getTimeCapture() ?? TimeCapture()
    }
    
    private func updateWorst() {
        if solves.count <= 0 {
            return
        }
        
        var w = solves[0]
        for solve in solves {
            if solve.timeMS > w.timeMS {
                w = solve
            }
        }
        self.worst = w.getTimeCapture() ?? TimeCapture()
    }
    
    private func updateAverage() {
        if solves.count <= 0 {
            return
        }
        
        var res: Double = 0
        for solve in solves {
            res += solve.timeMS
        }
        self.average = res / Double(solves.count)
    }
    
    
    
    /*
    let lrc = timerController.lastRecordedTime
    self.solves = solveHandler.last3
    
    let best = solveHandler.getMin().timeMS
    
    if lrc == 0 {
        bestDiff = ""
    } else if lrc < best { // if under best
        var diffMS = solveHandler.getMin().timeMS - timerController.lastRecordedTime
        diffMS *= 1
        bestDiff =  "(-\(TimeCapture(diffMS).getInSolidForm()))"
    } else { // if over best
        var diffMS = timerController.lastRecordedTime - solveHandler.getMin().timeMS
        diffMS *= 1
        bestDiff =  "(+\(TimeCapture(diffMS).getInSolidForm()))"
    }


    let worst = solveHandler.getMax().timeMS
    
    if lrc == 0 {
        worstDiff =  ""
    } else if lrc < worst { // if under best
        var diffMS = solveHandler.getMax().timeMS - timerController.lastRecordedTime
        diffMS *= 1
        worstDiff = "(-\(TimeCapture(diffMS).getInSolidForm()))"
    } else { // if over best
        var diffMS = timerController.lastRecordedTime - solveHandler.getMax().timeMS
        //diffMS *= 1
        worstDiff = "(+\(TimeCapture(diffMS).getInSolidForm()))"
    }


    let average = solveHandler.getAverage().timeInMS
    
    if lrc == 0 {
        averageDiff = ""
    } else if lrc < average { // if under best
        var diffMS = solveHandler.getAverage().timeInMS - timerController.lastRecordedTime
        diffMS *= 1
        averageDiff = "(-\(TimeCapture(diffMS).getInSolidForm()))"
    } else { // if over best
        var diffMS = timerController.lastRecordedTime - solveHandler.getAverage().timeInMS
        diffMS *= 1
        averageDiff = "(+\(TimeCapture(diffMS).getInSolidForm()))"
    }
     */
    
    
}

//
//  DetailsViewController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/14/21.
//

import Foundation

class DetailsViewController: ObservableObject {
    
    var cvc: ContentViewController!
    var solveItem: SolveItem!
    var allSolveController: AllSolvesController!
    
    init() {
        
    }
    
    public func goto(solveItem: SolveItem) {
        self.solveItem = solveItem
    }
    
    
    public var hasSolveItem: Bool {
        if solveItem == nil {
            return false
        } else {
            return true
        }
    }
    
    
    
    var readableDate: String {
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        return  df.string(from: solveItem!.timestamp)
    }
    
    var compareAvg: TimeCapture {
        return TimeCapture(solveItem!.timeMS - allSolveController.average!)
    }
    
    var compareMed: TimeCapture {
        return TimeCapture(solveItem!.timeMS - allSolveController.median)
    }
    
    var compareBest: TimeCapture {
        return TimeCapture(solveItem!.timeMS - allSolveController.best!.timeMS)
    }
    
    var compareWorst: TimeCapture {
        return TimeCapture(allSolveController.worst!.timeMS - solveItem!.timeMS)
    }
    
    
}

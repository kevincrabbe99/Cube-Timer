//
//  DetailsViewController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/14/21.
//

import Foundation
import SwiftUI

class DetailsViewController: ObservableObject {
    
    var cvc: ContentViewController!
    @Published var solveItem: SolveItem!
    var allSolveController: AllSolvesController!
    var solveHandler: SolveHandler!
    
    @Published public var isFavorite: Bool = false
    
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        
    }
    
    public func goto(solveItem: SolveItem) {
        self.solveItem = solveItem
        self.isFavorite = solveItem.isFavorite
    }
    
    
    public var hasSolveItem: Bool {
        if solveItem == nil {
            return false
        } else {
            return true
        }
    }
    
    
    public func toggleIsFavorite() {
        lightTap.impactOccurred()
        self.isFavorite = self.solveItem.toggleFavorite()
        self.allSolveController.updateSolves()
    }
    
    
    var readableDate: String? {
        
        if solveItem == nil {
            return "Error #3kf20"
        }
        
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy hh:mm:ss a"
        return  df.string(from: solveItem?.timestamp ?? Date())
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

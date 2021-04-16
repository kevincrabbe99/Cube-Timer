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
    
    var compareAvg: String {
        
        if solveItem.timeMS > allSolveController.average! {
            return "+\(TimeCapture(solveItem!.timeMS - allSolveController.average!).getInSolidForm())"
        } else {
            return "-\(TimeCapture(allSolveController.average! - solveItem!.timeMS).getInSolidForm())"
        }
        
    }
    
    var compareMed: String {
        if solveItem.timeMS > allSolveController.median {
            return "+\(TimeCapture(solveItem!.timeMS - allSolveController.median).getInSolidForm())"
        } else {
            return "-\(TimeCapture(allSolveController.median - solveItem!.timeMS).getInSolidForm())"
        }
    }
    
    var compareBest: String {
        if solveItem.timeMS > allSolveController.best!.timeMS {
            return "+\(TimeCapture(solveItem!.timeMS - allSolveController.best!.timeMS).getInSolidForm())"
        } else {
            return "-\(TimeCapture(allSolveController.best!.timeMS - solveItem!.timeMS).getInSolidForm())"
        }
    }
    
    var compareWorst: String {
        if solveItem.timeMS > allSolveController.worst!.timeMS {
            return "+\(TimeCapture(solveItem!.timeMS - allSolveController.worst!.timeMS).getInSolidForm())"
        } else {
            return "-\(TimeCapture(allSolveController.worst!.timeMS - solveItem!.timeMS).getInSolidForm())"
        }
    }
    
    var zScore: String {
        let zScore = ( solveItem.timeMS - allSolveController.average! ) / allSolveController.stdDev!
        return "\(zScore.rounded(toPlaces: 2))"
    }
    
    var percentile: String {
        
        let allSolvesOrderedByTimeMS = allSolveController.getSolvesOrderedByTimeMS()
        
        let index: Double = Double( allSolvesOrderedByTimeMS.firstIndex(of: self.solveItem)! )
        let total: Double = Double(allSolvesOrderedByTimeMS.count)
        
        print("index: ", index)
        print("total: ", total)
        
        let percentile: Double = (index / total) * 100
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1

        // Avoid not getting a zero on numbers lower than 1
        // Eg: .5, .67, etc...
        formatter.numberStyle = .decimal
        
        
        return "%\(  Int(percentile))"
        
    }
    
    
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//
//  SolveElementController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import Foundation
import SwiftUI

class SolveElementController: ObservableObject, Identifiable, Equatable {
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    let hapticGenerator = UINotificationFeedbackGenerator()
    
    static func == (lhs: SolveElementController, rhs: SolveElementController) -> Bool {
        if lhs.id == rhs.id {
            return true
        } else {
            return false
        }
    }
    
    
    var id: String
    var si: SolveItem
    
    //var view: SolveElementView?
    
    // this is so we can check if this.si is in the selected array
    var allSolvesController: AllSolvesController
    
    @Published var time: TimeCapture = TimeCapture(0)
    @Published var date: Date = Date()
    
    @Published var selected: Bool = false
    
    
    var displayLabel: String {
        return "work"
    }
    
    
    // sets the color green if the solve is the best solve
    var bgColor: Color {
        if allSolvesController.best == si {
            return Color.init("green").opacity(0.8)
        }
        if allSolvesController.worst == si {
            return Color.init("red").opacity(0.8)
        }
        return Color.init("mint_cream").opacity(0.2)
    }
    
    var textColor: Color {
        if allSolvesController.best == si || allSolvesController.worst == si {
            return Color.init("very_dark_black")
        }
        return Color.init("mint_cream")
    }
    
    
    
    init(si: SolveItem, allSolvesController: AllSolvesController) {
        self.si = si
        self.id = si.id
        self.allSolvesController = allSolvesController
    }
    
    /*
     * called by view, then alerts AllSolvesView of its selected state
     */
    public func tapped() {
        print("tapped!")
        
        DispatchQueue.main.async {
            self.lightTap.impactOccurred()
        }
        
        // if ASC isSelecting the rout to longPress
        // else tapSolveItem
        if allSolvesController.selecting {
            longPressed()
        } else {
            // tap solve item -> openVideo
            allSolvesController.openDetailsFor(solveItem: si)
        }
        
    }

    public func longPressed() {
        lightTap.impactOccurred()
        
        if !selected { // if not selected
            self.selected = true
            allSolvesController.tap(self)
        } else { // if selected
            self.selected = false
            allSolvesController.uptap(self)
        }
        
    }
    
    /*
     *  called by allSolvesController when ie. unselectAll
     */
    public func untap() {
        self.selected = false
    }
    
    /*
     * force select
     */
    public func forceSelect() {
        hapticGenerator.notificationOccurred(.success)
        self.selected = true
        allSolvesController.forceSelect(self)
    }
    
    public func forceUnselect() {
        self.selected = false
        allSolvesController.forceUnSelect(self)
    }
    
    public func updateSelfFromObj() {
        self.time = si.getTimeCapture()!
        self.date = si.timestamp
    }
    
    
  
}

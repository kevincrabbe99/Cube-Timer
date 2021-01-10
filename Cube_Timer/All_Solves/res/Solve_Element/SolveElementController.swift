//
//  SolveElementController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import Foundation
import SwiftUI

class SolveElementController: ObservableObject, Identifiable, Equatable {
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
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    
    // sets the color green if the solve is the best solve
    var bgColor: Color {
        if allSolvesController.best == si {
            return Color.init("green")
        }
        if allSolvesController.worst == si {
            return Color.init("red")
        }
        return Color.init("mint_cream").opacity(0.1)
    }
    
    var textColor: Color {
        if allSolvesController.best == si || allSolvesController.worst == si {
            return Color.init("whiteORblack")
        } else if selected {
            return Color.white
        }
        return Color.init("blackORwhite")
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
    
    
    public func updateSelfFromObj() {
        self.time = si.getTimeCapture()!
        self.date = si.timestamp
    }
    
    
  
}

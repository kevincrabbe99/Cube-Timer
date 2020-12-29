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
    
    init(si: SolveItem, allSolvesController: AllSolvesController) {
        self.si = si
        self.id = si.id
        self.allSolvesController = allSolvesController
    }
    
    public func tapped() {
        
        print("tapped!")
        
        if !selected { // if not selected
            self.selected = true
            allSolvesController.tap(self)
        } else { // if selected
            self.selected = false
            allSolvesController.uptap(self)
        }
        
    }
    
    
    public func updateSelfFromObj() {
        self.time = si.getTimeCapture()!
        self.date = si.timestamp
    }
    
    
    /*
     *  returns the view attribute, if it doesnt exist then we create one
    public func getView() -> SolveElementView {
        if hasView() {
            return view!
        } else {
            self.initView()
            return self.view!
        }
    }
    
    /*
     * this is called upon creation to create the View object
            why? because fuck structs and we can't initiate anything with self
     */
    public func initView() {
        let nSCTV: SolveElementView = SolveElementView(si: si)
        self.updateSelfFromObj()
        self.view = nSCTV
    }
     */
    /*
    private func hasView() -> Bool {
        if self.view == nil {
            return false
        }
        return true
    }
    */
}

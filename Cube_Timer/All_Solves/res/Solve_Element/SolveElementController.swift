//
//  SolveElementController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import Foundation
import SwiftUI

class SolveElementController: ObservableObject, Identifiable {
    
    var id: String
    var si: SolveItem
    
    var view: SolveElementView?
    
    @Published var time: TimeCapture = TimeCapture(0)
    @Published var date: Date = Date()
    
    init(si: SolveItem) {
        self.si = si
        self.id = si.id
        
    }
    
    
    public func updateSelfFromObj() {
        self.time = si.getTimeCapture()!
        self.date = si.timestamp
    }
    
    
    /*
     *  returns the view attribute, if it doesnt exist then we create one
     */
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
    
    private func hasView() -> Bool {
        if self.view == nil {
            return false
        }
        return true
    }
}

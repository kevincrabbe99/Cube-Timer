//
//  CTEditController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/20/20.
//

import Foundation
import SwiftUI

class CTEditController: ObservableObject {
    
    var cTypeHandler: CTypeHandler!
    
    // used to set the position of the popup when the keyboard is being used
    @Published var popupOffsetY: CGFloat = 0
    @Published var popupOffsetX: CGFloat = 0 // stupid af that I have to put this here
    
    public func offsetPopup(x: CGFloat = 0, y: CGFloat = 0) {
        self.popupOffsetY = y
        self.popupOffsetX = x
    }
    
    public func unfocusTextField() {
        self.popupOffsetX = 0
        self.popupOffsetY = 0
    }
    
    public func deleteCT(id: UUID) {
        cTypeHandler.delete(id)
    }
    
    public func addCT(d1: Int, d2: Int, d3: Int, desc: String) {
        cTypeHandler.add(d1: d1, d2: d2, d3: d3, desc: desc)
    }
    
}

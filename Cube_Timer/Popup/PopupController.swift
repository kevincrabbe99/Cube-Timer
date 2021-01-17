//
//  PopupController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import Foundation
import SwiftUI


class PopupController: ObservableObject {
    
   var cvc: ContentViewController!
    
    var contentView: ContentView!
    var cTypeHandler: CTypeHandler!
    
    // popup positioning
    @Published var popupOffsetY: CGFloat = 0
    @Published var popupOffsetX: CGFloat = 0
    
    @Published var currentView: AnyView = AnyView(PopupError())
    
    func set(_ pvg: AnyView) {
        self.currentView = AnyView(pvg)
    }
    
    public func offsetPopup(x: CGFloat = 0, y: CGFloat = 0) {
        self.popupOffsetY = y
        self.popupOffsetX = x
    }
    
    public func unfocusTextField() {
        self.popupOffsetX = 0
        self.popupOffsetY = 0
    }
    
    public func hidePopup() {
        cvc.hidePopup()
    }
    
}

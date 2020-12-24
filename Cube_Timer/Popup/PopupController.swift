//
//  PopupController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import Foundation
import SwiftUI


class PopupController: ObservableObject {
    
    var contentView: ContentView!
    var cTypeHandler: CTypeHandler!
    
    @Published var currentView: AnyView = AnyView(PopupError())
    
    func set(_ pvg: AnyView) {
        self.currentView = AnyView(pvg)
    }
    
    
    
}

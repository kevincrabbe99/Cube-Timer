//
//  ScrambleTurnController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/26/21.
//

import Foundation
import SwiftUI

class ScrambleTurnController: ObservableObject, Identifiable {
    
    var id: UUID
    
    @Published var value: String = ""
    
    init() {
        id = UUID()
    }
    
    convenience init(_ v: String) {
        self.init()
        self.value = v
    }
    
    convenience init(_ v: turns) {
        self.init()
        self.value = v.rawValue
    }
    
    public func set(_ v: String) {
        self.value = v
    }
    
    public func set(_ v: turns) {
        self.value = v.rawValue
    }
    
    var isNil: Bool {
        if value.isEmpty {
            return true
        }
        return false
    }
    
    
}

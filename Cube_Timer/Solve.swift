//
//  Solve.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import Foundation
import CoreData

class Solve {

    var id: String
    var type: ConfigType
    var brand: ConfigBrand
    var timeMS: Double
    var timestamp: Double
    
  
    init() {
        id = UUID().uuidString
        type = .a3x3x3
        brand = .rubiks
        timeMS = -1
        timestamp = Date().timeIntervalSinceReferenceDate
    }
    
    
    init(type: ConfigType, brand: ConfigBrand, timeMS: Double) {
        self.id = UUID().uuidString
        self.type = type
        self.brand = brand
        self.timeMS = timeMS
        self.timestamp = Date().timeIntervalSinceReferenceDate
    }
    
    
}

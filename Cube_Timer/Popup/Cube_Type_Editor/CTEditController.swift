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

    
    public func deleteCT(id: UUID) {
        cTypeHandler.delete(id)
    }
    
    public func addCT(d1: Int, d2: Int, d3: Int, desc: String) {
        cTypeHandler.add(d1: d1, d2: d2, d3: d3, desc: desc)
    }
    
}

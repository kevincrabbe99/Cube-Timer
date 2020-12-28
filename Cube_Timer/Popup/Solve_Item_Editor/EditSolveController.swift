//
//  EditSolveController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/27/20.
//

import Foundation
import SwiftUI

class EditSolveController: ObservableObject {
    
    var solvesData: SolvesFromTimeframe!
    var cTypeHandler: CTypeHandler!
    var allSolvesController: AllSolvesController!
    
    public func setCtTo(ct: CubeType, solves: [SolveItem]) {
        solvesData.setCtTo(ct: ct, solves: solves)
        allSolvesController.updateSolves()
        allSolvesController.selected = [] // clear the selected array
    }
    
}

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
    var alertController: AlertController!
    
    public func setCtTo(ct: CubeType, solves: [SolveItem]) {
        solvesData.setCtTo(ct: ct, solves: solves)
        allSolvesController.updateSolves()
        self.alertController.makeAlert(icon: Image.init(systemName: "arrow.turn.down.right"), title: "Switched Groups for Records", text: "Moved \(allSolvesController.selected.count) items to \(ct.descrip)")
        //allSolvesController.selected = [] // clear the selected array
    }
    
}

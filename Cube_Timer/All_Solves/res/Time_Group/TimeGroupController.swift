//
//  TimeGroupController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/26/20.
//

import Foundation
import SwiftUI


class TimeGroupController: ObservableObject, Identifiable {
    
    var allSolvesController: AllSolvesController!
    
    var id: UUID
    @Published var solveElementControllers: [SolveElementController] = []
    @Published var tg: TimeGroup
    
    @Published var height: CGFloat = 0
    
    init(tg: TimeGroup, solves: [SolveItem]) {
        self.id = UUID()
        self.tg = tg
        //self.solves = solves
        
    }
    
    private func setSolveElementControllers(solves: [SolveItem]) {
        solveElementControllers = []
        
        for s in solves {
            solveElementControllers.append(SolveElementController(si: s, allSolvesController: allSolvesController))
        }
    }
    
    /*
     * called right after init by AllSolvesController
     */
    public func setParent(_ p: AllSolvesController) {
        self.allSolvesController = p
    }
    
    
    public func add(s: SolveItem) {
        print("tgc adding solve item to ", tg.rawValue, " : now has ", solveElementControllers.count)
        self.solveElementControllers.append(
            SolveElementController(si: s, allSolvesController: allSolvesController)
        )
        update()
    }

    public func tgLabelTapped() {
    
        if !isAllSelected() {
            for sec in solveElementControllers {
                sec.forceSelect()
            }
        } else {
            for sec in solveElementControllers {
                sec.forceUnselect()
            }
        }
        
    }
    
    private func isAllSelected() -> Bool {
        for sec in solveElementControllers {
            if !sec.selected {
                return false
            }
        }
        return true
    }
    
    
    public func update() {
        
        height = CGFloat((((solveElementControllers.count-1) / (!UIDevice.IsIpad ? 8 : 15)) + 1) * 35)
        //height = CGFloat(((solveElementControllers.count / 8) + 10) * 25)
    }
    
    public func clearSolves() {
        print("clearing solves for ", tg.rawValue)
        self.solveElementControllers = []
    }
    
    
}

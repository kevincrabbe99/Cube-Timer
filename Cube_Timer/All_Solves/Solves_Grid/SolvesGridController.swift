//
//  SolvesGridController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import Foundation
import SwiftUI

/*
class SolvesGridController: ObservableObject {
    // this is where we are receiving data from
    var solvesData: SolvesFromTimeframe! // set from ContentView
    //var parent: AllSolvesView!
    
    /*
    @Published var organizedSolves: [TimeGroup: [SolveElementController]] = [:]
    @Published var timeGroups: [TimeGroup] = []
    */
    
    @Published var tgGridController: [TimeGroupController] = []
    
   // @Published var organizedSolves: [SolveElementController] = []
    
    public func updateSolves() {
        tgGridController = []
        
        print("updating grid view")
        
        self.timeGroups = solvesData.getApplicableTimeGroups()
        
        for tg in timeGroups {
            let solves = solvesData.getSolvesFrom(tg: tg)
            
            for s in solves {
                let nSEC = SolveElementController(si: s)
                organizedSolves[tg]?.append(nSEC)
            }
            
        }
        
        
    }

    /*
    init(sd: SolvesFromTimeframe, parent: AllSolvesView) {
        self.solvesData = sd
        self.parent = parent
    }
    */
    
}
 */

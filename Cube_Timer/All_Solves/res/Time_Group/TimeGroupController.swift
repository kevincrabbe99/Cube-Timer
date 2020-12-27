//
//  TimeGroupController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/26/20.
//

import Foundation
import SwiftUI


class TimeGroupController: ObservableObject, Identifiable {
    
    var id: UUID
    @Published var solves: [SolveItem] = []
    @Published var tg: TimeGroup
    
    @Published var height: CGFloat = 0
    
    init(tg: TimeGroup, solves: [SolveItem]) {
        self.id = UUID()
        self.solves = solves
        self.tg = tg
    }
    
    public func add(s: SolveItem) {
        print("tgc adding solve item to ", tg.rawValue, " : now has ", solves.count)
        self.solves.append(s)
        update()
    }
    
    public func update() {
        
        height = CGFloat(((solves.count / 8) + 1) * 30)
    }
    
    public func clearSolves() {
        print("clearing solves for ", tg.rawValue)
        self.solves = []
    }
    
    
}

//
//  ScrambleController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/25/21.
//

import Foundation

enum turns: String {
    
    
    case r = "R"
    case r2 = "R2"
    case rp = "R'"
    
    case f = "F"
    case f2 = "F2"
    case fp = "F'"
    
    case u = "U"
    case u2 = "U2"
    case up = "U'"
    
    case b = "B"
    case b2 = "B2"
    case bp = "B'"
    
    case l = "L"
    case l2 = "L2"
    case lp = "L'"
    
    case d = "D"
    case d2 = "D2"
    case dp = "D'"
    
}


class ScrambleController: ObservableObject {
    
    var cTypeHandler: CTypeHandler!
    var solveHandler: SolveHandler!
    
    init() {
        generateNewScramble()
    }
    
    let d3TurnOptions: [turns] = [
        .b, .b2, .bp, .d, .d2, .dp, .l, .l2, .lp, .f, .f2, .fp, .r, .r2, .rp, .u, .u2, .up
    ]
    
    var newCurrnetScramble: [ScrambleTurn]  = []
    
    var scrambleToShow: [ScrambleTurn] {
        
        return newCurrnetScramble
        
    }
    
    func generateNewScramble() {
        
        var res: [ScrambleTurn] = []
        
        for _ in 0...19 {
            res.append( ScrambleTurn(d3TurnOptions[Int.random(in: 0..<18)].rawValue ))
        }
        
        self.newCurrnetScramble = res
        
    }
    
    
    
}

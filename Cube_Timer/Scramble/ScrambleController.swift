//
//  ScrambleController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/25/21.
//
enum turns: String {
    
    
    case r = "R"        //  2 ,3, 4, 5, 6, 7
    case r2 = "R2"      //  3, 4, 5, 6, 7
    case rp = "R'"      //  3, 4, 5, 6, 7
    case rW = "Rw"      //  4, 5, 6, 7
    case rWp = "Rw'"    //  4, 5, 6, 7
    case rW2 = "Rw2"    //  4, 5, 6, 7
    case tRw = "3Rw"    //  6, 7
    case tRwp = "3Rw'"  //  6, 7
    case tRw2 = "3Rw2"  //  6, 7
    
    case f = "F"        //  2, 3, 4, 5, 6, 7
    case f2 = "F2"      //  3, 4, 5, 6, 7
    case fp = "F'"      //  3, 4, 5, 6, 7
    case fW = "Fw"      //  4, 5, 6, 7
    case fWp = "Fw'"    //  4, 5, 6, 7
    case fW2 = "Fw2"    //  4, 5, 6
    case tfw = "3Fw"    //  6, 7, 7
    case tfwp = "3Fw'"  //  6, 7
    case tfw2 = "3Fw2"  //  6, 7
    
    case u = "U"        //  2, 3, 4, 5, 6, 7
    case u2 = "U2"      //  3, 4, 5, 6, 7
    case up = "U'"      //  3, 4, 5, 6, 7
    case uW = "Uw"      //  4, 5, 6, 7
    case uWp = "Uw'"    //  4, 5, 6, 7
    case uW2 = "Uw2"    //  4, 5, 6, 7
    case tUw = "3Uw"    //  6, 7
    case tUwp = "3Uw'"  //  6, 7
    case tUw2 = "3Uw2"  //  6, 7
    
    case b = "B"        //  2 ,3, 4, 5, 6, 7
    case b2 = "B2"      //  2 ,3, 4, 5, 6, 7
    case bp = "B'"      //  2 ,3, 4, 5, 6, 7
    case bW = "Bw"      //  3, 7
    case bWp = "Bw'"    //  3, 7
    case bW2 = "Bw2"    //  3, 7
    case tBw = "3Bw"    //  3, 7
    case tBwp = "3Bw'"  //  3, 7
    case tBw2 = "3Bw2"  //  3, 7
    
    case l = "L"        //  3, 4, 5, 6, 7
    case l2 = "L2"      //  3, 4, 5, 6, 7
    case lp = "L'"      //  3, 4, 5, 6, 7
    case lW = "Lw"      //  3, 7
    case lWp = "Lw'"    //  3, 7
    case lW2 = "Lw2"    //  3, 7
    case tlw = "3Lw"    //  3, 7
    case tlwp = "3Lw'"  //  3, 7
    case tlw2 = "3Lw2"  //  3, 7
    
    case d = "D"        //  3, 4, 5, 6, 7
    case d2 = "D2"      //  3, 4, 5, 6, 7
    case dp = "D'"      //  3, 4, 5, 6, 7
    case dW = "Dw"      //  3, 7
    case dWp = "Dw'"    //  3, 7
    case dW2 = "Dw2"    //  3, 7
    case tDw = "3Dw"    //  3, 7
    case tDwp = "3Dw'"  //  3, 7
    case tDw2 = "3Dw2"  //  3, 7
    
}



import Foundation
import SwiftUI

class ScrambleController: ObservableObject {
    
    var cTypeHandler: CTypeHandler!
    var solveHandler: SolveHandler!
    var settingsController: SettingsController!
    var timer: TimerController!
    
    var showingPrevious = false
    
    var shouldMaxamized: Bool {
        if rows > 2 {
            return true
        }
        return false
    }
    
    @Published var isMaxamized: Bool = false
    
    public func unMaxamize() {
        self.isMaxamized = false
    }
    
    public func toggleMaxamize() {
        self.isMaxamized.toggle()
    }
    
    var rows: Int  {
        if cTypeHandler == nil { return 0 }
        
        if cTypeHandler.selected.isCustom() {
            return 0
        }
        
        var r: Int = 0
        
        switch cTypeHandler.selected.getScrambleDimension() {
        case 2:
            r = d2TurnCount / ScrambleController.columns
        case 3:
            r = d3TurnCount / ScrambleController.columns
        case 4:
            r = d4TurnCount / ScrambleController.columns
        case 5:
            r = d5TurnCount / ScrambleController.columns
        case 6:
            r = d6TurnCount / ScrambleController.columns
        case 7:
            r = d7TurnCount / ScrambleController.columns
        default:
            r = 0
        }
        
        return r
    }
    
    var showingScramble: Bool {
        if (timer.timerGoing || timer.oneActivated || timer.bothActivated) {
            return false
        } else {
            if cTypeHandler.selected.isCustom() {
                return false
            } else {
                return true
            }
        }
    }
    
    var dynamicWidth: CGFloat {
        if showingScramble  {
            return UIScreen.main.bounds.width - 200
        } else {
            return 200
        }
    }
    
    var dynamicXPos: CGFloat {
        if showingScramble  {
            return ((UIScreen.main.bounds.width) / 2)
        } else {
            return (UIScreen.main.bounds.width - 150)
        }
    }
    
    var dynamicYPos: CGFloat {
        print("dynamicYPos: ", ((heightBasedOnCount) / 2))
        return ((heightBasedOnCount) / 2) + 30
    }
    
    static let columns: Int = (!UIDevice.IsIpad ? 10 : 30)
    
    /*
     *  returns height of grid area
            * height of cell is 20
            * spacing of 5
     */
    var heightBasedOnCount: CGFloat {
        if self.isMaxamized && rows > 2 {
            return CGFloat((rows+1) * 25)
        } else {
            return 50
        }
    }
    
    
    let d2TurnCount: Int = 12
    let d2TurnOptions: [turns] = [
        turns.r, turns.f, turns.u
    ]
    
    let d3TurnCount: Int = 20
    let d3TurnOptions: [turns] = [
        .b, .b2, .bp, .d, .d2, .dp, .l, .l2, .lp, .f, .f2, .fp, .r, .r2, .rp, .u, .u2, .up
    ]
    
    
    let d4TurnCount: Int = 40
    let d4TurnOptions: [turns] = [
        .f, .f2, .fp, .fW, .fWp, .f2,
        .r, .r2, .rp, .rW, .rWp, .r2,
        .u, .u2, .up, .uW, .uWp, .u2,
        .b, .b2, .bp,
        .d, .d2, .dp,
        .l, .l2, .lp,
    ]
    
    let d5TurnCount: Int = 60
    let d5TurnOptions: [turns] = [
        .f, .f2, .fp, .fW, .fWp, .f2,
        .r, .r2, .rp, .rW, .rWp, .r2,
        .u, .u2, .up, .uW, .uWp, .u2,
        .b, .b2, .bp,
        .d, .d2, .dp,
        .l, .l2, .lp,
    ]

    
    let d6TurnCount: Int = 80
    let d6TurnOptions: [turns] = [
        .f, .f2, .fp, .fW, .fWp, .f2, .tfw, .tfwp, .tfw2,
        .r, .r2, .rp, .rW, .rWp, .r2, .tRw, .tRwp, .tRw2,
        .u, .u2, .up, .uW, .uWp, .u2, .tUw, .tUwp, .tUw2,
        .b, .b2, .bp,
        .d, .d2, .dp,
        .l, .l2, .lp,
    ]
    
    let d7TurnCount: Int = 100
    let d7TurnOptions: [turns] = [
        .f, .f2, .fp, .fW, .fWp, .f2, .tfw, .tfwp, .tfw2,
        .r, .r2, .rp, .rW, .rWp, .r2, .tRw, .tRwp, .tRw2,
        .u, .u2, .up, .uW, .uWp, .u2, .tUw, .tUwp, .tUw2,
        .b, .b2, .bp, .bW, .bWp, .b2, .tBw, .tBwp, .tBw2,
        .d, .d2, .dp, .dW, .dWp, .d2, .tDw, .tDwp, .tDw2,
        .l, .l2, .lp, .lW, .lWp, .l2, .tlw, .tlwp, .tlw2
    ]
    
    var currentTurnCount: Int {
        if cTypeHandler == nil { return 0 }
        
        if cTypeHandler.selected.isCustom() {
            return 0
        }
        
        switch cTypeHandler.selected.getScrambleDimension() {
        case 2:
            return d2TurnCount
        case 3:
            return d3TurnCount
        case 4:
            return d4TurnCount
        case 5:
            return d5TurnCount
        case 6:
            return d6TurnCount
        case 7:
            return d7TurnCount
        default:
            return 0
        }
        
    }
    
    var currentTurnOptions: [turns] {
        
        if cTypeHandler == nil { return [] }
        
        if cTypeHandler.selected.isCustom() {
            return []
        }
        
        switch cTypeHandler.selected.getScrambleDimension() {
        case 2:
            return d2TurnOptions
        case 3:
            return d3TurnOptions
        case 4: // fir 20 should be 3x3x3 then last 40 shuld be all moves
            return d4TurnOptions
        case 5: // all come from d5 options
            return d5TurnOptions
        case 6:
            return d6TurnOptions
        case 7:
            return d7TurnOptions
        default:
            return []
        }
    }
    
    /*
     var scr_mbleToShow: [ScrambleTurn] {
        return currnetScramble
    }
    */
    
    @Published var currnetScramble: [ScrambleTurnController] = []
    init() {
       //self.currnetScramble = [ScrambleTurn](repeating: nil, count: 20)
       //generateNewScramble()
       
       /* self.currnetScramble = [ScrambleTurnController] (repeating: ScrambleTurnController(), count: d7TurnCount)
        for i in d3TurnCount {
            self.currnetScramble.append(ScrambleTurnController())
        }
        */
        
    }
       
   
    
    
    //@Published var currnetScramble: [ScrambleTurnController] = []
    func generateNewScramble() {
        
        if !showingScramble { return }
        
        self.showingPrevious = true
        
        self.currnetScramble = []
        
        for (i) in 0..<currentTurnCount {
            //self.currnetScramble[index] = ScrambleTurn(self.currentTurnOptions[Int.random(in: 0..<self.currentTurnOptions.count-1)].rawValue)
            //cs.set(self.currentTurnOptions[Int.random(in: 0..<self.currentTurnOptions.count-1)])
            self.currnetScramble.append( ScrambleTurnController( self.currentTurnOptions[Int.random(in: 0..<self.currentTurnOptions.count-1)]) )
            
            if i == currentTurnCount-1 {
                self.showingPrevious = false
            }
        }
       
        print(currnetScramble.count, " turns in the scramble" )
        
        if shouldMaxamized {
            self.isMaxamized = true
        } else {
            self.unMaxamize()
        }
        //self.newCurrnetScramble = res
        
    }
    
    
    private func getScrambleCurrentState() -> [ScrambleTurn] {
        var newScramble: [ScrambleTurn] = []
        for i in 0..<currentTurnCount {
            //newScramble.append( ScrambleTurn(self.currentTurnOptions[Int.random(in: 0..<self.currentTurnOptions.count-1)]) )
        }
        print("returning: ", newScramble.count, " turns")
        return newScramble
    }
    
    
    
}

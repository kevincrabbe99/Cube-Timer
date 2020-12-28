//
//  SolveElementView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import SwiftUI

struct SolveElementView: View {
    
    
    /*
    var si: SolveItem!
    var timeGroupController: TimeGroupController?
    var allSolvesController: AllSolvesController?
    //@ObservedObject var controller: SolveElementController
    
    @State var selected: Bool = false
    */
    /*
    init(si: SolveItem?, parentController: TimeGroupController?) {
        self.si = si
        self.timeGroupController = parentController
        self.allSolvesController = parentController!.allSolvesController
        //self.controller = controller
    }
    
    init(si: SolveItem) {
        self.si = si
    }
     */
    
    /*
    public func unselect() {
        self.selected = false
    }
    
    
    public func tapped() {
        
        if timeGroupController == nil { // return if no controller, may need to change if I use this for something other than the solvesgrid
            return
        }
        
        if !isSelected() {
            self.selected = true
            timeGroupController!.tap(si!)
        }else {
            self.selected = false
            timeGroupController!.untap(si!)
        }
    }
    
    public func isSelected() -> Bool {
        if allSolvesController == nil {
            return false
        }
        
        if allSolvesController!.selected.contains(si) {
            return true
        }
        return false
    }
    */
    
    
    @EnvironmentObject var controller: SolveElementController
    var solveItem: SolveItem?
    
    init(/*controller: SolveElementController*/) {
       // self.controller = controller
    }
    
    init(solveItem: SolveItem) {
        self.solveItem = solveItem
    }
    
    
    
    var body: some View {
        
        Button {
            print("tapped 1")
            if controller != nil {
                print("tapped 2")
                controller.tapped()
            }
        } label: {
            ZStack {
                    if controller.selected {
                        Color.init("dark_black")
                            .cornerRadius(3)
                            .opacity(0.2)
                    } else {
                        Color.init("mint_cream")
                            .cornerRadius(3)
                            .opacity(0.2)
                    }
                
                if controller != nil {
                    Text(controller.si.getTimeCapture()?.getInSolidForm() ?? "0:00")
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                } else {
                    Text(solveItem!.getTimeCapture()?.getInSolidForm() ?? "0:00")
                        .fontWeight(.bold)
                        .font(.system(size: 12))
                }
            
            }
            .frame(width: 45, height: 25)
        }

        
    }
}

struct SolveElementView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            SolveElementView()
        }
        .previewLayout(.fixed(width: 100, height: 100))
    }
}

//
//  SolveElementView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import SwiftUI

struct SolveElementView: View {
    
    

    var controller: SolveElementController
    @EnvironmentObject var allSolvesController: AllSolvesController
    var solveItem: SolveItem?
    
    init(controller: SolveElementController) {
       // self.controller = controller
        self.controller = controller
    }
    
    /*
    init(solveItem: SolveItem) {
        self.solveItem = solveItem
    }
    */
    
    /*
     * check allSolvesController.selected to see if this.controller.si is in the view
     honestly this is just fucked
     */
    var isSelected: Bool {
        if allSolvesController.selected.contains( self.controller ) {
            return true
        }
        return false
    }
    
    
    
    var body: some View {
        
        Button {
            print("tapped 1")
            //if controller != nil {
                controller.tapped()
           // }
        } label: {
            ZStack {
                    if isSelected {
                        Color.black
                            .cornerRadius(3)
                            //.opacity(0.2)
                    } else {
                        controller.bgColor
                            .cornerRadius(3)
                            //.opacity(0.2)
                    }
                
                if controller != nil {
                    Text(controller.si.getTimeCapture()?.getInSolidForm() ?? "0:00")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                } else {
                    Text(solveItem!.getTimeCapture()?.getInSolidForm() ?? "0:00")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                }
            
            }
            .frame(width: 45, height: 25)
            .foregroundColor(controller.textColor)
        }

        
    }
}

struct SolveElementView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            SolveElementView(controller: SolveElementController(si: SolveItem(), allSolvesController: AllSolvesController()))
        }
        .previewLayout(.fixed(width: 100, height: 100))
    }
}

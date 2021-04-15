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
     * check allSolvesController.selected to see if this.controller.si is in the view
     honestly this is just fucked
     */
    var isSelected: Bool {
        if allSolvesController.selected.contains( self.controller ) {
            return true
        }
        return false
    }
    
    /*
    var hasVideo: Bool {
        if self.controller.si.videoName != nil {
            return true
        }
        return false
    }
    */
    
    var body: some View {
        
       
            ZStack {
                
               
                /*
                 * background color
                 */
                if isSelected {
                    Color.black
                        .cornerRadius(3)
                        //.opacity(0.2)
                } else {
                    controller.bgColor
                        .cornerRadius(3)
                        //.opacity(0.2)
                }
                
                /*
                 *  apply a RED DOT if the solve has a video saved
                 */
                if controller.si.hasVideo {
                    IconButton(icon: Image.init(systemName: "circle.fill"), bgColor: Color.clear, iconColor: Color.init("red"), width: 9, height: 9)
                        .offset(x: 16.5, y: -7)
                }
                    
                
                //if controller != nil {
                    Text(controller.si.getTimeCapture()?.getInSolidForm() ?? "0:00")
                        .font(Font.custom((controller.selected ? "Chivo-Bold" : "Chivo-Regular"), size: 11))
                /*} else {
                    Text(solveItem!.getTimeCapture()?.getInSolidForm() ?? "0:00")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                }*/
            
            }
            .frame(width: 45, height: 25)
            .foregroundColor(controller.textColor)
            .onTapGesture {
                controller.tapped()
            }
            .onLongPressGesture(minimumDuration: 0.7) {
                controller.longPressed()
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

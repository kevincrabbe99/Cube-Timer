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
    
    var labelDisp: String {
        
        if allSolvesController.solves.count == 0 {
            return "0:00  "
        }
        
        switch allSolvesController.labelDispOption {
        case .time:
            return (controller.si.getTimeCapture()?.getInSolidForm() ?? "0:00")
        case .averageCompare:
            
            //guard self.solveItem != nil else { return String("Not Found @e3dd2") }
            
            if controller.si.timeMS > allSolvesController.average! {
                return "+\(TimeCapture(controller.si.timeMS - allSolvesController.average!).getInSolidForm())"
            } else {
                return "-\(TimeCapture(allSolvesController.average! - controller.si.timeMS).getInSolidForm())"
            }
            
        case .percentile:
            
                
            guard self.controller.si != nil  else { return String("Not Found @039") }
            
            let allSolvesOrderedByTimeMS = allSolvesController.getSolvesOrderedByTimeMS()
            
            guard allSolvesOrderedByTimeMS.firstIndex(of: self.controller.si) != nil else { return String("ERROR @(0djd") }
            
            let index: Double = Double( allSolvesOrderedByTimeMS.firstIndex(of: self.controller.si)! )
            let total: Double = Double(allSolvesOrderedByTimeMS.count)
            
            print("index: ", index)
            print("total: ", total)
            
            let percentile: Double = (index / total) * 100
            
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 1

            // Avoid not getting a zero on numbers lower than 1
            // Eg: .5, .67, etc...
            formatter.numberStyle = .decimal
            
            
            return "%\(  Int(percentile))"
               
        case .zScore:
            
            let zScore = ( controller.si.timeMS - allSolvesController.average! ) / allSolvesController.stdDev!
            return "\(zScore.rounded(toPlaces: 2))"
            
        default:
            return (controller.si.getTimeCapture()?.getInSolidForm() ?? "0:00")
        }
    }
    
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
                    IconButton(icon: Image.init(systemName: "circle.fill"), bgColor: Color.clear, iconColor: Color.init("red"), width: 10, height: 10)
                        .offset(x: 16.5, y: -8)
                }
                
                /*
                 *  apply a yellow star is item is marked favorite
                 */
                if controller.si.isFavorite {
                    IconButton(icon: Image.init(systemName: "star.fill"), bgColor: Color.clear, iconColor: Color.init("yellow"), width: 11, height: 11)
                        .offset(x: -16.5, y: -8)
                }
                    
                
                //if controller != nil {
                Text(self.labelDisp)
                        .font(Font.custom((controller.selected ? "Chivo-Bold" : "Chivo-Regular"), size: 11))
                /*} else {
                    Text(controller.si.getTimeCapture()?.getInSolidForm() ?? "0:00")
                        .fontWeight(.bold)
                        .font(.system(size: 11))
                }*/
            
            }
            .frame(width: 45, height: 25)
            .foregroundColor(controller.textColor)
            .onTapGesture {
                controller.tapped()
            }
            .onLongPressGesture(minimumDuration: 0.2) {
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

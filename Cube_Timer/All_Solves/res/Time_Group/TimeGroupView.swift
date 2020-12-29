//
//  TimeGroupView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/26/20.
//

import SwiftUI

struct TimeGroupView: View {
    
    @ObservedObject var controller: TimeGroupController // this is set via AllSolvesView upon printing
    
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 5), count: 8)
    
    
    
    var body: some View {
        
        if controller.allSolvesController.count != 0 { // only show group if there are existing solves
            
            GeometryReader { geo in
                
                let w: CGFloat = geo.size.width
                
                /*
                 *  the grid which shows the views
                 */
                HStack {
                    
                    
                    /*
                     *  right side, where the time labels are
                     */
                    ZStack {
                        Text(controller.tg.rawValue)
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                    }
                    .frame(width: 65, height: controller.height, alignment: .topTrailing)
                    .offset(y: 3)
                    
                    /*
                     *  the grid of solves
                     */
                    LazyVGrid(columns: gridItemLayout, alignment: .trailing) {
                        ForEach(controller.solveElementControllers) { sec in
                            
                            SolveElementView(controller: sec)
                                //.environmentObject(sec)
                           // SolveElementView(si: s, parentController: controller)
                                //.border(Color.green)
                        }
                    }
                    .frame(width: (w-75))
                
                    
                    //.border(Color.green)
                }
                .frame(width: geo.size.width, alignment: .topTrailing)
                //.border(Color.red)
                /*
                HStack {
                    HStack {
                        ForEach(controller.solves) { s in
                            Text((s.getTimeCapture()?.getInSolidForm())!)
                        }
                    }
                    .frame(width: 200, alignment: .trailing)
                    
                    
                }
                .frame(width: 300, alignment: .leading)
            */
            }
            
        } // end if guard
    }
}

struct TimeGroupView_Previews: PreviewProvider {
    static var previews: some View {
        TimeGroupView(controller: TimeGroupController(tg: .today, solves: []))
    }
}

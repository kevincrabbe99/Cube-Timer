//
//  TimeGroupView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/26/20.
//

import SwiftUI

struct TimeGroupView: View {
    
    @ObservedObject var controller: TimeGroupController // this is set via AllSolvesView upon printing
    
    static var columns: Int {
        if UIDevice.IsIpad {
            return 15
        } else if UIDevice.hasNotch {
            return 8
        } else {
            return 6
        }
    }
    
    @EnvironmentObject var allSolvesController: AllSolvesController
    
    
    var body: some View {
        
        var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 5), count: TimeGroupView.columns)
        
        if controller.allSolvesController.count != 0 { // only show group if there are existing solves
            
            GeometryReader { geo in
                
                let w: CGFloat = geo.size.width
                
                /*
                 *  the grid which shows the views
                 */
                HStack {
                    
                    
                    /*
                     *  left side, where the time labels are
                     */
                    if allSolvesController.order == .time {
                        Button {
                            controller.tgLabelTapped()
                        } label: {
                            
                            ZStack {
                                Text(LocalizedStringKey(controller.tg.rawValue))
                                    .multilineTextAlignment(.trailing
                                    )
                                    .font(Font.custom("Play-Regular", size: 10))
                                    .foregroundColor(.init("mint_cream"))
                                    .opacity(0.8)
                            }
                            
                        }
                        .padding([.trailing], 5)
                        .frame(width: 50, height: controller.height, alignment: .topTrailing)
                        .offset(y: 10)
                        
                    }
                    
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
                    //.frame(width: (w-60))
                    .frame(width: (allSolvesController.order == .time ? w-60 : w - 20 ), height: controller.height)
                
                    
                    //.border(Color.green)
                }
               // .frame(width: geo.size.width, alignment: .topLeading)
                .animation(.linear)
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

//
//  BestOfThreeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/27/20.
//

import SwiftUI

struct BestOfThreeView: View {
    /*
    @ObservedObject var timer: TimerController
    var solveHandler: SolveHandler
    */
    
    // controller
    @ObservedObject var controller: BO3Controller
    
    
    init(c: BO3Controller) {
        self.controller = c
    }
    
    /*
    init(t: TimerController, s: SolveHandler) {
        self.controller.solveHandler = String
        self.controller.timer = t
    }
    */
    
    
    var body: some View {
    
        //if solveHandler.size > 0 { // EXIT: if no solves
        GeometryReader { geo in
            VStack {
                
                /*
                 * the times display
                 */
                HStack(spacing: 30.0) {
                    ForEach(controller.solves) { s in
                        Text(TimeCapture.init(s.timeMS).getAsReadable() )
                            .fontWeight(.bold)
                            .opacity(0.6)
                            .font(.system(size: 13))
                            
                            .gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        print("tapped")
                                        self.controller.delete(s)
                                    }
                            )
                            
                    }
                    
                    /*
                     *  Clear / Load button
                     */
                    if controller.solves.count < 3 { // if not full
                        Button(action: {
                            controller.load3Solves()
                        }) {
                            ZStack {
                                Image(systemName: "arrow.clockwise")
                                    .font(Font.system(size: 13, weight: .bold))
                        
                            }
                            .frame(width: 15, height: 50)
                        }
                    } else { // we can clear
                        Button(action: {
                            controller.clear()
                        }) {
                            ZStack {
                                Image(systemName: "clear")
                            }
                            .frame(width: 15, height: 50)
                        }
                    }
                    
                    
                }
                .frame(width: geo.size.width, height: 30)
                .animation(.spring())
                
                /*
                 * container for the stats
                 */
                VStack {
                    HStack {
                        Text("Best:")
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(width: (geo.size.width/4), alignment: .leading)
                        Text("\(self.controller.best.getAsReadable())" as String)
                            .font(.system(size: 13))
                            .frame(width: (geo.size.width/4), alignment: .trailing)
                            .foregroundColor(Color.init("green"))
                    }
                    .frame(width: geo.size.width - 50, alignment: .center)
                    HStack {
                        Text("Wost:")
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(width: (geo.size.width/4), alignment: .leading)
                        Text("\(self.controller.worst.getAsReadable())" as String)
                            .font(.system(size: 13))
                            .frame(width: (geo.size.width/4), alignment: .trailing)
                            .foregroundColor(Color.init("red"))
                    }
                    .frame(width: geo.size.width - 50, alignment: .center)
                    HStack {
                        Text("Average:")
                            .fontWeight(.bold)
                            .font(.system(size: 13))
                            .frame(width: (geo.size.width/4), alignment: .leading)
                        Text("\(String(format: "%.2f", self.controller.average))s")
                            .font(.system(size: 13))
                            .frame(width: (geo.size.width/4), alignment: .trailing)
                            .foregroundColor(Color.init("yellow"))
                    }
                    .frame(width: geo.size.width - 50, alignment: .center)
                }
                .offset(y: 7)
                .opacity(0.8)
            }
                
        }
            
    }
}

struct BestOfThreeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            BestOfThreeView(c: BO3Controller())
        }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/))
        
    }
}

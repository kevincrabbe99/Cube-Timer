//
//  MainView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/27/20.
//

import SwiftUI

struct MainView: View {
    
    var parent: ContentView
    @ObservedObject var timer: TimerController
    @ObservedObject var solveHandler: SolveHandler
    @ObservedObject var bo3Controller: BO3Controller

    var peripheralOpacity: Double  {
        if timer.timerGoing {
            return -0.3
        }else {
            return 0.5
        }
    }
    
    func gotoPage(_ p: Page) {
        parent.setPageTo(p)
    }
    
    var body: some View {
        GeometryReader { geo in
            Color.init("very_dark_black")
            ZStack {
                
                ButtonsView(timer: timer)
                
                if !(timer.timerGoing || timer.oneActivated) { // only show when there is no timer active
                TimeframeBar(sh: solveHandler)
                    .position(x: geo.size.width/2, y: geo.size.height-50)
                    //.opacity(0.9)
                    .opacity(peripheralOpacity + 0.3)
                    .animation(.easeIn)
                    .transition(.move(edge: .bottom))
                }

                TimerView(p: self, t: timer, s: solveHandler, bo3c: bo3Controller /*solveHandler: solveHandler*/)
                    .offset(y:-30)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(parent: ContentView(), timer: TimerController(), solveHandler: SolveHandler(), bo3Controller: BO3Controller())
    }
}

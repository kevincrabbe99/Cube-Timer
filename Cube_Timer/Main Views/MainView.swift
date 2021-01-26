//
//  MainView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/27/20.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var cTypeHandler: CTypeHandler
    @EnvironmentObject var timer: TimerController
    @EnvironmentObject var settingsController: SettingsController
    
    var parent: ContentView
    //@ObservedObject var timer: TimerController
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
        cvc.setPageTo(p)
    }
    
    var body: some View {
        GeometryReader { geo in
            Color.init("very_dark_black")
            ZStack {
                
               
                
                ButtonsView(timer: timer)
                
                
                if !(timer.timerGoing || timer.oneActivated || timer.bothActivated) { // only show when there is no timer active
                 
                    if !settingsController.pauseSavingSolves {
                        TimeframeBar(sh: solveHandler)
                            .position(x: geo.size.width/2, y: geo.size.height-50)
                            //.opacity(0.9)
                            .opacity(peripheralOpacity + 0.3)
                            .animation(.easeIn)
                            .transition(.move(edge: .bottom))
                        }
                    }

                    TimerView(p: self, t: timer, s: solveHandler, bo3c: bo3Controller /*solveHandler: solveHandler*/)
                        .offset(y:(solveHandler.solves.count > 0 ? 0 : -30))
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(parent: ContentView(), solveHandler: SolveHandler(), bo3Controller: BO3Controller())
            .environmentObject(CTypeHandler())
            .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}

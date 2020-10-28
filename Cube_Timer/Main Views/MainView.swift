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
    //@ObservedObject var solveHandler: SolveHandler = SolveHandler()

    var peripheralOpacity: Double  {
        if timer.startApproved || timer.timerGoing || timer.oneActivated{
            return -0.3
        }else {
            return 0.5
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            Color.init("very_dark_black")
            ZStack {
                
                ButtonsView(timer: timer)
                TopBar(tc: timer)
                    .position(x: geo.size.width/2, y: geo.size.height-50)
                    .opacity(peripheralOpacity + 0.3)
                    .animation(.easeIn)
                StatsPreviewView(timer: timer /*solveHandler: solveHandler*/)
                    .offset(y:-30)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(parent: ContentView(), timer: TimerController())
    }
}

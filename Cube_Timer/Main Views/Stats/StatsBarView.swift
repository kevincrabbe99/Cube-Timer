//
//  StatsBarView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/26/20.
//

import SwiftUI

struct StatsBarView: View {
    
    @ObservedObject var timer: TimerController
    
    var timeframe: Int {
        switch timer.currentTimeframe {
        case .LastThree:
            return 0
        case .Today:
            return 1
        case .OneMonth:
            return 2
        case .ThreeMonths:
            return 3
        case .Year:
            return 4
        case .All:
            return 5
        default:
            return 2
        }
    }
    
    var visibility: Double! {
        if !timer.solveHandler.isTimeframeNil(timer.currentTimeframe) {
            return 1
        }else {
            return 0
        }
    }
    
    
    var body: some View {
        
        ZStack {
            //if !timer.solveHandler.isTimeframeNil(timer.currentTimeframe) {
            
            if timeframe == 0 { // in last 3 mode
                
                StatsLast3View(timer: timer)
                
            } else {
            
                VStack {
                    
                        
                    GeometryReader { geo in
                        HStack(alignment: .bottom, spacing: 4) {
                            
                            
                            ForEach( timer.solveHandler.solvesByTimeframe[timeframe].getBars(), id: \.id ) { bar in
                                bar
                            }
                            
                        }
                        .foregroundColor(.white)
                        .frame(width: 250, height: 50)
                        .animation(.spring())
                    }
                    .frame(width: 250, height: 50)
                
                    HStack {
                        Text( timer.solveHandler.solvesByTimeframe[timeframe].getMin().getTimeCapture()?.getAsReadable() ?? "-" )
                            .font(.system(size: 8))
                            .fontWeight(.bold)
                            .frame(width: 100, alignment: .leading)
                        
                        ZStack {
                            Color.white
                                .cornerRadius(5)
                                .opacity(0.7)
                                .foregroundColor(.init("very_dark_black"))
                                .frame(width: 25, height: 12)
                            
                            Text( String(timer.solveHandler.solvesByTimeframe[timeframe].size) )
                                .font(.system(size: 9))
                                .fontWeight(.bold)
                                .frame(width: 50, alignment: .center)
                        }
                        .frame(width: 15, height: 10)
                        .offset(y: 3)
                        
                        Text( timer.solveHandler.solvesByTimeframe[timeframe].getMax().getTimeCapture()?.getAsReadable() ?? "-" )
                            .font(.system(size: 8))
                            .fontWeight(.bold)
                            .frame(width: 100, alignment: .trailing)
                    }
                    .frame(width: 270, height: 20, alignment: .center)
                    .offset(y: -15)
                    .opacity(0.7)
               
                }
                .opacity(visibility)
                .animation(.easeOut)
            } // end if (last3Mode)
        }
    }
}

struct StatsBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            StatsBarView(timer: TimerController())
            
        }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/300.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/))
        .frame(width: 300, height: 250)
    }
}

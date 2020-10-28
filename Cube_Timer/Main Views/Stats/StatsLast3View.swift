//
//  StatsLast3View.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/27/20.
//

import SwiftUI

struct StatsLast3View: View {
    
    @ObservedObject var timer: TimerController
    
    var bestDiff: String {
        let lrc = timer.lastRecordedTime
        let best = timer.solveHandler.solvesByTimeframe[0].getMin().timeMS
        
        if lrc == 0 {
            return ""
        } else if lrc < best { // if under best
            var diffMS = timer.solveHandler.solvesByTimeframe[0].getMin().timeMS - timer.lastRecordedTime
            diffMS *= 1
            return "(-\(TimeCapture(diffMS).getInSolidForm()))"
        } else { // if over best
            var diffMS = timer.lastRecordedTime - timer.solveHandler.solvesByTimeframe[0].getMin().timeMS
            diffMS *= 1
            return "(+\(TimeCapture(diffMS).getInSolidForm()))"
        }
    }
    
    var worstDiff: String {
        let lrc = timer.lastRecordedTime
        let worst = timer.solveHandler.solvesByTimeframe[0].getMax().timeMS
        
        if lrc == 0 {
            return ""
        } else if lrc < worst { // if under best
            var diffMS = timer.solveHandler.solvesByTimeframe[0].getMax().timeMS - timer.lastRecordedTime
            diffMS *= 1
            return "(-\(TimeCapture(diffMS).getInSolidForm()))"
        } else { // if over best
            var diffMS = timer.lastRecordedTime - timer.solveHandler.solvesByTimeframe[0].getMax().timeMS
            diffMS *= 1
            return "(+\(TimeCapture(diffMS).getInSolidForm()))"
        }
    }
    
    var averageDiff: String {
        let lrc = timer.lastRecordedTime
        let worst = timer.solveHandler.solvesByTimeframe[0].getAverage().timeInMS
        
        if lrc == 0 {
            return ""
        } else if lrc < worst { // if under best
            var diffMS = timer.solveHandler.solvesByTimeframe[0].getAverage().timeInMS - timer.lastRecordedTime
            diffMS *= 1
            return "(-\(TimeCapture(diffMS).getInSolidForm()))"
        } else { // if over best
            var diffMS = timer.lastRecordedTime - timer.solveHandler.solvesByTimeframe[0].getAverage().timeInMS
            diffMS *= 1
            return "(+\(TimeCapture(diffMS).getInSolidForm()))"
        }
    }
    
    
    var body: some View {
    
        ZStack {
            VStack {
                HStack {
                    Text("Best")
                        .frame(width: 50, alignment: .trailing)
                    HStack {
                        Text( timer.solveHandler.solvesByTimeframe[0].getMin().getTimeCapture()?.getAsReadable() ?? "-" )
                            .fontWeight(.bold)
                        Text(bestDiff)
                            .font(.system(size: 10))
                    }
                    .frame(width: 140, alignment: .trailing)
                }
                .frame(width: 200, alignment: .leading)
                HStack {
                    Text("Worst")
                        .frame(width: 50, alignment: .trailing)
                    HStack {
                        Text( timer.solveHandler.solvesByTimeframe[0].getMax().getTimeCapture()?.getAsReadable() ?? "-" )
                            .fontWeight(.bold)
                        Text(worstDiff)
                            .font(.system(size: 10))
                    }
                    .frame(width: 140, alignment: .trailing)
                }
                .frame(width: 200, alignment: .leading)
                HStack {
                    Text("Average")
                        .frame(width: 50, alignment: .trailing)
                    HStack {
                        Text(    timer.solveHandler.solvesByTimeframe[0].getAverage().getAsReadable() )
                            .fontWeight(.bold)
                        Text(averageDiff)
                            .font(.system(size: 10))
                    }
                    .frame(width: 140, alignment: .trailing)
                }
                .frame(width: 200, alignment: .leading)
            }
            .frame(width: 200)
            .font(.system(size: 12))
        }
        .foregroundColor(.white)
        
    }
}

struct StatsLast3View_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            StatsLast3View(timer: TimerController())
        }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/))
        
    }
}

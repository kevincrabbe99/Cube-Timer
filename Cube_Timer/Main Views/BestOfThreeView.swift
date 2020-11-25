//
//  BestOfThreeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/27/20.
//

import SwiftUI

struct BestOfThreeView: View {
    
    @ObservedObject var timer: TimerController
    var solveHandler: SolveHandler
    
    var bestDiff: String {
        let lrc = timer.lastRecordedTime
        let best = solveHandler.getMin().timeMS
        
        if lrc == 0 {
            return ""
        } else if lrc < best { // if under best
            var diffMS = solveHandler.getMin().timeMS - timer.lastRecordedTime
            diffMS *= 1
            return "(-\(TimeCapture(diffMS).getInSolidForm()))"
        } else { // if over best
            var diffMS = timer.lastRecordedTime - solveHandler.getMin().timeMS
            diffMS *= 1
            return "(+\(TimeCapture(diffMS).getInSolidForm()))"
        }
    }
    
    var worstDiff: String {
        let lrc = timer.lastRecordedTime
        let worst = solveHandler.getMax().timeMS
        
        if lrc == 0 {
            return ""
        } else if lrc < worst { // if under best
            var diffMS = solveHandler.getMax().timeMS - timer.lastRecordedTime
            diffMS *= 1
            return "(-\(TimeCapture(diffMS).getInSolidForm()))"
        } else { // if over best
            var diffMS = timer.lastRecordedTime - solveHandler.getMax().timeMS
            diffMS *= 1
            return "(+\(TimeCapture(diffMS).getInSolidForm()))"
        }
    }
    
    var averageDiff: String {
        let lrc = timer.lastRecordedTime
        let worst = solveHandler.getAverage().timeInMS
        
        if lrc == 0 {
            return ""
        } else if lrc < worst { // if under best
            var diffMS = solveHandler.getAverage().timeInMS - timer.lastRecordedTime
            diffMS *= 1
            return "(-\(TimeCapture(diffMS).getInSolidForm()))"
        } else { // if over best
            var diffMS = timer.lastRecordedTime - solveHandler.getAverage().timeInMS
            diffMS *= 1
            return "(+\(TimeCapture(diffMS).getInSolidForm()))"
        }
    }
    
    
    var body: some View {
    
        if solveHandler.size > 0 { // EXIT: if no solves
            
            
            ZStack {
                VStack {
                    HStack {
                        Text("Best")
                            .frame(width: 50, alignment: .trailing)
                        HStack {
                            Text( solveHandler.getMin().getTimeCapture()?.getAsReadable() ?? "-" )
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
                            Text( solveHandler.getMax().getTimeCapture()?.getAsReadable() ?? "-" )
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
                            Text(    solveHandler.getAverage().getAsReadable() )
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
}

struct BestOfThreeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            BestOfThreeView(timer: TimerController(), solveHandler: SolveHandler())
        }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/))
        
    }
}

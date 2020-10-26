//
//  StatsPreviewView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI
import CoreData

struct StatsPreviewView: View {
    
   // @Environment(\.managedObjectContext) private var viewContext
    /*
    @FetchRequest(entity: SolveItem.entity(), sortDescriptors: [])
    var fetchedSolves: FetchedResults<SolveItem>
    */
    
    var type: PuzzleType = .a3x3x3
    var brand: PuzzleBrand = .rubiks
    
    @ObservedObject var timer: TimerController
    //@ObservedObject var solveHandler: SolveHandler
    
    
    var peripheralOpacity: Double  {
        if timer.oneActivated || timer.timerGoing || timer.startApproved {
            return 0
        }else {
            return 0.5
        }
    }
    
    var overUnderTime: String {
        
        var average = timer.solveHandler.average.timeInMS
        var currentTime = timer.lastRecordedTime
        
        if average > currentTime {
            return "- \(TimeCapture( average - currentTime ).getInSolidForm())"
        }else {
            return "+ \(TimeCapture( currentTime - average ).getInSolidForm())"
        }

    }

    var overUnderPercentage: Double {
        let average = timer.solveHandler.average.timeInMS
        let currentTime = timer.lastRecordedTime
        
            return (currentTime / average) * 100
    }
    
    var statColor: Color {
        let average = timer.solveHandler.average.timeInMS
        let currentTime = timer.lastRecordedTime
        
        if average > currentTime {
            return Color.init("green")
        }else  {
            return Color.init("red")
        }
    }

    
    
    
    var body: some View {

        VStack {
            
            HStack {
                Text("\(overUnderTime)")
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                Text("(\(overUnderPercentage, specifier: "%.0f")%)")
                    .font(.system(size: 12))
            }
            .frame(width: 245, alignment: .leading)
            .offset(y: 5)
            .foregroundColor(statColor)
            
            
            /*
            HStack {
                Text(type.getType())
                    .fontWeight(.bold)
                    .padding(.leading, 8.0)
                    .font(.system(size: 12))
                Text(brand.getType())
                    .fontWeight(.bold)
                    .font(.system(size: 12))
            }
            .frame(width: 250.0, alignment: .leading)
            .opacity(peripheralOpacity)
            .animation(.easeIn)
            */
            
            
            StopwatchDisplay(timer: timer)
                .frame(width: 250)
            
            
            
            ZStack {
                Color.init("very_dark_black")
                    .cornerRadius(5)
                    .opacity(0.65)
                HStack(spacing: 30.0) {
                    
                    ForEach(timer.solveHandler.last3) { s in
                        Text(TimeCapture.init(s.timeMS).getAsReadable() )
                            .fontWeight(.bold)
                            .opacity(peripheralOpacity)
                            .font(.system(size: 13))
                            //.animation(.easeIn)
                            .gesture(
                                TapGesture()
                                    .onEnded { _ in
                                        print("tapped")
                                        self.timer.solveHandler.delete(s)
                                    }
                            )
                    }
                    
                }
            }
            .frame(width: 250, height: 20)
            .offset(y: -30)
            
            
            
            VStack {
                HStack {
                    Text("Average")
                        .fontWeight(.bold)
                        .frame(width: 75, alignment: .leading)
                    Text(timer.solveHandler.average.getAsReadable())
                        .frame(width: 100, alignment: .trailing)
                }
                .frame(width: 200)
                HStack {
                    Text("Best")
                        .fontWeight(.bold)
                        .frame(width: 75, alignment: .leading)
                    Text(timer.solveHandler.best.getAsReadable())
                        .frame(width: 100, alignment: .trailing)
                }
                .frame(width: 200)
            }
            .font(.system(size: 15))
            .opacity(peripheralOpacity - 0.1)
            .animation(.easeIn)
            
 
        }
        .foregroundColor(.white)
    }
    
}

struct StatsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
        Color.black
            StatsPreviewView(type: .a3x3x3, brand: .rubiks, timer: TimerController() )
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        .previewLayout(.fixed(width: 250, height: 150))
    }
}

//
//  StatsPreviewView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI


struct StatsPreviewView: View {
    
    var type: ConfigType = .a3x3x3
    var brand: ConfigBrand = .rubiks
    
    @ObservedObject var timer: TimerController
    
    var peripheralOpacity: Double  {
        if timer.oneActivated || timer.timerGoing || timer.startApproved {
            return 0
        }else {
            return 0.5
        }
    }
    

    
    var body: some View {
        VStack {
            
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
            
          
            
            StopwatchDisplay(timer: timer)
                .frame(width: 250)
            
            //if !timer.startApproved {
                Text("00:38:12")
                    .fontWeight(.bold)
                    .opacity(peripheralOpacity)
                    .animation(.easeIn)
                Spacer()
                    .frame(height: 20)
                VStack {
                    HStack {
                        Text("Average")
                            .fontWeight(.bold)
                            .frame(width: 75, alignment: .leading)
                        Text(timer.solveHandler.average)
                            .frame(width: 100, alignment: .trailing)
                    }
                    .frame(width: 200)
                    HStack {
                        Text("Best")
                            .fontWeight(.bold)
                            .frame(width: 75, alignment: .leading)
                        Text(timer.solveHandler.best)
                            .frame(width: 100, alignment: .trailing)
                    }
                    .frame(width: 200)
                }
                .font(.system(size: 15))
                .opacity(peripheralOpacity - 0.1)
                .animation(.easeIn)
            //}
        }
        .foregroundColor(.white)
    }
}

struct StatsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
        Color.black
            StatsPreviewView(type: .a3x3x3, brand: .rubiks, timer: TimerController())
        }
        .previewLayout(.fixed(width: 250, height: 150))
    }
}

//
//  StopwatchDisplay.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/22/20.
//

import SwiftUI

struct StopwatchDisplayView: View {
    
    @ObservedObject var timer: TimerController
    
    var body: some View {
        
        HStack {
            Text(timer.lblMin)
                .font(Font.custom("Chivo-Bold", size: 63))
                .frame(width: 80, height: 60)
            Text(":")
                .font(Font.custom("Chivo-Bold", size: 15))
            Text(timer.lblSec)
                
                .font(Font.custom("Chivo-Bold", size: 63))
                .frame(width: 80, height: 60)
            Text(":")
                .font(Font.custom("Chivo-Bold", size: 15))
            Text(timer.lblMS)
                .font(Font.custom("Chivo-Bold", size: 63))
               // .font(.system(size: 55))
                .frame(width: 80, height: 60)
        }
        .frame(width: 350.0, height: 60, alignment: .center)
        
    }
}

struct StopwatchDisplay_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchDisplayView(timer: TimerController()).previewLayout(PreviewLayout.fixed(width: 300, height: 250))
    }
}

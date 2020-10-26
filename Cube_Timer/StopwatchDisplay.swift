//
//  StopwatchDisplay.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/22/20.
//

import SwiftUI

struct StopwatchDisplay: View {
    
    @ObservedObject var timer: TimerController
    
    var body: some View {
        
        HStack {
            Text(timer.lblMin)
                .fontWeight(.black)
                .font(.system(size: 50))
            Text(":")
            Text(timer.lblSec)
                .fontWeight(.black)
                .font(.system(size: 50))
            Text(":")
            Text(timer.lblMS)
                .fontWeight(.black)
                .font(.system(size: 50))
        }
        .frame(width: 300.0)
        
    }
}

struct StopwatchDisplay_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchDisplay(timer: TimerController()).previewLayout(PreviewLayout.fixed(width: 300, height: 250))
    }
}

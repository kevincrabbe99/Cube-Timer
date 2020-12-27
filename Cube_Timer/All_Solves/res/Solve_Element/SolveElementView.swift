//
//  SolveElementView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/25/20.
//

import SwiftUI

struct SolveElementView: View {
    
    var si: SolveItem?
    //@ObservedObject var controller: SolveElementController
    
    init(si: SolveItem?) {
        self.si = si
        //self.controller = controller
    }
    
    // left off creating elements for solveElementView based on SingleCubeTypeView
    
    var body: some View {
        
        ZStack {
            Color.init("mint_cream")
                .cornerRadius(3)
                .opacity(0.2)
            
            Text(si?.getTimeCapture()?.getInSolidForm() ?? "0:00")
                .fontWeight(.bold)
                .font(.system(size: 12))
        
        }
        .frame(width: 45, height: 25)
    }
}

struct SolveElementView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            SolveElementView(si: SolveItem())
        }
        .previewLayout(.fixed(width: 100, height: 100))
    }
}

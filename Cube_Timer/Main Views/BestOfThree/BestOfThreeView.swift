//
//  BestOfThreeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/27/20.
//

import SwiftUI

struct BestOfThreeView: View {
    /*
    @ObservedObject var timer: TimerController
    var solveHandler: SolveHandler
    */
    
    // controller
    @ObservedObject var controller: BO3Controller
    
    
    init(c: BO3Controller) {
        self.controller = c
    }
    
    /*
    init(t: TimerController, s: SolveHandler) {
        self.controller.solveHandler = String
        self.controller.timer = t
    }
    */
    
    
    var body: some View {
    
        //if solveHandler.size > 0 { // EXIT: if no solves
        GeometryReader { geo in
            
            let innerW: CGFloat = geo.size.width - 50
            
            VStack {
                
                /*
                 * container for the stats
                 */
                if controller.solves.count >= 3 {
                    HStack {
                        VStack(alignment: .trailing, spacing: 2.5) {
                            Text("Best")
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                             //   .frame(width: (geo.size.width/4), alignment: .leading)
                            LabelElement(label: self.controller.best.getAsReadable(), highlighted: self.controller.lastIsBest, bgColor: Color.init("green"))
                            /*
                            Text("\(self.controller.best.getAsReadable())" as String)
                                .font(.system(size: 13))
                                .frame(width: (geo.size.width/4), alignment: .trailing)
                                .foregroundColor(Color.init("green"))
                            */
                        }
                        .frame(width:  innerW / 3, alignment: .leading)
                        VStack(alignment: .trailing, spacing: 2.5) {
                            Text("Wost")
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                //.frame(width: (geo.size.width/4), alignment: .leading)
                            LabelElement(label: self.controller.worst.getAsReadable(), highlighted: self.controller.lastIsWorst, bgColor: Color.init("red"))
                            /*
                            Text("\(self.controller.worst.getAsReadable())" as String)
                                .font(.system(size: 13))
                                .frame(width: (geo.size.width/4), alignment: .trailing)
                                .foregroundColor(Color.init("red"))
                            */
                        }
                        .frame(width:  innerW / 3, alignment: .leading)
                        VStack(alignment: .trailing, spacing: 2.5) {
                            Text("Average")
                                .fontWeight(.bold)
                                .font(.system(size: 13))
                                //.frame(width: (geo.size.width/4), alignment: .leading)
                            LabelElement(label: String(format: "%.2f", self.controller.average))
                            /*
                            Text("\(String(format: "%.2f", self.controller.average))s")
                                .font(.system(size: 13))
                                .frame(width: (geo.size.width/4), alignment: .trailing)
                                .foregroundColor(Color.init("yellow"))
                            */
                        }
                        .frame(width: innerW / 3, alignment: .leading)
                    }
                    .opacity(0.8)
                    .padding(10)
                    .offset(x: 15)
                    //.frame(width:innerW)
                }
            }
                
        }
            
    }
}

struct LabelElement: View {
    
    var label: String
    var highlighted: Bool = false
    var bgColor: Color = Color.init("mint_cream")
    
    var body: some View {
        ZStack {
            if !highlighted {
                Color.init("mint_cream")
                    .cornerRadius(3)
                    .opacity(0.2)
            } else {
                bgColor
                    .cornerRadius(3)
                    .opacity(0.9)
            }
            
            Text(label)
                .fontWeight(.bold)
                .font(.system(size: 12))
        }
        .frame(width: 65, height: 15, alignment: .center)
    }
    
}

struct BestOfThreeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            BestOfThreeView(c: BO3Controller())
        }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/250.0/*@END_MENU_TOKEN@*/))
        
    }
}

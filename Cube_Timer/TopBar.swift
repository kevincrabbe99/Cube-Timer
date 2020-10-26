//
//  TopBar.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI

struct TopBar: View {
    
    var selectedTimeFrame: Int = 0
    let timeFrames: [STDButton] = [ STDButton(title: "3X", id: 0, selected: false),
                                    STDButton(title: "1D", id: 1, selected: true),
                                    STDButton(title: "1W", id: 2),
                                    STDButton(title: "1M", id: 3, selected: false),
                                    STDButton(title: "1Y", id: 4),
                                    STDButton(title: "AT", id: 5)]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.init("very_dark_black")
                    .cornerRadius(5)
                    .opacity(0.65)
                HStack(spacing: 20.0) {
                    
                    ForEach(timeFrames, id: \.id) { btn in
                        btn
                    }
                    
                }
            }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .frame(width: 360)
        }
        .frame(width: 400, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

struct STDButton: View {
    
    var title: String
    var id: Int
    var selected: Bool = false
    
    var body: some View {
        Button(action: {
            
        }) {
            if selected {
                ZStack {
                    Color.white
                        .cornerRadius(5)
                    Text(self.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .frame(width: 35, height: 25)
                
            }else {
                ZStack {
                    Text(self.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 35, height: 25)
            }
        }
    }
}

struct selectedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar()
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: 25))
    }
}

//
//  RoundedButton.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/18/21.
//

import SwiftUI


struct RoundedButton: View {
    
    var color: Color
    var gradient: Gradient
    
    var text: LocalizedStringKey
    var textColor: Color = Color.white
    
    
    init(color: Color, text: LocalizedStringKey, textColor: Color = Color.white) {
        self.color = color
        self.gradient = Gradient(colors: [color, color])
        self.text = text
        self.textColor = textColor
    }
    
    init(gradient: [Color], text: LocalizedStringKey, textColor: Color = Color.white) {
        self.color = gradient[0]
        self.gradient = Gradient(colors: gradient)
        self.text = text
        self.textColor = textColor
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                .border(color, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(3)
            
            Text(text)
                .fontWeight(.bold)
                .foregroundColor(textColor)
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .padding(.top, 5)
                .padding(.bottom, 5)
        }
        .fixedSize()
        //.frame(width: 120, height: 30)
    }
    
}

struct RoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        RoundedButton(color: Color.init("mint_cream"), text: "Sample")
    }
}

//
//  AlertView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/2/21.
//

import SwiftUI

struct AlertView: View {
    
    @EnvironmentObject var controller: AlertController
    
    var body: some View {
        
        GeometryReader { geo in
            
            let w = geo.size.width
           // let h = geo.size.height
            
            if controller.showing {
                ZStack {
                    
                    Color.init("mint_cream")
                        .opacity(0.9)
                        .cornerRadius(5)
                        .addBorder(Color.init("mint_cream"), width: 1, cornerRadius: 5)
                    
                    HStack(spacing: 15) {
                        
                        if controller.icon != nil {
                            controller.icon
                        }
                        
                        VStack(alignment: .leading) {
                            if controller.title != nil {
                                Text(LocalizedStringKey(controller.title!))
                                    .font(Font.custom("Play-Bold", size: 15))
                            }
                            
                            Text(LocalizedStringKey(controller.text))
                                .font(Font.custom("Play-Regular", size: 13))
                        }
                        
                    }
                    .frame(width: w-290, alignment: .leading)
                    
                }
                .frame(width: w-250, height: 60)
                .position(x: ((w-250)/2)+60, y: 60)
                .transition(.move(edge: .top))
                .animation(.spring())
                .foregroundColor(.init("black_chocolate"))
            }
            
        }
        
    }
}

struct AlertView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let gradient = Gradient(colors: [.init("very_dark_black"), .init("dark_black")])
        ZStack {
            Color.black
            Rectangle()
                .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                .opacity(0.6)
            
            AlertView()
        }
        .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}

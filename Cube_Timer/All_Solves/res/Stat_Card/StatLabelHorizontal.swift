//
//  StatLabelHorizontal.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/27/20.
//

import SwiftUI

struct StatLabelHorizontal: View {
    
    var label: LocalizedStringKey
    var value: String
    var showDecimal: Bool = true
    
    var body: some View {
        
        GeometryReader { geo in
            
            HStack(spacing: 10.0) {
                Text(label)
                    .font(Font.custom("Play-Bold", size: 12))
                    .opacity(0.8)
                
                
                ZStack {
                    Color.init("mint_cream")
                        .frame(height: 30)
                        .cornerRadius(4)
                        .opacity(0.2)
                    
                    if showDecimal {
                        Text(value/*"\(value, specifier: "%.2f")"*/)
                            .font(Font.custom("Chivo-Bold", size: 14))
                            .opacity(0.8)
                    } else {
                        Text(value/*"\(value, specifier: "%.0f")"*/)
                            .font(Font.custom("Chivo-Bold", size: 14))
                            .opacity(0.8)
                    }
                }
                .frame(width: (!UIDevice.IsIpad ? geo.size.width/2.6 : 100))
            }
            .foregroundColor(.init("mint_cream"))
            .frame(width: 200, alignment: .trailing)
            
        } // end geo
        
    }
}

struct StatLabelHorizontal_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            StatLabelHorizontal(label: "SOLVES", value: "420")
        }
            .previewLayout(.fixed(width: 200, height: 200))
    }
}

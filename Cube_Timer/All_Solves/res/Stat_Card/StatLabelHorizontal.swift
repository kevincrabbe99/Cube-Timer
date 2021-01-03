//
//  StatLabelHorizontal.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/27/20.
//

import SwiftUI

struct StatLabelHorizontal: View {
    
    var label: String
    var value: String
    var showDecimal: Bool = true
    
    var body: some View {
        
        GeometryReader { geo in
            
            HStack(spacing: 10.0) {
                Text(label)
                    .fontWeight(.black)
                    .font(.system(size:13))
                    .opacity(0.8)
                
                
                ZStack {
                    Color.init("mint_cream")
                        .frame(height: 30)
                        .cornerRadius(4)
                        .opacity(0.2)
                    
                    if showDecimal {
                        Text(value/*"\(value, specifier: "%.2f")"*/)
                            .bold()
                            .font(.system(size:14))
                            .opacity(0.8)
                    } else {
                        Text(value/*"\(value, specifier: "%.0f")"*/)
                            .bold()
                            .font(.system(size:14))
                            .opacity(0.8)
                    }
                }
                .frame(width: geo.size.width/2.6)
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

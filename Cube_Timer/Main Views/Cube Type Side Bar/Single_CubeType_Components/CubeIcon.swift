//
//  CubeIcon.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/17/20.
//

import SwiftUI

struct CubeIcon: View {
    
    var d1: Int = 3
    var d2: Int = 3
    var d3: Int = 3
    var w: CGFloat = 20
    var blockWidth: CGFloat = 34
    var padding: CGFloat = 4
    var widthNoPadding: CGFloat = 30
    var cr: CGFloat = 2
    
    init(_ d1: Int, _ d2: Int, _ d3: Int, width: CGFloat) {
        self.d1 = d1
        self.d2 = d2
        self.d3 = d3
        self.widthNoPadding = width / CGFloat(d1)
        self.padding = blockWidth / 20 // padding is a tenth of widthNoPadding
        self.blockWidth = widthNoPadding - padding
        self.cr = padding / 2
        //self.blockWPadding = blockWidth + padding
        self.w = width
    
    }
    
    
    var body: some View {
        
        ZStack {
            
            ForEach( 0..<d1, id: \.self ){ i in
                ForEach( 0..<d2, id: \.self ) { k in
                    RoundedRectangle(cornerRadius: cr)
                        .frame(width: blockWidth, height: blockWidth)
                        .offset(x: CGFloat(CGFloat(i)*widthNoPadding))
                        .offset(y: CGFloat(CGFloat(k)*widthNoPadding))
                }
            }
           // .offset(x: widthNoPadding * CGFloat((-1 * (d1-3))), y: widthNoPadding * CGFloat((-1 * (d1-3)))) // idk what (-1*(d1-3) really does, but it seems to center it
            
            
        }
        .frame(width: w, height: w, alignment: .topLeading)
        
    }
}

struct CubeIcon_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            
            CubeIcon(6,6,6, width: 50)
            
        }
            .previewLayout(.fixed(width: 100, height: 100))
    }
}

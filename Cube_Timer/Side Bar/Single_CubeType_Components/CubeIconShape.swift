//
//  CubeIconShape.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/23/20.
//

import SwiftUI

struct CubeIconShape: Shape {
    
    var ctHandler: CTypeHandler
    
    init(ctHandler: CTypeHandler) {
        self.ctHandler = ctHandler
    }
    
    /*
    init(_ d1: Int, _ d2: Int, _ d3: Int, width: CGFloat) {
        
    }
    */
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let w = rect.size.width
        let h = rect.size.height
        
        let topRight = CGPoint(x: w, y: 0)
        let topLeft = CGPoint(x: 0, y: 0)
        let bottomRight = CGPoint(x: w, y: h)
        let bottomLeft = CGPoint(x: 0, y:  h)
        
        let padding: CGFloat = 4
        let halfPadding: CGFloat = padding / 2
        let third: CGFloat = w/3
        
        let xMinMid: CGFloat = third
        let xMaxMid: CGFloat = third * 2
        
        var sq = Path()
        
        sq.move(to: topRight)
        sq.addLine(to: CGPoint(x: 0, y: xMinMid))
        
        return sq
    }
    

}

struct CubeIconShape_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            CubeIconShape(ctHandler: CTypeHandler())
            
        }
    }
}

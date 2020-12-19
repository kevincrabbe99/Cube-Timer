//
//  SidebarShape.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/18/20.
//

import SwiftUI

struct SidebarShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        //let bottomRight = CGPoint(x:  rect.size.height, y: rect.size.height)
        
        let w: CGFloat = rect.size.width
        let h: CGFloat = rect.size.height
        
        let tabWidth: CGFloat = 40
        let bWidth = w - tabWidth
        
        // big square
        let topRight = CGPoint(x: bWidth, y: 0)
        let topLeft = CGPoint(x: 0, y: 0)
        let bottomLeft = CGPoint(x: 0, y:  h)
        let bottomRight = CGPoint(x: bWidth, y: h)
        
        // points for the curve bullshit
        let tbHeight: CGFloat = (h/3) //150 height of tab is 1/5 of the height
        let tbWidth: CGFloat = 50 //75
        let tbTopEnd: CGFloat = tbHeight //100 // the buffer is the height of 1 tab
        let tbBottomStart: CGFloat = tbTopEnd + tbHeight // starting point is tbTopEnd(buffer) of 100px + height of tab
        
        let tbP1 = CGPoint(x: bWidth, y: tbBottomStart)
        let tbP2 = CGPoint(x: bWidth + (tbWidth / 4), y: tbBottomStart - (tbHeight / 4))
        let tbP3 = CGPoint(x: bWidth + (tbWidth / 4), y: tbTopEnd + (tbHeight / 4))
        let tbP4 = CGPoint(x: bWidth, y: tbTopEnd)
        
        let tbC1 = CGPoint(x: bWidth + (tbWidth / 20), y: tbBottomStart - (tbHeight / 8)) // control point for bottom curve
        let tbC2 = CGPoint(x: bWidth + (tbWidth / 20), y: tbTopEnd + (tbHeight / 8)) // control point for top curve
        let tbMaxPoint = CGPoint(x: bWidth + (tabWidth), y: tbTopEnd + (tbHeight / 2)) // control point for middle curve
        
        path.move(to: topLeft)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.addLine(to: tbP1)
    // start curve
        path.addQuadCurve(to: tbP2, control: tbC1)
        path.addQuadCurve(to: tbP3, control: tbMaxPoint)
        path.addQuadCurve(to: tbP4, control: tbC2)
    // finish path
        path.addLine(to: topRight)
        path.addLine(to: topLeft)
        
        
        /*
        let p1 = topLeft
        let p2 = bottomLeft
        let p3 = CGPoint(x: (w-(w/1.7)), y: (h-(h/3.8)) ) // middle bottom right
        let p4 = CGPoint(x: (w-(w/1.7)), y: (h/3.8))
        let p5 = topLeft
        
        let midPoint = CGPoint(x: w, y: h/2) // far right
        let controlBottom = CGPoint(x: w/12, y: (h - (h / 6)))
        let controlTop = CGPoint(x: h/12, y: h / 6)
        
        path.move(to: p1)
        path.addLine(to: p2)
        path.addQuadCurve(to: p3, control: controlBottom)
        path.addQuadCurve(to: p4, control: midPoint)
        path.addQuadCurve(to: p5, control: controlTop)
        */
        
        return path
    }
    
}

struct SidebarShape_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            SidebarShape()
                .stroke(lineWidth: 1)
                .foregroundColor(.white)
                .frame(width: 200, height: 300)
            
            
        }.previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
        
    }
}

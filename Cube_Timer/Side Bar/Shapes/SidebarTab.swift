//
//  SidebarTab.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/18/20.
//

import SwiftUI

struct SidebarTab: Shape {
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        //let bottomRight = CGPoint(x:  rect.size.height, y: rect.size.height)
        
        //let midPoightHeight = rect.size.height / 2
        

        let w = rect.size.width
        let h = rect.size.height
        //let topRight = CGPoint(x: w, y: 0)
        let topLeft = CGPoint(x: 0, y: 0)
        let bottomLeft = CGPoint(x: 0, y:  h)
        
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
        
        //path.addArc(tangent1End: bottomLeft, tangent2End: midPoint, radius: midPoightHeight)
        
        //path.addArc(tangent1End: topLeft, tangent2End: midPoint, radius: midPoightHeight)
        
        //path.addLine(to: midPoint)
        //path.addLine(to: topLeft)
        

        /*
                path.move(to: CGPoint(x: rect.size.width, y: 0))
                path.addLine(to: CGPoint(x: rect.size.width, y: rect.size.width))
                path.addLine(to: CGPoint(x: 0, y: rect.size.width))
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.closeSubpath()
        */

        return path
    }
    
    
}

struct SidebarTab_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.black)
            
            SidebarTab()
                .stroke(lineWidth: 1)
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}

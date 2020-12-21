//
//  SelectedShape.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/21/20.
//

import SwiftUI

struct SelectedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        
        //let bottomRight = CGPoint(x:  rect.size.height, y: rect.size.height)
        
        let w: CGFloat = rect.size.width
        let h: CGFloat = rect.size.height
        // big square
        let topRight = CGPoint(x: w, y: 0)
        let topLeft = CGPoint(x: 0, y: 0)
        let bottomLeft = CGPoint(x: 0, y:  h)
        let bottomRight = CGPoint(x: w, y: h)
        
        let bottomTrailingPoint = CGPoint(x: (w*0.8), y: h)
        let midTrailingPoint = CGPoint(x: w, y: (h/2))
        let topTrailingPoint = CGPoint(x: (w*0.8), y: 0)
        
        path.move(to: topLeft)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomTrailingPoint)
        path.addLine(to: midTrailingPoint)
        path.addLine(to: topTrailingPoint)
        path.addLine(to: topLeft)
        
        
        return path
    }
    

}

struct SelectedShape_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            
            SelectedShape()
                .stroke(lineWidth: 1)
                .cornerRadius(6)
                .foregroundColor(.white)
                .frame(width: 150, height: 40)
            
            
            
        }.previewLayout(.fixed(width: 300, height: 300))
    }
}

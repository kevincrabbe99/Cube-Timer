//
//  IconButton.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/18/21.
//

import SwiftUI

struct IconButton: View {
    
    var icon: Image
    var bgColor: Color
    var iconColor: Color
    var width: CGFloat = 20
    var height: CGFloat = 20
    
    var body: some View {
    
        ZStack {
            bgColor
                .cornerRadius(3)
            
            icon
                .font(Font.system(size: 13, weight: .bold))
                .foregroundColor(iconColor)
            
        }
        .frame(width: width, height: height)
        
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            IconButton(icon: Image.init(systemName: "trash.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"))
            
        }
    }
}
//
//  SingleStatBar.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/26/20.
//

import SwiftUI

struct SingleStatBar: View {
    
    var id: String
    
    var maxHeight: CGFloat
    var percentage: Double
    
    init() {
        id = UUID().uuidString
        maxHeight = -1
        percentage = -1
    }
    
    init(maxHeight: CGFloat, percentage: Double) {
        self.maxHeight = 30
        self.percentage = percentage
        id = UUID().uuidString
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .frame(width: 4)
            .frame(height: (maxHeight * CGFloat(percentage)) + 3.5 )
            .foregroundColor(.white)
    }
}

struct SingleStatBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            SingleStatBar(maxHeight: 30, percentage: 0.25)
        }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
        .frame(width: 100, height: 100)
    }
}

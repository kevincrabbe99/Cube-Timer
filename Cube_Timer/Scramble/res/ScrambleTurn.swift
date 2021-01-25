//
//  ScrambleTurn.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/24/21.
//

import SwiftUI

struct ScrambleTurn: View, Identifiable {
    
    var id: UUID = UUID()
    
    var value: String = ""
    
    init(_ v: String) {
        self.value = v
    }
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.init("mint_cream"))
                .opacity(0.1)
            
            Text( value )
                .font(Font.custom("Chivo-Bold", size: 14))
        }
        .frame(width: 40, height: 20, alignment: .center)    }
}

struct ScrambleTurn_Previews: PreviewProvider {
    static var previews: some View {
        ScrambleTurn("U2")
    }
}

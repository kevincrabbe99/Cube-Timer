//
//  ScrambleTurn.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/25/21.
//

import SwiftUI

struct ScrambleTurn: View {
    
    var controller: ScrambleTurnController
   
    var body: some View {
        //if controller.isNil {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.init("mint_cream"))
                    .opacity(0.1)
                
                Text( controller.value )
                    .font(Font.custom("Chivo-Bold", size: 11))
            }
            .frame(width: 35, height: 19, alignment: .center)
            
        //}
        
    }
}


struct ScrambleTurn_Previews: PreviewProvider {
    static var previews: some View {
        ScrambleTurn(controller: ScrambleTurnController())
    }
}

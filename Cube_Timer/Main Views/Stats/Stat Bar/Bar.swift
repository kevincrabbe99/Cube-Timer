//
//  Bar.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/26/20.
//

import SwiftUI

struct Bar: View, Identifiable {
    
    var id: String
    
    @ObservedObject var SSBController: BarController = BarController()
    
    init() {
        id = UUID().uuidString
    }
    
    init(pct: Double) {
        id = UUID().uuidString
        SSBController.percentage = pct
    }
    
    /*
     *  Used to get the Controller when initiating initiating
     *  NOTE: This should not be used to get the controller
     *          Use Bar().SSBController instead
     
    func getController() -> BarController {
        return SSBController
    }
     */
    
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .frame(width: 4)
            .frame(height: (SSBController.maxHeight * CGFloat(SSBController.percentage)) + 3.5 )
            .foregroundColor(SSBController.color)
            .animation(.spring())
    }
}

struct Bar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            Bar(pct: 0.25)
        }
        .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100.0/*@END_MENU_TOKEN@*/))
        .frame(width: 100, height: 100)
    }
}

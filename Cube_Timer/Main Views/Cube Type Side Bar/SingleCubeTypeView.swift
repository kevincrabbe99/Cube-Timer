//
//  SingleCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI



struct SingleCubeTypeView: View {
    
    var parent: SidebarView
    var d: Int // dimensions of the cube
    var configuration: String
    var brand: String
    
    var body: some View {
        HStack {
            CubeIcon(d,d,d, width: 15)
                //.frame(width: 30, height:30)
                .foregroundColor(Color.init("mint_cream"))
                .opacity(0.8)
            VStack(alignment: .leading) {
                Text(configuration)
                    .font(.system(size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(Color.init("mint_cream"))
                Text(brand)
                    .font(.system(size: 9))
                    .foregroundColor(Color.init("mint_cream"))
            }
            .offset(x: 8)
        }.frame(width: 200, height: 40, alignment: .leading)
        //.offset(x: 20)
    }
}

struct SingleCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("black_chocolate")
            SingleCubeTypeView(parent: SidebarView(contentView: ContentView()), d: 5, configuration: "3x3x3", brand: "Rubiks Origional Brand")
       
        }
    }
}

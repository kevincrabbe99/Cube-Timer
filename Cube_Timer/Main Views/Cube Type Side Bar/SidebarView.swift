//
//  SidebarView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI

struct SidebarView: View {
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Color(.init("dark_black"))
                
                VStack {
                    
                    /*
                     *  Header
                     */
                    HStack {
                        Text("YOUR CUBES")
                            .fontWeight(.black)
                        Spacer()
                        Image(systemName: "plus.square.fill")
                    }
                    .frame(width: geo.size.width - 30, height: 40, alignment: .leading)
                    
                    VStack { // cube list
                        SingleCubeTypeView(configuration: "3x3x3", brand: "Rubiks Origional Brand")
                        SingleCubeTypeView(configuration: "4x4x4", brand: "Rubiks Origional Brand")
                        SingleCubeTypeView(configuration: "5x5x5", brand: "Rubiks Origional Brand")
                    }
                    .frame(width: geo.size.width - 30, height: geo.size.height, alignment: .topLeading)
                }
                    
            }
            .foregroundColor(.white)
            .frame(width: geo.size.width)
        }
        
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.init("very_dark_black"))
            
            SidebarView()
        }
        .previewLayout(.fixed(width: 200, height: 350))
    }
}

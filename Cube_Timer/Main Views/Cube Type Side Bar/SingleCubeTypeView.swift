//
//  SingleCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI



struct SingleCubeTypeView: View {
    
    var configuration: String
    var brand: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(configuration)
                .font(.system(size: 14))
                .fontWeight(.bold)
            Text(brand)
                .font(.system(size: 10))
        }.frame(height: 50)
    }
}

struct SingleCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SingleCubeTypeView(configuration: "3x3x3", brand: "Rubiks Origional Brand")
    }
}

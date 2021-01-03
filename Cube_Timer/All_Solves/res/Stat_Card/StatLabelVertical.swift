//
//  StatLabelVertical.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/27/20.
//

import SwiftUI

struct StatLabelVertical: View {
    
    var label: String
    var value: String
    var solve: SolveItem?
    
    init(label: String, solve: SolveItem?) {
        self.label = label
        if solve != nil {
            self.solve = solve
            self.value = solve!.getTimeCapture()!.getAsReadable()
        } else {
            value = "none"
        }
    }
    
    /*
    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
        */
 
    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(alignment: .trailing, spacing: 2.0) {
                Text(label)
                    .fontWeight(.black)
                    .font(.system(size:13))
                    .opacity(0.8)
                
                
                ZStack {
                    Color.init("mint_cream")
                        .frame(width: geo.size.width * (0.5), height: 30)
                        .cornerRadius(4)
                        .opacity(0.2)
                    
                    
                    //Text(solve?.getTimeCapture()?.getInSolidForm() ?? "none")
                    Text(value/*"\(value, specifier: "%.2f")"*/)
                        .bold()
                        .font(.system(size:14))
                        .opacity(0.8)
                }
            }
            .foregroundColor(.init("mint_cream"))
            .frame(width: 150, alignment: .trailing)
            
        } // end geo
        
    }
}

struct StatLabelVertical_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            StatLabelVertical(label: "BEST", value: "13")
        }
            .previewLayout(.fixed(width: 200, height: 200))
    }
}

//
//  AboutView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/3/21.
//

import SwiftUI
import Firebase

struct AboutView: View {
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                VStack(alignment: .leading) {
                    Text("Developer:")
                        .font(Font.custom("Play-Bold", size: 20))
                    Text("Kevin Crabbe")
                        .font(Font.custom("Play-Regular", size: 16))
                }
                .frame(width: geo.size.width, alignment: .leading)
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Contact:")
                        .font(Font.custom("Play-Bold", size: 20))
                    Text("cubetimerapphelp@gmail.com")
                        .font(Font.custom("Play-Regular", size: 16))
                }
                .frame(width: geo.size.width, alignment: .leading)
                
                Spacer()
                
                Button {
                    Analytics.logEvent("goto_website", parameters: [
                        "website": "StatTimer Website" as NSObject
                    ])
                } label: {
                    VStack(alignment: .leading) {
                        Text("Website")
                            .font(Font.custom("Play-Bold", size: 20))
                        Link("kevincrab.be/cubetimer", destination: URL(string: "http://kevincrab.be/cubetimer")!)
                            .font(Font.custom("Play-Regular", size: 16))
                    }
                    .frame(width: geo.size.width, alignment: .leading)
                }

                
            }
            .frame(height: geo.size.height / 2)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
            .foregroundColor(.init("mint_cream"))
            
        } // end geo
        
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            AboutView()
        }
        .previewLayout(.fixed(width: 280, height: 150))
    }
}

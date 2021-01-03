//
//  SettingsView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/31/20.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var settingsController: SettingsController
    
    
    var doublePressToStopLabel: String {
        if settingsController.requireDoublePressToStop {
            return "YES"
        } else {
            return "NO"
        }
    }
    
    var pauseSavingSolvesLabel: String {
        if settingsController.pauseSavingSolves {
            return "ON"
        } else {
            return "OFF"
        }
    }
    
    let gradient = Gradient(colors: [.init("very_dark_black"), .init("dark_black")])
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                Color.black
                Rectangle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .opacity(0.6)
                
                VStack(alignment: .leading) {
                    /*
                     * TITLE
                     */
                    Text("SETTINGS")
                        .font(Font.custom("Dosis-ExtraBold", size: 25))
                        .padding(.top, 20)
                    
                    
                    /*&
                     *  OPTIONS VSTACK
                     */
                    VStack(spacing: 20) {
                        
                        Button(action: {
                            settingsController.toggleRequireDoublePressToStop()
                        }, label: {
                            SettingsOption(label: "Double press to stop", value: doublePressToStopLabel, info: "Requires both buttons to be pressed to record the solve.")
                        })
                       
                        Button(action: {
                            settingsController.togglePauseSavingSolves()
                        }, label: {
                            SettingsOption(label: "Pause saving solves", value: pauseSavingSolvesLabel)
                        })
                        
                        
                        SettingsOption(label: "about")
                            .padding(.top, 30)
                            .opacity(0.8)
                    }
                    .frame(height: h - 130)
                    .offset(y: -30)
                    
                }
                .foregroundColor(.init("mint_cream"))
                .frame(width: 280, alignment: .leading)
                
            } // end zstack bg
        } // end geo
    }
}

struct SettingsOption: View {
    
    var label: String
    var value: String?
    var info: String?
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            HStack{
                ZStack {
                    Text(label)
                        .fontWeight(.bold)
                        .font(Font.custom("Dosis-Bold", size: 19))
                }
                .frame(width: 230, alignment: .leading)
                if value != nil {
                    ZStack {
                        Color.init("mint_cream")
                            .opacity(0.75)
                            .cornerRadius(3)
                            .addBorder(Color.init("mint_cream"), width: 1, cornerRadius: 3)
                        
                        Text(value!)
                                .foregroundColor(.init("very_dark_black"))
                                .font(.system(size:12))
                                .fontWeight(.bold)
                    }
                    .frame(width: 40, height: 25)
                }
            }
            .frame(width: 280, alignment: .leading)
            if info != nil {
                Text(info!)
                    //.font(.system(size:12))
                    .font(Font.custom("Dosis", size: 13))
                    .frame(width: 220, alignment: .leading)
                    .opacity(0.8)
            }
        }
        .frame(width: 280)
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}

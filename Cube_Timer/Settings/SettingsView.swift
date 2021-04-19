//
//  SettingsView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/31/20.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var controller: SettingsController
    @EnvironmentObject var cvc: ContentViewController
    
    
    var doublePressToStopLabel: String {
        if controller.requireDoublePressToStop {
            return "YES"
        } else {
            return "NO"
        }
    }
    
    var pauseSavingSolvesLabel: String {
        if controller.pauseSavingSolves {
            return "ON"
        } else {
            return "OFF"
        }
    }
    
    var oneButtonModeLabel: String {
        if controller.oneButtonMode {
            return "ONE"
        } else {
            return "TWO"
        }
    }
    
    var defaultCameraOnLabel: String {
        if controller.defaultVideoOn {
            return "YES"
        } else {
            return "NO"
        }
    }
    
    var recordingBufferOptions = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    @State private var selectedRecordingBufferTime = 3
    
    let gradient = Gradient(colors: [.init("very_dark_black"), .init("dark_black")])
    var body: some View {
        GeometryReader { geo in
         //   let w = geo.size.width
            let h = geo.size.height
            
            ZStack {
                Color.black
                Rectangle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .opacity(0.6)
                
                Button(action: {
                    cvc.setPageTo(.settings)
                }, label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.init("mint_cream"))
                })
                .position(x: 50, y: 50)
                
                
                VStack(alignment: .leading) {
                    /*
                     * TITLE
                     */
                    Text(controller.aboutState ? "ABOUT" : "SETTINGS")
                        .font(Font.custom("Dosis-ExtraBold", size: 25))
                        .padding(.top, 10)
                    
                    
                    /*&
                     *  OPTIONS VSTACK
                     */
                    VStack(spacing: 0) {
                        
                        if !controller.aboutState { // if in regular state (not in about section
                            ScrollView(.vertical, showsIndicators: true) {
                                VStack {
                                    Button(action: {
                                        controller.toggleRequireDoublePressToStop()
                                    }, label: {
                                        SettingsOption(label: "Double press to stop", value: (!controller.oneButtonMode ? doublePressToStopLabel : ""), info: (!controller.oneButtonMode ? "Requires both buttons to be pressed to record the solve." : "This option is not available when 1 button start is enabled. You can change this below."))
                                    })
                                    .opacity(controller.oneButtonMode ? 0.4 : 1)
                                                              
                                    Button(action: {
                                        controller.toggleOneButtonMode()
                                    }, label: {
                                        SettingsOption(label: "1 or 2 button start", value: oneButtonModeLabel, info: "Select how many buttons are needed to be pressed in order to activate the timer.")
                                    })
                                    
                                    Button(action: {
                                        controller.togglePauseSavingSolves()
                                    }, label: {
                                        SettingsOption(label: "Pause saving solves", value: pauseSavingSolvesLabel)
                                    })
                                    
                                    
                                    Button(action: {
                                        controller.toggleDefaultVideoOn()
                                    }, label: {
                                        SettingsOption(label: "Default to Camera On", value: defaultCameraOnLabel, info: "Choose whether the camera is enabled by default upon opening the app.")
                                    })
                                    
                                    HStack {
                                        VStack {
                                            Text(LocalizedStringKey("Recording Stop Buffer Timer"))
                                                .fontWeight(.bold)
                                                .font(Font.custom("Dosis-Bold", size: 19))
                                                .frame(width: 220, alignment: .leading)
                                            Text(LocalizedStringKey("Select how many seconds the should pass after stopping the timer before the video recording gets cut off."))
                                                //.font(.system(size:12))
                                                .font(Font.custom("Dosis", size: 13))
                                                .frame(width: 220, alignment: .leading)
                                                .opacity(0.8)
                                        }
                                        
                                        Spacer()
                                        
                                        ZStack {
                                            Picker("", selection: $selectedRecordingBufferTime) {
                                                ForEach(recordingBufferOptions, id: \.self) {
                                                    Text(String($0))
                                                        .font(Font.custom("Play-Bold", size: 14))
                                                }
                                            }
                                            .frame(width: 40, height: 80)
                                            .clipped()
                                            .onChange(of: selectedRecordingBufferTime) { (value) in
                                                controller.setRecordingBuffer(to: value)
                                            }
                                        }
                                        .frame(width: 60)
                                        
                                    }
                                    
                                    
                                }
                                .padding(.trailing, 5)
                            }
                        } else {
                            
                            AboutView()
                            
                        }
                        
                        
                        
                    }
                    //.frame(height: h - 60)
                    //.offset(y: -30)
                    
                    Button(action: {
                        controller.toggleAbout()
                    }, label: {
                        SettingsOption(label: (controller.aboutState ? "back" : "about"))
                           .padding(.bottom, 30)
                            .opacity(0.8)
                    })
                    
                }
                .foregroundColor(.init("mint_cream"))
                .frame(width: 280, alignment: .topLeading)
                
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
                    Text(LocalizedStringKey(label))
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
                        
                        Text(LocalizedStringKey(value!))
                            .foregroundColor(.init("very_dark_black"))
                            .font(Font.custom("Chivo-Bold", size: 12))
                            .animation(.none)
                    }
                    .frame(width: 40, height: 25)
                }
            }
            .frame(width: 280, alignment: .leading)
            if info != nil {
                Text(LocalizedStringKey(info!))
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

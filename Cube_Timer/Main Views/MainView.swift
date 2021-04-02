//
//  MainView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/27/20.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var cTypeHandler: CTypeHandler
    @EnvironmentObject var timer: TimerController
    @EnvironmentObject var settingsController: SettingsController
    @EnvironmentObject var cameraController: CameraController
    
    var parent: ContentView
    //@ObservedObject var timer: TimerController
    @ObservedObject var solveHandler: SolveHandler
    @ObservedObject var bo3Controller: BO3Controller

    var peripheralOpacity: Double  {
        if timer.timerGoing {
            return -0.3
        }else {
            return 0.5
        }
    }
    
    func gotoPage(_ p: Page) {
        cvc.setPageTo(p)
    }
    
    var body: some View {
        GeometryReader { geo in
            Color.init("very_dark_black")
            ZStack {
                
                /*
                 *  CAMERA LAYER
                 */
                if cameraController.videoState != .disabled {
                    CameraViewController()
                        .opacity(0.3)
                        .transition(.opacity)
                }
                
                ButtonsView(timer: timer)
                
                /*
                 *  VIDEO toggle button
                 */
                if !(cameraController.videoState == .disabled && timer.timerGoing == true) { // only show if camera enabled or not timer (on standby)
                    ZStack {
                        
                        HStack {
                            /*
                             *  CHOOSE WHICH VIDEO ICON TO DISPLAY
                             */
                            if cameraController.videoState == .recording {
                                IconButton(icon: Image.init(systemName: "record.circle"), bgColor: Color.init("very_dark_blue"), iconColor: Color.red, width: 25, height: 25)
                                
                                Text("Recording...")
                                    .font(Font.custom("Play-Bold", size: 13))
                                    .foregroundColor(Color.init("mint_cream"))
                                    .offset(y: -1)
                            } else if cameraController.videoState == .standby {
                                
                                IconButton(icon: Image.init(systemName: "xmark.square.fill"), bgColor: Color.init("mint_cream").opacity(0.85), iconColor: Color.init("red"), width: 25, height: 25)
                                    .onTapGesture {
                                        cameraController.toggleVideoState()
                                    }
                                
                                    
                                IconButton(icon: Image.init(systemName: "arrow.triangle.2.circlepath.camera.fill"), bgColor: Color.init("mint_cream").opacity(0.85), iconColor: (cameraController.cameraInputState == .backCamera ? Color.init("dark_black") : Color.init("very_dark_black")), width: 30, height: 25)
                                    .padding(.leading, 10)
                                    .onTapGesture {
                                        cameraController.toggleCameraInput()
                                    }
                                
                               
                                IconButton(icon: (cameraController.microphoneState == .muted ? Image.init(systemName: "mic.slash.fill") : Image.init(systemName: "mic.fill")),
                                           bgColor: Color.init("mint_cream").opacity(0.85), iconColor: (cameraController.microphoneState == .muted ? Color.init("red") : Color.init("very_dark_black")), width: 30, height: 25, iconWidth: 8, iconHeight: 12)
                                    .onTapGesture {
                                        cameraController.toggleMicrophoneEnabled()
                                    }
                                
                                
                                IconButton(icon: Image.init(systemName: "circle.fill"), bgColor: Color.init("very_dark_blue"), iconColor: Color.green, width: 20, height: 20)
                                
                                Text("Recording Standby")
                                    .font(Font.custom("Play-Bold", size: 13))
                                    .foregroundColor(Color.init("mint_cream"))
                                    .offset(y: -1)
                            } else if cameraController.videoState == .disabled {
                                IconButton(icon: Image.init(systemName: "video.fill"), bgColor: Color.init("mint_cream").opacity(0.85), iconColor: Color.init("very_dark_black"), width: 30, height: 25, iconWidth: 15, iconHeight: 10)
                                    .onTapGesture {
                                        cameraController.toggleVideoState()
                                    }
                                Spacer()
                            }
                        }
                        
                    }
                    .frame(width: 300, height: 30, alignment: .leading)
                    .position(x: 200, y: 45)
                }
                
                /*
                 * TOP RIGHT LARGE LABEL
                 */
                if !settingsController.pauseSavingSolves {
                    VStack(alignment:.trailing) {
                        Text(cTypeHandler.selected.name)
                            //.font(.system(size: 30))
                            .font(Font.custom("Play-Bold", size: 33))
                            //.fontWeight(.black)
                            .tracking(cTypeHandler.selected.isCustom() ? 0 : 5)
                            .lineLimit(1)
                            .offset(x: 5)
                            .frame(width: 300, alignment: .trailing)
                        Text(cTypeHandler.selected.descrip)
                            .font(Font.custom("Play-Regular", size: 15))
                            .lineLimit(1)
                            // .font(.system(size: 12))
                            //.fontWeight(.bold)
                            .opacity(0.75)
                    }.frame(width: 150, alignment: .trailing)
                    .position(x: geo.size.width - 120, y: 30)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    .opacity(cvc.mainViewOpacity - 0.3)
                    .foregroundColor(.white)
                }
                
                
                if !(timer.timerGoing || timer.oneActivated || timer.bothActivated) { // only show when there is no timer active
                 
                    if !settingsController.pauseSavingSolves {
                        TimeframeBar(sh: solveHandler)
                            .position(x: geo.size.width/2, y: geo.size.height-50)
                            //.opacity(0.9)
                            .opacity(peripheralOpacity + 0.3)
                            .animation(.easeIn)
                            .transition(.move(edge: .bottom))
                        }
                    }

                    TimerView(p: self, t: timer, s: solveHandler, bo3c: bo3Controller /*solveHandler: solveHandler*/)
                        .offset(y:-30)
                
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(parent: ContentView(), solveHandler: SolveHandler(), bo3Controller: BO3Controller())
            .environmentObject(CTypeHandler())
            .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}

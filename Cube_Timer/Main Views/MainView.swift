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
                
               CameraViewController()
                .opacity(0.3)
                
                ButtonsView(timer: timer)
                
                /*
                 *  VIDEO toggle button
                 */
                HStack {
                    /*
                    IconButton(icon: Image.init(systemName: "video.fill"), bgColor: Color.init("mint_cream"), iconColor: Color.init("very_dark_black"), width: 25, height: 20)x
                    IconButton(icon: Image.init(systemName: "circle.fill"), bgColor: Color.init("very_dark_blue"), iconColor: Color.green, width: 20, height: 20)
                     */
                    IconButton(icon: Image.init(systemName: "record.circle"), bgColor: Color.init("very_dark_blue"), iconColor: Color.red, width: 25, height: 25)
 
                    Text("Video Recording On")
                        .font(Font.custom("Play-Bold", size: 13))
                        .foregroundColor(Color.init("mint_cream"))
                        .offset(y: -1)
                }
                .frame(width: 300)
                .position(x: 140, y: 45)
                
                
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

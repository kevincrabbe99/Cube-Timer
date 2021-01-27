//
//  TopHeader.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/25/21.
//

import SwiftUI

struct TopHeader: View {
    
    @EnvironmentObject var cTypeHandler: CTypeHandler
    @EnvironmentObject var solveHandler: SolveHandler
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var timer: TimerController
    @EnvironmentObject var scrambleController: ScrambleController
    
    var w = UIScreen.main.bounds.width
    
    
        
    
    var body: some View {
        
        ZStack {
            
            if scrambleController.showingScramble && scrambleController.isMaxamized {
                Color.init("very_dark_black")
                    .cornerRadius(5, corners: [.bottomLeft, .bottomRight])
                    //.addBorder(Color.black.opacity(0.5), width: 1, cornerRadius: 5)
                    .shadow(color: .init("shadow_color"), radius: 7, x: 0, y: 6)
                    .transition(.opacity).animation(.spring())
            }
            
            HStack {
            
                /*
                 *  tab button
                 */
                if !scrambleController.isMaxamized && scrambleController.hasScramble {
                    if !(timer.timerGoing || timer.oneActivated || timer.bothActivated) {
                        if cTypeHandler.selected.getScrambleDimension()! > 3 {
                        
                            Button {
                                scrambleController.maxamize()
                            } label: {
                                IconButton(icon: Image(systemName: "chevron.compact.down"), bgColor: Color.init("mint_cream").opacity(0.8), iconColor: Color.init("very_dark_black"), width: 25, height: 15, weight: .regular)
                                    .padding([.leading, .trailing], 10)
                            }
                            
                        }
                    }
                }
                
                if scrambleController.showingScramble {
                    ScrambleView()
                }
                   
                VStack(alignment: .trailing) {
                    
                    /*
                     *  Options
                     */
                    if (scrambleController.isMaxamized && scrambleController.showingScramble) {
                        VStack(alignment: .trailing, spacing: 10) {
                            HStack {
                                Text("Auto Expand")
                                IconButton(icon: Image(systemName: "rectangle.expand.vertical"), bgColor: Color.init("mint_cream"), iconColor: Color.init("very_dark_black"))
                            }
                            HStack {
                                
                                Button {
                                    scrambleController.generateNewScramble()
                                } label: {
                                    Text("Refresh")
                                    IconButton(icon: Image(systemName: "arrow.clockwise"), bgColor: Color.init("mint_cream"), iconColor: Color.init("very_dark_black"))
                                }

                            }
                        }
                        .font(Font.custom("Play-Bold", size: 11))
                        .padding(.top, 15)
                        .padding(.trailing, 15)
                    }
                    
                    Spacer()
                    
                    /*
                     *  title
                     */
                    VStack(alignment:.trailing) {
                        Text(cTypeHandler.selected.name)
                            //.font(.system(size: 30))
                            .font(Font.custom("Play-Bold", size: 22))
                            //.fontWeight(.black)
                            .tracking(cTypeHandler.selected.isCustom() ? 0 : 5)
                            .offset(x: cTypeHandler.selected.isCustom() ? 0 : 5)
                            .lineLimit(1)
                            .frame(width: 300, alignment: .trailing)
                        Text(cTypeHandler.selected.descrip)
                            .font(Font.custom("Play-Regular", size: 11))
                            .lineLimit(1)
                            // .font(.system(size: 12))
                            //.fontWeight(.bold)
                            .opacity(0.75)
                    }
                    .offset(y: (scrambleController.isMaxamized ? -3 : 10))
                    .opacity(0.8)
                    .padding(.trailing, 15)
                    .padding(.bottom, 25)
                }
                .frame(width: 150, alignment: .trailing)
                .animation(.spring())
                
            }
            
        }
        .opacity(cvc.mainViewOpacity)
        .foregroundColor(.white).frame(width: 150, alignment: .trailing)
        .frame(width: scrambleController.dynamicWidth, height: scrambleController.heightBasedOnCount, alignment: .bottomTrailing)
        .position(x: scrambleController.dynamicXPos, y: scrambleController.dynamicYPos)
        
    }
}

struct TopHeader_Previews: PreviewProvider {
    static var previews: some View {
        TopHeader()
    }
}

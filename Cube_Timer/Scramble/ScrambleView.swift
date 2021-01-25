//
//  Scramble.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/24/21.
//

import SwiftUI


struct ScrambleView: View {
    
    @EnvironmentObject var cTypeHandler: CTypeHandler
   // @EnvironmentObject var solveHandler: SolveHandler
    @EnvironmentObject var scrambleController: ScrambleController
    @EnvironmentObject var timer: TimerController
    @EnvironmentObject var cvc: ContentViewController
   
    
    var showing: Bool {
        if cvc.peripheralOpacity == 0 {
            return false
        } else {
            return true
        }
    }
    
    var dynamicWidth: CGFloat {
        if !(timer.timerGoing || timer.oneActivated || timer.bothActivated)  {
            return UIScreen.main.bounds.width - 200
        } else {
            return 200
        }
    }
    
    var dynamicXPos: CGFloat {
        if !(timer.timerGoing || timer.oneActivated || timer.bothActivated)  {
            return ((UIScreen.main.bounds.width) / 2)
        } else {
            return (UIScreen.main.bounds.width - 150)
        }
    }
    
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 5), count: (!UIDevice.IsIpad ? 10 : 30))
   
    var body: some View {
        
        //GeometryReader { geo in
        
            ZStack {
                
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.init("very_dark_black"))
                    .addBorder(Color.black.opacity(0.5), width: 1.5, cornerRadius: 5)
                    .shadow(color: .init("shadow_color"), radius: 7, x: 0, y: 6)
                    .opacity(0.2)
                
                
                HStack {
                    
                    /*
                     *  tab button
                     */
                    Image(systemName: "chevron.compact.right")
                        .padding(.leading, 10)
                        .padding(.trailing, 10)
                    
                    if !(timer.timerGoing || timer.oneActivated || timer.bothActivated) {
                        /*
                         *  DISPLAY PART
                         */
                        VStack(alignment: .leading, spacing: 0) {
                         
                            /*
                             *  HEADER
                             */
                            HStack(spacing: 15) {
                                ZStack {
                                    Color.init("green")
                                        .opacity(0.75)
                                        .cornerRadius(3)
                                    
                                    Text("NEW SCRAMBLE")
                                        .font(Font.custom("Play-Bold", size: 10))
                                        .padding([.leading, .trailing], 5)
                                        
                                }
                                .fixedSize()
                                .frame(height: 20)
                                
                                ZStack {
                                    Color.init("yellow")
                                        .opacity(0.75)
                                        .cornerRadius(3)
                                    
                                    Text("PREVIOUS SCRAMBLE")
                                        .font(Font.custom("Play-Bold", size: 10))
                                        .padding([.leading, .trailing], 5)
                                        
                                }
                                .fixedSize()
                                .frame(height: 20)
                                .opacity(0.3)
                            }
                            
                            /*
                             *  SEQUENCE
                             */
                            LazyVGrid(columns: gridItemLayout, alignment: .trailing)  {
                            
                                ForEach(scrambleController.scrambleToShow) { t in
                                    t
                                }
                                
                            
                            }
                            .offset(y: 5)
                            .padding(.bottom, 5)
                            
                        }
                        .frame(width: dynamicWidth - 200, alignment: .leading)
                        .offset(y: -8)
                    } // end if
                    
                    /*
                     *  title
                     */
                    VStack(alignment:.trailing) {
                        Text(cTypeHandler.selected.name)
                            //.font(.system(size: 30))
                            .font(Font.custom("Play-Bold", size: 22))
                            //.fontWeight(.black)
                            .tracking(cTypeHandler.selected.isCustom() ? 0 : 5)
                            .lineLimit(1)
                            .frame(width: 300, alignment: .trailing)
                        Text(cTypeHandler.selected.descrip)
                            .font(Font.custom("Play-Regular", size: 11))
                            .lineLimit(1)
                            // .font(.system(size: 12))
                            //.fontWeight(.bold)
                            .opacity(0.75)
                    }.frame(width: 150, alignment: .trailing)
                    .offset(y: -3)
                    .opacity(0.8)
                    .padding(.trailing, 15)
                    
                    
                    
                }
            }
            .frame(width: dynamicWidth, height: 45, alignment: .trailing)
            .position(x: dynamicXPos, y: 60)
        
      //  } // end geo
      //  .frame(width: UIScreen.main.bounds.width, height: 45, alignment: .center)
      //  .position(x: UIScreen.main.bounds.width/2, y: 30)
            
    }
}

struct Scramble_Previews: PreviewProvider {
    static var previews: some View {
        ScrambleView()
    }
}

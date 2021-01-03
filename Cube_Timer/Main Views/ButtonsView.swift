//
//  ButtonsView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI

struct ButtonsView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    
    @ObservedObject var timer: TimerController
    
    @State var leftBtnOpacity: Double = 1
    @State var rightBtnOpacity: Double = 1
    
    @State var leftIconOpacity: Double = 0.1
    @State var rightIconOpacity: Double = 0.1
    
    var topCRs: CGFloat {
        if UIDevice.current.hasNotch {
            return 35
        } else {
            return 10
        }
    }
    
    let gradient = Gradient(colors: [.init("dark_black"), .clear])
    
    var iconOpacity: Double  {
        if timer.startApproved || timer.timerGoing {
            return 0
        }else {
            return 0.1
        }
    }
        
    var body: some View {
        GeometryReader { geometry in
            HStack {
                
                /*
                        LEFT BUTTON
                 */
                ZStack {
                  
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(topCRs, corners: [.topLeft])
                        .cornerRadius(4, corners: [.bottomRight, .topRight])
                        .cornerRadius(10, corners: [.bottomLeft])
                        .opacity(leftBtnOpacity)
                    
                    
          
                    Image("two_fingers")
                        .resizable()
                        .frame(width: 75, height: 75)
                        .offset(x: -50, y: 20)
                        .aspectRatio(contentMode: .fit)
                        .rotation3DEffect(.degrees(30), axis: (x: 0, y: 0, z: 1))
                        .foregroundColor(.white)
                        .opacity(leftIconOpacity)
                        .animation(.easeIn)
                  
                    
                }
                .frame(width: geometry.size.width / 2 - 15, alignment: .leading)
                
                .gesture (// gesture for transitioning to allSolvesView
                    DragGesture()
                        .onChanged { value in
                            cvc.dragChanged(value)
                        }
                        .onEnded { value in
                            cvc.dragEnded(value)
                        }
                )
                
                .onLongPressGesture(minimumDuration: 100.0, maximumDistance: .infinity, pressing: { pressing in
                    if pressing  {
                        timer.activateLeft()
                        withAnimation {
                            self.leftBtnOpacity = 0
                            self.leftIconOpacity = 0
                        }
                    }else {
                        timer.deActivateLeft()
                        withAnimation {
                            self.leftBtnOpacity = 1
                            self.leftIconOpacity = 0.2
                        }
                    }
                }, perform: { })
                
                
                
                
                /*
                *       RIGHT BUTTON
                 */
                
                ZStack {
                    /* Redundany by setting gradient background
                    Color.init("dark_black")
                    */
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(gradient: gradient, startPoint: .topTrailing, endPoint: .bottomLeading))
                        .cornerRadius(topCRs, corners: [.topRight])
                        .cornerRadius(4, corners: [.bottomLeft, .topLeft])
                        .cornerRadius(10, corners: [.bottomRight])
                        .opacity(rightBtnOpacity)
                 
                        Image("two_fingers")
                            .resizable()
                            .frame(width: 75, height: 75)
                            .offset(x: 50, y: 20)
                            .aspectRatio(contentMode: .fit)
                            .rotation3DEffect(.degrees(330), axis: (x: 0, y: 0, z: 1))
                            .foregroundColor(.white)
                            .opacity(rightIconOpacity)
                            .animation(.easeIn)
                 
                }
                .frame(width: geometry.size.width / 2 - 15, alignment: .leading)
                
                .gesture ( // gesture for transitioning to allSolvesView
                    DragGesture()
                        .onChanged { value in
                            cvc.dragChanged(value)
                        }
                        .onEnded { value in
                            cvc.dragEnded(value)
                        }
                )
                
                .onLongPressGesture(minimumDuration: 100.0, maximumDistance: .infinity, pressing: { pressing in
                    if pressing  {
                        timer.activateRight()
                        withAnimation {
                            self.rightBtnOpacity = 0
                            self.rightIconOpacity = 0
                        }
                    }else {
                        timer.deActivateRight()
                        withAnimation {
                            self.rightBtnOpacity = 1
                            self.rightIconOpacity = 0.2
                        }
                    }
                                }, perform: { })
                
                
            }
            .frame(width: geometry.size.width - 10, height: geometry.size.height - 35)
            .offset(x:5)
            .offset(y:10)
        }
    }
}



struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView(timer: TimerController())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/))
    }
}

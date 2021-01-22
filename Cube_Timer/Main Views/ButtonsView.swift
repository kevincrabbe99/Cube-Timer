//
//  ButtonsView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI

struct ButtonsView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var settings: SettingsController
    
    
    @ObservedObject var timer: TimerController
    
    @State var oneBtnOpacity: Double = 1
    
    @State var leftBtnOpacity: Double = 1
    @State var rightBtnOpacity: Double = 1
    
    @State var leftIconOpacity: Double = 0.5
    @State var rightIconOpacity: Double = 0.5
    
    
    
    var topCRs: CGFloat {
        if UIDevice.hasNotch {
            return 35
        } else {
            return 10
        }
    }
    
    
    
    let gradient = Gradient(colors: [Color.init("dark_black").opacity(0.6), .clear])
    
    var iconOpacity: Double  {
        if timer.startApproved || timer.timerGoing {
            return 0
        }else {
            return 0.1
        }
    }
        
    //@State var longPressStart: Date?
    @State var isDraggin: Bool = false
    @GestureState var isDetectingLongPress = false
    @State var completedLongPress = false
    let oneBtnDragGuardHeigt: CGFloat = 50
    
        
   
    func setOneBtnOpacity(to: Double) {
        print("setting opacity to: ", to)
        if self.oneBtnOpacity != to {
            self.oneBtnOpacity = to
        }
    }
    
    
    
    @State var cancelSingleButton: Bool = false
    var body: some View {
        
        
        let singleButtonZoom = MagnificationGesture(minimumScaleDelta: 0)
            .onChanged { (val) in
                self.cancelSingleButton = true
            }
            .onEnded { (val) in
                self.cancelSingleButton = false
            }
        
        let singleButtonDrag =  DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                
                print("[bv] Push down")
                self.oneBtnOpacity = 0.1
                
                let transY = abs(value.translation.height)
                if transY > oneBtnDragGuardHeigt {
                    print("[bv] init drag")
                    cvc.dragChanged(value)
                    self.isDraggin = true
                } else {
                    
                    print("[bv] cancle drag")
                    timer.singleButtonPressed()
                    self.isDraggin = false
                }
                
            }
            .onEnded { value in
                print("[bv] Push up")
                if isDraggin {
                    timer.singleButtonAbort()
                    cvc.dragEnded(value)
                } else {
                    timer.startTimerFromSingleBtn()
                }
                cvc.setPageTo(cvc.onPage)
                //singleBtnTouching = false
                self.cancelSingleButton = false // reset just incasew
                self.oneBtnOpacity = 1
            }
        
        let singleButtonGesture =  singleButtonZoom.simultaneously(with: singleButtonDrag) //.sequenced(before: singleButtonDrag)
        
        
        GeometryReader { geometry in
            
          //  ZStack {
                
                // [if] to decide what button to display
                if settings.oneButtonMode {
                    /*
                     *       ONE BUTTON
                     */
                    ZStack {
                      
                        RoundedRectangle(cornerRadius: 5)
                            .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                            .cornerRadius(topCRs, corners: [.topLeft, .topRight])
                            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
                            .opacity(oneBtnOpacity)
                        
                        
                    }
                    //.frame(width: geometry.size.width / 2 - 15, alignment: .leading)
                    .frame(width: geometry.size.width - 30, height: geometry.size.height - 35)
                    .offset(x:15)
                    .offset(y:10)
                    .gesture(
                        singleButtonGesture//.simultaneously(with: singleBtnLongPress).simultaneously(with: singleBtnTapGesture)
                    )
            
                    /*
                    .onLongPressGesture(minimumDuration: 2, pressing: { pressing in
                        if pressing  {
                            timer.activateOne()
                            withAnimation {
                                self.oneBtnOpacity = 0
                            }
                        }else {
                            timer.deActivateOne()
                            withAnimation {
                                self.oneBtnOpacity = 1
                            }
                        }
                    }, perform: {
                        
                    })
                    
    
                    .highPriorityGesture(
                        DragGesture()
                            .onChanged { value in
                                cvc.dragChanged(value)
                            }
                            .onEnded { value in
                                cvc.dragEnded(value)
                            }
                    )
                    */
                    
                    
                } else { // if in two button mode
                    /*
                    *   TWO BUTTONS
                    */
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
                                .frame(width: 60, height: 60)
                                .offset(x: -50, y: 20)
                                .aspectRatio(contentMode: .fit)
                                .rotation3DEffect(.degrees(30), axis: (x: 0, y: 0, z: 1))
                                .foregroundColor(.init("very_dark_black"))
                                .opacity(0.5)
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
                                    .frame(width: 60, height: 60)
                                    .offset(x: 50, y: 20)
                                    .aspectRatio(contentMode: .fit)
                                    .rotation3DEffect(.degrees(330), axis: (x: 0, y: 0, z: 1))
                                    .foregroundColor(.init("very_dark_black"))
                                    .opacity(0.5)
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
                } // end if
         //   } // end zstack
        }
    }
}



struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonsView(timer: TimerController())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/))
    }
}

//
//  SidebarView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    
    var contentView: ContentView
    var cTypeHandler: CTypeHandler
    
    //@State var tabIcon: CubeIcon = CubeIcon(3, 3, 3, width: 15)
    
    
    
    
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                SidebarShape()
                    .fill(LinearGradient(
                        gradient: .init(colors: [Color.init("black_chocolate"), Color.init("very_dark_black")]),
                          startPoint: .init(x: 0, y: 1),
                        endPoint: .init(x: 1.5, y: -0.5)
                        ))
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                    .shadow(radius: 20)
                    
                
                
                /*
                 * the icon on the tab
                 *  also used as the dragger
                 */
                ZStack {
                    Color.clear
                     // i need to be able to render a CubeIcon even if any of the dimensions are not set
                   // CubeIcon(3, 3, 3, width: 15)
                   cTypeHandler.tabIcon
                    .foregroundColor(Color.init("mint_cream"))
                }
                .contentShape(Rectangle())
                .gesture(cvc.sbDrag)
                .gesture(cvc.sbTab)
                .frame(width: 50, height: 200, alignment: .center)
                .position(x: geo.size.width - 29, y: geo.size.height / 2)
                
                
                VStack {
                    
                    /*
                     *  Header
                     */
                    HStack {
                        
                        
                        Text("GROUPS")
                            .font(Font.custom("Dosis-ExtraBold", size: 22))
                        
                        
                           // .fontWeight(.black)
                           // .font(.system(size: 22))
                        Spacer()
                        HStack {
                            
                            
                            Button(action: {
                                self.editModeToggle()
                            }, label: {
                                IconButton(icon: Image(systemName: (!cvc.sbEditMode ? "pencil.tip" : "xmark")), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 21, height: 21)
                                
                            })
                            .frame(width: 40, height: 50, alignment: .center)
                            
                            if !cvc.sbEditMode { // dont show if in edit mode
                                Button(action: { // listener for new cube type
                                    self.cvc.tappedAddCT()
                                }, label: {
                                    IconButton(icon: Image(systemName: "plus"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 21, height: 21)
                                })
                                .frame(width: 40, height: 50, alignment: .center)
                            }
                                
                        }
                        .zIndex(3)
                        .frame(width: geo.size.width/4)
                    }
                    .frame(width: geo.size.width - 100, height: 50, alignment: .center)
                    .offset(y: 20)
                    
                    ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                        VStack { // cube list
                            ForEach(/*cTypeHandler.views*/cTypeHandler.typeControllers) { t in
                                
                                HStack {
                                   // t.view
                                    SingleCubeTypeView(controller: t)
                                        .onTapGesture {
                                            t.select() // select the cube
                                            if cvc.sbEditMode { // if in edit mode
                                                // toggle edit mode off
                                                self.cvc.sbEditMode.toggle()
                                                // show popup for currently iterated t.ct.id
                                                cvc.tappedEditCT(id: t.ct.id!)
                                            }
                                        }
                                    /*
                                     *  the edit button
                                     *      GOT REPLCAED BY SingleCubeTypeView
                                    if self.cvc.sbEditMode {
                                         Button(action: {
                                            // toggle edit mode
                                            self.cvc.sbEditMode.toggle()
                                            // show popup for currently iterated t.ct.id
                                            cvc.tappedEditCT(id: t.ct.id!)
                                         }, label: {
                                             Image(systemName: "pencil.tip.crop.circle")
                                         })
                                         .frame(width:50, height: 40, alignment: .center)
                                    }
                                     */
                                }
                                .frame(width: geo.size.width - 150, alignment: .leading)
                                
                            
                            
                            }
                        }
                        .frame(width: geo.size.width - 75, alignment: .leading)
                    }
                    .frame(width: geo.size.width - 75, height: geo.size.height - 120, alignment: .topLeading)
                    .offset(y:5)
                    
                    /*
                     *  bottom bar
                     */
                    
                        //ZStack {
                            HStack { // right side buttons
                                
                                if !cvc.inSettings {
                                    Button(action: {
                                        cvc.setPageTo(.settings)
                                    }, label: {
                                        Image(systemName:"gear")
                                            .resizable()
                                            .frame(width: 17, height: 17)
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .padding(.leading, 22)
                                    })
                                } else{ // if were on settings
                                    Button(action: {
                                        cvc.setPageTo(.settings) // passing .settings toggles it
                                    }, label: {
                                        Image(systemName:"house.fill")
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                            .aspectRatio(contentMode: .fit)
                                            .foregroundColor(.white)
                                            .padding(.leading, 22)
                                    })
                                }
                                
                                
                                Spacer()
                                
                                Button(action: {
                                    if cvc.onPage == .showAll {
                                        cvc.setPageTo(.Main)
                                    } else {
                                        cvc.setPageTo(.showAll)
                                    }
                                }, label: {
                                    if cvc.onPage == .showAll {
                                        
                                 
                                            Image("two_fingers")
                                                .resizable()
                                                .frame(width: 22, height: 22)
                                                .aspectRatio(contentMode: .fit)
                                                .rotation3DEffect(.degrees(30), axis: (x: 0, y: 0, z: 1))
                                                .foregroundColor(.white)
                                 
                                    
                                    } else {
                                        
                                  
                                            Image.init(systemName: "square.grid.3x2")
                                                .resizable()
                                                .frame(width: 18, height: 13.5)
                                                .foregroundColor(.white)
                                        
                                    } // end if
                                    
                                })// end button
                            }
                        //}
                        .frame(width: geo.size.width - 100, height: 60, alignment: .trailing)
                        .offset(y:-10)
                    
                    
                    
                }
                                
                
                    
            }
            .foregroundColor(.white)
            .frame(width: geo.size.width - 50)
            

            
        }
        
    }
    
    public func editModeToggle() {
        let lightTap = UIImpactFeedbackGenerator(style: .light)
        lightTap.impactOccurred()
        //self.cTypeHandler.toggleEditMode()
        self.cvc.sbEditMode.toggle()
    }
    
    
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.init("very_dark_black"))
            
            SidebarView(contentView: ContentView(), cTypeHandler: CTypeHandler())
        }
        .previewLayout(.fixed(width: 300, height: 350))
    }
}

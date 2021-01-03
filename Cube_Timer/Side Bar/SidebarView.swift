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
    
    @State var editMode: Bool = false
    
    
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
                        
                        
                        Text("CUBES")
                            .font(Font.custom("Dosis-ExtraBold", size: 22))
                        
                        
                           // .fontWeight(.black)
                           // .font(.system(size: 22))
                        Spacer()
                        HStack {
                            
                            Button(action: {
                                print("edit mode toggle" )
                                self.editModeToggle()
                            }, label: {
                                Image(systemName: "square.and.pencil")
                            })
                            .frame(width: 40, height: 50, alignment: .center)
                            
                            Button(action: { // listener for new cube type
                                print("work")
                                self.cvc.tappedAddCT()
                            }, label: {
                                Image(systemName: "plus.square.fill")
                            })
                            .frame(width: 40, height: 50, alignment: .center)
                                
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
                                    /*
                                     *  the edit button
                                     */
                                    if self.editMode {
                                         Button(action: {
                                            // toggle edit mode
                                            self.editMode.toggle()
                                            // show popup for currently iterated t.ct.id
                                            cvc.showCTPopupFor(id: t.ct.id!)
                                         }, label: {
                                             Image(systemName: "pencil.tip.crop.circle")
                                         })
                                         .frame(width:50, height: 40, alignment: .center)
                                    }
                                }
                                .frame(width: geo.size.width - 150, alignment: .leading)
                                
                               // plan is to show the edit button here and see if that works
                                
                                // the plan:
                                /*
                                 *  [] use the foreach to being all of the CT's in as CubeTypeController objects (initied and stored in CTypeHandler
                                 
                                 *  [done] The CTController objects will store the corresponind view to be displayed
                                 
                                 *  [done] CTypeHandler also has to store each SingleCubeTypeController rather than the views
                                    
                                 *  [half done] When the SingleCubeTypeView receives a tap gesture it calls the Controller and the controller will have a reference to CTypeHandler (as thats where it was created)
                                 */
                            
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
                                            .frame(width: 16, height: 16)
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
                                        
                                       // HStack {
                                            /*
                                            Text("go back")
                                                .fontWeight(.bold)
                                                .font(.system(size: 12))
                                             Spacer()
                                            */
                                            Image("two_fingers")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                                .aspectRatio(contentMode: .fit)
                                                .rotation3DEffect(.degrees(30), axis: (x: 0, y: 0, z: 1))
                                                .foregroundColor(.white)
                                        //}
                                      //  .frame(width: geo.size.width/3.5, alignment: .trailing)
                                    
                                    } else {
                                        
                                        // HStack {
                                            /*
                                            Text("show solves")
                                                .fontWeight(.bold)
                                                .font(.system(size: 12))
                                            Spacer()
                                            */
                                            Image.init(systemName: "square.grid.3x2")
                                                .resizable()
                                                .frame(width: 18, height: 13.5)
                                                .foregroundColor(.white)
                                       // }
                                        // .frame(width: geo.size.width/2.4, alignment: .trailing)
                                        
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
            

            
        }.onAppear() {
            
            // set selections
            //cTypeHandler.setDefaultSelection()
            
        }
        
    }
    
    public func editModeToggle() {
        let lightTap = UIImpactFeedbackGenerator(style: .light)
        lightTap.impactOccurred()
        //self.cTypeHandler.toggleEditMode()
        self.editMode.toggle()
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

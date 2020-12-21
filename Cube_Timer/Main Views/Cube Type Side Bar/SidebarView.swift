//
//  SidebarView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI

struct SidebarView: View {
    
    var contentView: ContentView
    var cTypeHandler: CTypeHandler
    
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
                    
                
                VStack {
                    
                    /*
                     *  Header
                     */
                    HStack {
                        Text("CUBES")
                            .fontWeight(.black)
                            .font(.system(size: 22))
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
                                self.contentView.tappedAddCT()
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
                            ForEach(/*cTypeHandler.views*/cTypeHandler.getAllAsViews(parentToPass: self)) { t in
                                t
                                
                                // the plan:
                                /*
                                 *  use the foreach to being all of the CT's in as CubeTypeController objects (initied and stored in CTypeHandler
                                 *  The CTController objects will store the corresponind view to be displayed
                                 *  When the SingleCubeTypeView receives a tap gesture it calls the Controller and the controller will have a reference to CTypeHandler (as thats where it was created)
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
                    ZStack {
                        HStack {
                            Text("go back")
                                .fontWeight(.bold)
                                .font(.system(size: 12))
                            Spacer()
                            Image("two_fingers")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fit)
                                .rotation3DEffect(.degrees(30), axis: (x: 0, y: 0, z: 1))
                                .foregroundColor(.white)
                        }
                        .frame(width: geo.size.width/3.5, alignment: .trailing)
                    }
                    .frame(width: geo.size.width - 100, height: 60, alignment: .trailing)
                    .offset(y:-10)
                    
                    
                }
                                
                
                    
            }
            .foregroundColor(.white)
            .frame(width: geo.size.width - 50)
            
            
            /*
             * the icon on the tab
             *  also used as the dragger
             */
            ZStack {
                Color.clear
                
               CubeIcon(3,3,3,width: 15)
                .foregroundColor(Color.init("mint_cream"))
            }
            .contentShape(Rectangle())
            .gesture(contentView.sbDrag)
            .gesture(contentView.sbTab)
            .position(x: geo.size.width - 32, y: geo.size.height / 2)
            .frame(width: 100, height: 200, alignment: .center)

            
        }
        
    }
    
    public func editModeToggle() {
        let lightTap = UIImpactFeedbackGenerator(style: .light)
        lightTap.impactOccurred()
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

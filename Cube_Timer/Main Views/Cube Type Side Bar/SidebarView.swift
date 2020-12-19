//
//  SidebarView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI

struct SidebarView: View {
    
    var contentView: ContentView
    
    public func tappedCube(Type: SingleCube)
    
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
                    .gesture(contentView.sbDrag)
                    .gesture(contentView.sbTab)
                    
                
               CubeIcon(3,3,3,width: 15)
                .position(x: geo.size.width - 32, y: geo.size.height / 2)
                
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
                            Image(systemName: "square.and.pencil")
                            Spacer()
                            Image(systemName: "plus.square.fill")
                        }
                        .frame(width: geo.size.width/4)
                    }
                    .frame(width: geo.size.width - 100, height: 50, alignment: .center)
                    .offset(y: 20)
                    
                    ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
                        VStack { // cube list
                            SingleCubeTypeView(d: 3, configuration: "3x3x3", brand: "Rubiks Origional Brand")
                            SingleCubeTypeView(d: 4, configuration: "4x4x4", brand: "Rubiks Brand")
                            SingleCubeTypeView(d: 5, configuration: "5x5x5", brand: "Rubiks Origional Brand")
                            SingleCubeTypeView(d: 3, configuration: "3x3x3", brand: "Xe Ping Dau Brand")
                            SingleCubeTypeView(d: 4, configuration: "4x4x4", brand: "Xe Ping Dau Brand")
                            SingleCubeTypeView(d: 5, configuration: "5x5x5", brand: "Xe Ping Dau")
                        }
                        .frame(width: geo.size.width - 75, alignment: .leading)
                        .offset(x:20)
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
                                .frame(width: 22, height: 22)
                                .aspectRatio(contentMode: .fit)
                                .rotation3DEffect(.degrees(30), axis: (x: 0, y: 0, z: 1))
                                .foregroundColor(.white)
                                .animation(.easeIn)
                        }
                        .frame(width: geo.size.width/3.3, alignment: .trailing)
                    }
                    .frame(width: geo.size.width - 100, height: 60, alignment: .trailing)
                    .offset(y:-10)
                    
                    
                }
                
                
                /*
                SidebarTab()
                    .fill(Color.init("dark_black"))
                    .frame(width: 70, height: 150)
                    .position(x:geo.size.width-18, y: 100)
                 */
                    
            }
            .foregroundColor(.white)
            .frame(width: geo.size.width - 50)
        }
        
    }
    
    
    
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.init("very_dark_black"))
            
            SidebarView(contentView: ContentView())
        }
        .previewLayout(.fixed(width: 300, height: 350))
    }
}

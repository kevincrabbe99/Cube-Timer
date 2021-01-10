//
//  SingleCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI



struct SingleCubeTypeView: View/*, Identifiable */{
    
   // var ct: CubeType
    @ObservedObject private var controller: SingleCubeTypeViewController
    
    var asSidebar: Bool
    
    init(controller: SingleCubeTypeViewController, asSidebar: Bool = true) {
        self.controller = controller
        self.asSidebar = asSidebar
    }
    
    
    var body: some View {
        ZStack {
            
           // if selected {
            
           // }
             
            HStack {
                CubeIcon(controller.d1,controller.d2,controller.d3, width: 15)
                    .foregroundColor(asSidebar ? Color.init("whiteORblack") : Color.init("blackORwhite"))
                    //.frame(width: 30, height:30)
                    .opacity(0.8)
                VStack(alignment: .leading) {
                    Text(controller.rawName)
                        .font(Font.custom("Play-Bold", size: 14))
                        .tracking(3)
                        //.font(.system(size: 14))
                       // .fontWeight(.bold)
                    Text(controller.desc)
                        .font(Font.custom("Play-Regular", size: 9))
                        //.font(.system(size: 9))
                }
                .offset(x: 8)
                //
 
                
            }
            .foregroundColor(asSidebar ? Color.init("whiteORblack") : Color.init("blackORwhite"))
            .offset(x: 20)
            .offset(x: (controller.selected && asSidebar ? /*CGFloat.random(in: 1..<5)*/ 5 : -5))
            //.animation((controller.selected ? Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) : Animation.easeInOut))
            .onTapGesture {
                self.controller.select()
            }
            .opacity((controller.selected && asSidebar) || !asSidebar ? 1 : 0.4 )
            
            
            //.offset(x: 20)
        }.frame(width: 150, height: 40, alignment: .leading)
    }

}

struct SingleCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("black_chocolate")
            SingleCubeTypeView(/*ct: CubeType(),*/ controller: SingleCubeTypeViewController(ct: CubeType(), ctHandler: CTypeHandler()))
       
        }
    }
}

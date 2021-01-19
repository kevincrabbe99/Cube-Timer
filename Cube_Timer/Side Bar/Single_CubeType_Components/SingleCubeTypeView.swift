//
//  SingleCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI



struct SingleCubeTypeView: View/*, Identifiable */ {
    
   // var ct: CubeType
    @ObservedObject private var controller: SingleCubeTypeViewController
    @EnvironmentObject var cvc: ContentViewController
    
    var asSidebar: Bool
    var bgColor: Color
    
    init(controller: SingleCubeTypeViewController, asSidebar: Bool = true, bgColor: Color = Color.clear) {
        self.controller = controller
        self.asSidebar = asSidebar
        self.bgColor = bgColor
    }
    
    
    var body: some View {
        ZStack {
            
            bgColor
                .cornerRadius(3)
                .addBorder(Color.init("mint_cream").opacity(asSidebar ? 0 : 0.4), width: 1, cornerRadius: 3)
             
            HStack(alignment: .center) {
                
                if !cvc.sbEditMode || !asSidebar { // not editing or not as sidebar
                    CubeIcon(controller.d1,controller.d2,controller.d3, width: (asSidebar ? 15 : 15))
                        .opacity(0.8)
                } else {
                    Image(systemName: "square.and.pencil")
                        .frame(width: 15, height: 15)
                }
                
               
                VStack(alignment: .leading) {
                    Text(controller.rawName)
                        .font(Font.custom("Play-Bold", size: 14))
                        .tracking(controller.ct.isCustom() ? 0 : 3)
                        //.font(.system(size: 14))
                       // .fontWeight(.bold)
                    Text(controller.desc)
                        .font(Font.custom("Play-Regular", size: 9))
                        //.font(.system(size: 9))
                }
                .padding(.leading, 8) //.offset(x: 8)
                .fixedSize()
                //
 
                
            }
            //.frame(width: 150, height: 40, alignment: .leading)
            .foregroundColor( Color.white)
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .offset(x: (controller.selected && asSidebar && !cvc.sbEditMode ? /*CGFloat.random(in: 1..<5)*/ 5 : -5))
            /*.onTapGesture {
                if asSidebar {
                    self.controller.select() // select as the current cube via cTypeHandler
                }
            }*/
            .opacity((controller.selected && asSidebar) || !asSidebar ? 1 : 0.4 )
            //.fixedSize()
            
            
            //.offset(x: 20)
        
        }
      //  .fixedSize()
        .frame(/*width: 50, */height: 35, alignment: .leading)
        .fixedSize(horizontal: true, vertical: false)
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

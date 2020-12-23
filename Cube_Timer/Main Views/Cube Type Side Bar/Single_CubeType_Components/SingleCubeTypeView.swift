//
//  SingleCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 11/28/20.
//

import SwiftUI



struct SingleCubeTypeView: View/*, Identifiable */{
    
    var ct: CubeType
    @ObservedObject private var controller: SingleCubeTypeViewController
    private var ctHandler: CTypeHandler
    
    init(ct: CubeType, controller: SingleCubeTypeViewController, ctHandler: CTypeHandler) {
        self.ct = ct
        self.controller = controller
        self.ctHandler = ctHandler
    }
    
    /*
    var id: UUID
    
    var parent: SidebarView
    var contentView: ContentView
    var d1: Int // dimensions of the cube
    var d2: Int
    var d3: Int
    var rawName: String
    var desc: String
    */
 
 
    /*
    @State var widdlePos: CGPoint = CGPoint(x: 0,y: 0)
    var wiggleTimer: Timer?
    */
    
    /*
    @State var selected: Bool = false
    @State var editMode: Bool = false
    */
    
    var body: some View {
        ZStack {
            
           // if selected {
            
           // }
             
            HStack {
                CubeIcon(controller.d1,controller.d2,controller.d3, width: 15)
                    //.frame(width: 30, height:30)
                    .opacity(0.8)
                VStack(alignment: .leading) {
                    Text(controller.rawName)
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                    Text(controller.desc)
                        .font(.system(size: 9))
                }
                .offset(x: 8)
                //
                
                /*
                 Spacer()
                 
               if controller.editMode {
                    Button(action: {
                        //contentView.showCTPopupFor(id: id)
                        controller.tappedEdit()
                    }, label: {
                        Image(systemName: "pencil.tip.crop.circle")
                    })
                    .frame(width: 50, height: 40, alignment: .trailing)
               }
 */
                
            }
            .foregroundColor( Color.init("mint_cream"))
            .offset(x: 20)
            .offset(x: (controller.selected ? CGFloat.random(in: 1..<5) : -5))
            .animation((controller.selected ? Animation.easeInOut(duration: 1).repeatForever(autoreverses: true) : Animation.easeInOut))
            .onTapGesture {
                self.controller.select()
            }
            .opacity(controller.selected ? 1 : 0.4 )
            
            
            //.offset(x: 20)
        }.frame(width: 150, height: 40, alignment: .leading)
    }
    
    /*
    public mutating func select() {
        self.selected = true
    }
    
    public func deselect() {
        self.selected = false
    }
    
    public func toggleEditMode() {
        editMode.toggle()
    }
    */
 
}

struct SingleCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("black_chocolate")
            SingleCubeTypeView(ct: CubeType(), controller: SingleCubeTypeViewController(ct: CubeType(), ctHandler: CTypeHandler()), ctHandler: CTypeHandler())
       
        }
    }
}

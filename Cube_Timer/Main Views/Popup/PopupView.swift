//
//  PopupView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import SwiftUI

struct PopupView: View {
    
    var contentView: ContentView
    var ctEditController: CTEditController // used to move the fucking box
    var popupController: PopupController
    
    /*
     * this got moved to CTEditController.swift (fuck me)
    @State var popupOffsetY: CGFloat = 0
    @State var popupOffsetX: CGFloat = 0

    public func offsetPopup(x: CGFloat = 0, y: CGFloat = 0) {
        self.popupOffsetY = y
        self.popupOffsetX = x
    }
    
    public func unfocusTextField() {
        self.popupOffsetX = 0
        self.popupOffsetY = 0
    }
     */
    
    public func hide() {
        ctEditController.unfocusTextField()
        contentView.hidePopup()
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            let popupWidth = geo.size.width / 2
            let popupHeight:CGFloat = 200
            
            ZStack {
                ZStack {
                    Color.init("very_dark_black")
                        .cornerRadius(10)
                        .shadow(radius: 15)
                        .onTapGesture {
                            ctEditController.unfocusTextField()
                        }
                    
                    
                        Button(action: {
                            self.hide()
                        }, label: {
                            Image.init(systemName: "xmark")
                                .foregroundColor(.init("mint_cream"))
                                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                .frame(width: 50, height: 50, alignment: .center)
                        })
                        .position(x: popupWidth - 25, y: 20)
                        .zIndex(9)
                   
                    
                    /*
                     * this area will implement the choosing of what view to display for the popup
                     */
                    //NewCubeTypeView(parent: self)
                    popupController.currentView
                    
                }
                .frame(width: geo.size.width/2, height: popupHeight, alignment: .center)
                .animation(.spring())
                .offset(x: ctEditController.popupOffsetX, y:ctEditController.popupOffsetY)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            Color.black
                .opacity(0.8)
            
            PopupView(contentView: ContentView(), ctEditController: CTEditController(), popupController: PopupController())
            
            
        }.previewLayout(PreviewLayout.fixed(width: 568, height: 320))
    }
}

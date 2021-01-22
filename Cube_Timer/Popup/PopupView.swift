//
//  PopupView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import SwiftUI

struct PopupView: View {
    
    var contentView: ContentView
    @EnvironmentObject var ctEditController: CTEditController // used to move the fucking box
    @EnvironmentObject var popupController: PopupController
    @EnvironmentObject var cvc: ContentViewController
 
    
    public func hide() {
        popupController.unfocusTextField()
        cvc.hidePopup()
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            let popupWidth = geo.size.width / 2
            let popupHeight:CGFloat = 200
            
            ZStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.init("very_dark_black").opacity(0.9))
                        .addBorder(Color.init("dark_black").opacity(0.5), width: 1, cornerRadius: 5)
                        .shadow(radius: 15)
                        .onTapGesture {
                            popupController.unfocusTextField()
                        }
                    
                    /*
                     *  Top bar
                     */
                    HStack(alignment: .bottom) {
                        /*
                         *  Title
                         */
                        if popupController.title != nil {
                            Text(popupController.title!)
                                .font(Font.custom("Play-Bold", size: 15))
                                .foregroundColor(.init("mint_cream"))
                        }
                            
                        Spacer()
                        
                        /*
                        x button
                         */
                        Button(action: {
                            self.hide()
                        }, label: {
                            
                            IconButton(icon: Image.init(systemName: "xmark"), bgColor: Color.init("red"), iconColor: Color.init("mint_cream"))
                            
                            /*
                            Image.init(systemName: "xmark")
                                .foregroundColor(.init("mint_cream"))
                                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                                .frame(width: 50, height: 50, alignment: .center)
                            */
                        })
                    }
                    .frame(width: geo.size.width/2)
                    .position(x: popupWidth / 2, y: -20)
                    .zIndex(9)
                   
                    /*
                     *  the current view
                     */
                    if cvc.popupShowing {
                        popupController.currentView
                            .transition(.opacity)
                            .animation(.spring(response: 0.2))
                    }
                    
                }
                .frame(width: geo.size.width/2, height: popupHeight, alignment: .center)
                .offset(x: popupController.popupOffsetX, y:popupController.popupOffsetY)
                //.offset(x: ctEditController.popupOffsetX, y:ctEditController.popupOffsetY)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
        
    }
}

extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}

struct PopupView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            Color.black
                .opacity(0.8)
            
            PopupView(contentView: ContentView())
            
            
        }.previewLayout(PreviewLayout.fixed(width: 568, height: 320))
    }
}

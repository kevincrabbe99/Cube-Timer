//
//  NewCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import SwiftUI

enum ptConfig: String {
    case cube = "cube"
    case custom = "custom"
}

struct NewCubeTypeView: View {
    
    //var parent: PopupView!
    var controller: CTEditController!
    
    @EnvironmentObject var cTypeHandler: CTypeHandler
    
   // var parent: PopupController!
    @EnvironmentObject var parent: PopupController
    @EnvironmentObject var alertController: AlertController
    
   // var setCT: CubeType?
    
   // @State var title: String = "ENTER A NEW CUBE"
    
    @State var description: String = ""
    @State var customName: String = ""
    @State var d1: Int = 3
    @State var d2: Int = 3
    @State var d3: Int = 3
    
    @State var currentPTConfig: ptConfig = .cube
    
    let configDimensionOptions: [Int] = [2,3,4,5,6,7,8,9]
    
    let generator = UINotificationFeedbackGenerator()
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    
    
    init(controller: CTEditController/*, parent: PopupController*/) {
       self.controller = controller
       //self.parent = parent
       //self.setCT = nil
   }
 
 
    private func selectCube() {
        print("settings currentPTConfig = .cube")
        
        lightTap.impactOccurred()
        
        self.currentPTConfig = .cube
    }
    
    private func selectCustom() {
        print("settings currentPTConfig = .custom")
        
        lightTap.impactOccurred()
            
        self.currentPTConfig = .custom
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            let w: CGFloat = geo.size.width
            let h: CGFloat = geo.size.height
            
            let innerW:CGFloat = w-80
            
            VStack(spacing: 0) {
                
                
                /*
                 *  Top bar menu
                 */
                ZStack {
                    
                    HStack(spacing: 0.0) {
                        
                       
                        ZStack {
                            Color.init(currentPTConfig == .cube ? "dark_black" : "very_dark_black")
                                .cornerRadius(5, corners: .topLeft)
                                .opacity(0.4)
                            
                            Text("CUBE")
                        }
                        .onTapGesture {
                                selectCube()
                        }
                    
                        
                        
                        ZStack {
                            Color.init(currentPTConfig == .custom ? "dark_black" : "very_dark_black")
                                .cornerRadius(5, corners: .topRight)
                                .opacity(0.4)
                            
                            Text("CUSTOM")
                        }
                        .onTapGesture {
                            selectCustom()
                        }
                        
                    }
                    .font(Font.custom("Play-Bold", size: 15))
                }
                .padding([.top, .leading, .trailing],1)
                .frame(height: 35)
                .zIndex(30)
   
                /*
                 * picker / custom entry
                 */
                if currentPTConfig == .cube {
                    HStack {
                        /*
                         * if  in cube mode
                         */
                        
                        Picker(selection: $d1, label: Text("")) {
                            ForEach(0..<configDimensionOptions.count) {
                                Text(String(self.configDimensionOptions[$0]))
                                    .foregroundColor(.white)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 60, height: 90)
                        .labelsHidden()
                        .clipped()
                        
                        Spacer()
                        Image.init(systemName: "xmark")
                            .font(Font.system(size: 15, weight: .bold))
                        Spacer()
                        
                        Picker(selection: $d2, label: Text("")) {
                            ForEach(0..<configDimensionOptions.count) {
                                Text(String(self.configDimensionOptions[$0]))
                                    .foregroundColor(.white)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 60, height: 90)
                        .labelsHidden()
                        .clipped()
                        
                        Spacer()
                        Image.init(systemName: "xmark")
                            .font(Font.system(size: 15, weight: .bold))
                        Spacer()
                        
                        Picker(selection: $d3, label: Text("")) {
                            ForEach(0..<configDimensionOptions.count) {
                                Text(String(self.configDimensionOptions[$0]))
                                    .foregroundColor(.white)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 60, height: 90)
                        .labelsHidden()
                        .clipped()
                        
                        
                    }
                    .frame(width: innerW, height: 90)
                    .font(Font.system(size: 13, weight: .bold))
                    
                } else {
                    /*
                     * if  in custom mode
                     */
                    ZStack {
                        if customName.isEmpty {
                            Text("TAP TO ENTER A NAME")
                                .font(Font.custom("Play-Bold", size: 25))
                                .multilineTextAlignment(.leading)
                                .opacity(0.7)
                        }
                        
                        TextField("", text: $customName, onEditingChanged: { editing in
                            if editing {
                                let offset:CGFloat = -1*(h/2)
                                parent.offsetPopup(y: offset) // moves the popup up a little so they can see what they are typing
                            }else {
                                parent.offsetPopup(y: 0) // moves the popup back to the center
                            }
                        })
                        .font(Font.custom("Play-Bold", size: 25))
                        .frame(width: innerW)
                        .multilineTextAlignment(.leading)
                        
                    }
                    .frame(width: innerW, height: 90)
                    
                }
        
                /*
                 *  TextBox stuff
                 */
                ZStack {
                    Color.init("mint_cream")
                        .cornerRadius(3)
                        .opacity(0.9)
                        .addBorder(Color.white, width: 1, cornerRadius: 3)
                        .shadow(radius: 4)
                    
                    if description.isEmpty {
                        ZStack {
                        Text("Enter a description")
                            .font(Font.custom("Play-Bold", size: 12.5))
                            .foregroundColor(.init("very_dark_black"))
                            .opacity(0.6)
                            
                        }
                        .frame(width: innerW-20, alignment: .leading)
                        
                    }
                    
                    TextField("", text: $description, onEditingChanged: { editing in
                        if editing {
                            let offset:CGFloat = -1*(h/2)
                            parent.offsetPopup(y: offset) // moves the popup up a little so they can see what they are typing
                        }else {
                            parent.offsetPopup(y: 0) // moves the popup back to the center
                        }
                    })
                    .font(Font.custom("Play-Bold", size: 12.5))
                    .foregroundColor(.init("very_dark_black"))
                    .frame(width: innerW-20)
                    .font(.system(size:14))
                    .foregroundColor(.black)
                    
                    
                
                }
                .font(Font.custom("Play-Bold", size: 12.5))
                .frame(width: innerW, height: 30, alignment: .center)
               
                
                /*
                 *  Go button
                 */
                ZStack {
                    Button(action: {
                        
                        // try add create cube
                        self.attemptCreateNewPuzzle()
                        
                    }, label: {
                        RoundedButton(color: Color.init("mint_cream"), text: "CREATE", textColor: Color.init("very_dark_black"))
                     
                    })
                }
                .frame(width: innerW, alignment: .trailing)
                .padding(.top, 25)
                .offset(x: 20)
 
                
                
            }
            .frame(width: (w), height: (h), alignment: .top)
            .position(x: w/2, y: h/2)
            //.offset(y: -14)
            .foregroundColor(.init("mint_cream"))
        }
        
    }
    
    private func attemptCreateNewPuzzle() {
        
        // check if description is not empty
        if description.isEmpty || description == "" {
        
            generator.notificationOccurred(.error)
            
            alertController.makeAlert(icon: Image.init(systemName: "capsule"), title: "Missing Description", text: "Please enter a description for the puzzle.", duration: 3, iconColor: Color.init("yellow"))
            
        return }
        
        // if is cube
        if currentPTConfig == .cube {
            
            controller.addCT(d1: (d1+2), d2: (d2+2), d3: (d3+2), desc: description) // we add 2 to offset for the Picker start point
            parent.hidePopup()
            
        } else if (currentPTConfig == .custom){ // if it is custom
            
            // check if name is blank
            if customName.isEmpty || customName == "" {
            
                generator.notificationOccurred(.error)
                
                alertController.makeAlert(icon: Image.init(systemName: "capsule"), title: "Missing Puzzle Name", text: "Please enter a name for the puzzle.", duration: 3, iconColor: Color.init("yellow"))
                
            return }
            
            cTypeHandler.add(customName: customName, desc: description)
            parent.hidePopup()
            
        }
        
        
        
    }

}


struct NewCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            NewCubeTypeView(controller: CTEditController())
        }
        .previewLayout(PreviewLayout.fixed(width: 350, height: 200))
    }
}

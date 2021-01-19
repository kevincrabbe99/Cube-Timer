//
//  EditCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/20/20.
//

import SwiftUI

struct EditCubeTypeView: View {
    
    @EnvironmentObject var cTypeHandler: CTypeHandler
    @EnvironmentObject var alertController: AlertController
    
    //var parent: PopupView!
    var controller: CTEditController!
    var parent: PopupController!
    
    var setCT: CubeType?
    
    //@State var title: String = "ENTER A NEW CUBE"
    
    @State var description: String = "Fake Description"
    @State var customName: String = ""
    @State var d1: Int = 3
    @State var d2: Int = 3
    @State var d3: Int = 3
    
    @State var currentPTConfig: ptConfig = .cube
    
    let configDimensionOptions: [Int] = [2,3,4,5,6,7,8,9]

    @State var deleteGuardCounter: Int = 0
        
    
    let generator = UINotificationFeedbackGenerator()
    let lightTap = UIImpactFeedbackGenerator(style: .light)

    init(controller: CTEditController, parent: PopupController, setCT: CubeType?) {
        self.controller = controller
        self.parent = parent
        self.setCT = setCT
        self.customName = setCT!.cstmName
    }
 
    /*
     * called on appear
     */
    private func updateValuesFromSetCT() {
        if setCT != nil {
            print("setting to ", setCT?.descrip as Any)
            self.description = setCT!.descrip
            self.d1 = Int(setCT!.d1 - 2)
            self.d2 = Int(setCT!.d2 - 2)
            self.d3 = Int(setCT!.d3 - 2)
            
            // goto custom view is puzzle is custom
            if setCT!.isCustom() {
                self.currentPTConfig = .custom
                self.customName = setCT!.cstmName
            }
        }
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
            
            VStack(spacing: 0.0) {
                
            
                
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
                                .opacity(0.75)
                            
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
                            .font(Font.system(size: 13, weight: .bold))
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
                            .font(Font.system(size: 13, weight: .bold))
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
                    
                //.offset(y: 10)
        
                /*
                 *  TextBox stuff
                 */
                ZStack {
                    Color.init("mint_cream")
                        .cornerRadius(3)
                        .opacity(0.9)
                        .addBorder(Color.white, width: 1, cornerRadius: 3)
                        .shadow(radius: 4)
                    
                    TextField("enter a description", text: $description, onEditingChanged: { editing in
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
                .frame(width: innerW, height: 30, alignment: .center)
               
                
                HStack {
                    /*
                     *  BUTTON DELETE
                     */
                    //deleteButton(controller: controller, contentView: contentView, w: w, id: setCT!.id!)
                    Button(action: {
                        if deleteGuardCounter > 0 {
                            controller.deleteCT(id: (setCT?.id)!)
                            parent.hidePopup()
                        } else {
                            alertController.makeAlert(icon: Image(systemName: "trash.fill"), title: "Are you sure you want to delete this puzzle?", text: "This will permently delete your puzzle and the reference to its saved times!")
                            deleteGuardCounter += 1
                            
                        }
                    }, label: {
                        RoundedButton(      color:(deleteGuardCounter == 0 ? Color.init("mint_cream") : Color.init("red")),
                                            text: "DELETE",
                                            textColor: Color.init("very_dark_black"))
                   
                    })
                    
                    
                    /*
                     * update button
                     updateButton(w: w)
                     */
                    Button(action: {
                        
                        
                        attemptEditPuzzle()
                        
                    }, label: {
                        
                        RoundedButton(      color: (Color.init("mint_cream")),
                                            text: "UPDATE",
                                            textColor: Color.init("very_dark_black"))
                        
                        
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
        .onAppear {
            updateValuesFromSetCT()
        }
        
    }
    
    private func attemptEditPuzzle() {
        
        // check if description is not empty
        if description.isEmpty || description == "" {
        
            generator.notificationOccurred(.error)
            
            alertController.makeAlert(icon: Image.init(systemName: "capsule"), title: "Missing Description", text: "Please enter a description for the puzzle.", duration: 3, iconColor: Color.init("yellow"))
            
        return }
        
        // if is cube
        if currentPTConfig == .cube {
            
            cTypeHandler.edit(setCT!, d1: d1+2, d2: d2+2, d3: d3+2, desc: description)
            parent.hidePopup()
            
        } else if (currentPTConfig == .custom){ // if it is custom
            
            cTypeHandler.edit(setCT!, customName: customName, desc: description)
            parent.hidePopup()
            
        }
        
    }
    
}

struct EditCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        EditCubeTypeView(controller: CTEditController(), parent: PopupController(), setCT: CubeType())
    }
}

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
    
    @State var description: String = "Some bullshit"
    @State var d1: Int = 3
    @State var d2: Int = 3
    @State var d3: Int = 3
    
    
    
    let configDimensionOptions: [Int] = [2,3,4,5,6,7,8,9]

    @State var deleteGuardCounter: Int = 0
    

    init(controller: CTEditController, parent: PopupController, setCT: CubeType?) {
        self.controller = controller
        self.parent = parent
        self.setCT = setCT
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
        }
    }
 
    
    var body: some View {
        
        GeometryReader { geo in
            
            let w: CGFloat = geo.size.width
            let h: CGFloat = geo.size.height
            
            let innerW:CGFloat = w-80
            
            VStack(spacing: 0.0) {
                
                /*  GOT REPLACED BY POPUPVIEW
                 *  title
                //if !isEditing() {
                Text("EDIT CUBE")
                    .font(Font.custom("Heebo-Black", size: 23))
                    .foregroundColor(.init("mint_cream"))
                 .frame(width: w-20, alignment: .leading)
                    .offset(x: 20, y: 10)
                /*
                }else {
                    Text("EDIT CUBE")
                        .fontWeight(.black)
                        .font(.system(size: 20))
                        .foregroundColor(.init("mint_cream"))
                        .frame(width: w-20, alignment: .leading)
                        .offset(x: 20, y: 10)
                }
                    */
                 */
                
                /*
                 *  Top bar menu
                 */
                ZStack {
                    
                    HStack(spacing: 0.0) {
                        ZStack {
                            Color.init("dark_black")
                                .cornerRadius(5, corners: .topLeft)
                                .opacity(0.4)
                            
                            Text("CUBE")
                        }
                            
                        
                        ZStack {
                            Color.init("very_dark_black")
                                .cornerRadius(5, corners: .topRight)
                                .opacity(0.75)
                            
                            Text("CUSTOM")
                        }
                    }
                    .font(Font.custom("Play-Bold", size: 15))
                }
                .padding([.top, .leading, .trailing],1)
                .frame(height: 35)
                
                
                
   
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
                    .frame(width: w-120)
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
                        cTypeHandler.edit(setCT!, d1: d1+2, d2: d2+2, d3: d3+2, desc: description)
                        parent.hidePopup()
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
}

struct EditCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        EditCubeTypeView(controller: CTEditController(), parent: PopupController(), setCT: CubeType())
    }
}

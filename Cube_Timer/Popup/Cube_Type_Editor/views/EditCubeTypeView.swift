//
//  EditCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/20/20.
//

import SwiftUI

struct EditCubeTypeView: View {
    
    //var parent: PopupView!
    var controller: CTEditController!
    var contentView: ContentView!
    
    var setCT: CubeType?
    
    //@State var title: String = "ENTER A NEW CUBE"
    
    @State var description: String = "Some bullshit"
    @State var d1: Int = 3
    @State var d2: Int = 3
    @State var d3: Int = 3
    
    let configDimensionOptions: [Int] = [2,3,4,5,6,7,8,9]
    
    /*
    init(controller: CTEditController, contentView: ContentView) {
       self.controller = controller
        self.contentView = contentView
       //self.setCT = nil
   }
 */
    
    init(controller: CTEditController, contentView: ContentView, setCT: CubeType?) {
        
        
        self.controller = controller
        self.contentView = contentView
        self.setCT = setCT
    }
 
    /*
     * called on appear
     */
    private func updateValuesFromSetCT() {
        if setCT != nil {
            print("setting to ", setCT)
            self.description = setCT!.descrip
            self.d1 = Int(setCT!.d1 - 2)
            self.d2 = Int(setCT!.d1 - 2)
            self.d3 = Int(setCT!.d1 - 2)
        }
    }
 
    
    var body: some View {
        
        GeometryReader { geo in
            
            let w: CGFloat = geo.size.width
            let h: CGFloat = geo.size.height
            
            let innerW:CGFloat = w-100
            
            VStack {
                
                /*
                 *  title
                 */
                //if !isEditing() {
                Text("EDIT CUBE")
                        .fontWeight(.black)
                        .font(.system(size: 20))
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
   
                HStack {
                    
                    
                    Picker(selection: $d1, label: Text("")) {
                        ForEach(0..<configDimensionOptions.count) {
                            Text(String(self.configDimensionOptions[$0]))
                                .foregroundColor(.white)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 60, height: 40)
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
                    .frame(width: 60, height: 40)
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
                    .frame(width: 60, height: 30)
                    .labelsHidden()
                    .clipped()
                    
                    
                }
                .frame(width: innerW, height: 60)
        
                /*
                 *  TextBox stuff
                 */
                ZStack {
                    Color.init("mint_cream")
                        .cornerRadius(3)
                        .shadow(radius: 4)
                    
                    TextField("enter a description", text: $description, onEditingChanged: { editing in
                        if editing {
                            let offset:CGFloat = -1*(h/2)
                            controller.offsetPopup(y: offset) // moves the popup up a little so they can see what they are typing
                        }else {
                            controller.offsetPopup(y: 0) // moves the popup back to the center
                        }
                    })
                    .frame(width: w-120)
                    .font(.system(size:14))
                    .foregroundColor(.init("black_chocolate"))
                
                }
                .frame(width: innerW, height: 30, alignment: .center)
               
                
                HStack {
                    /*
                     *  BUTTON DELETE
                     */
                    //deleteButton(controller: controller, contentView: contentView, w: w, id: setCT!.id!)
                    Button(action: {
                        controller.deleteCT(id: (setCT?.id)!)
                        contentView.hidePopup()
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(LinearGradient(
                                    gradient: .init(colors: [Color.init("very_dark_black"), Color.init("dark_black")]),
                                      startPoint: .init(x: 0, y: 1),
                                    endPoint: .init(x: 1.5, y: -0.5)
                                    ))
                                //.shadow(radius: 5)
                            
                            Text("DELETE")
                                .foregroundColor(.white)
                                .font(.system(size:13))
                                .fontWeight(.bold)
                        }
                        .frame(width: 90, height: 35, alignment: .center)
                    })
                    
                    
                    /*
                     * update button
                     updateButton(w: w)
                     */
                    Button(action: {
                        
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(LinearGradient(
                                    gradient: .init(colors: [Color.init("very_dark_black"), Color.init("dark_black")]),
                                      startPoint: .init(x: 0, y: 1),
                                    endPoint: .init(x: 1.5, y: -0.5)
                                    ))
                                //.shadow(radius: 5)
                            
                            Text("UPDATE")
                                .foregroundColor(.white)
                                .font(.system(size:13))
                                .fontWeight(.bold)
                        }
                        .frame(width: 90, height: 35, alignment: .center)
                        
                    })
                }.frame(width: innerW, alignment: .trailing)
               
                
                
            }
            .frame(width: (w-20), height: (h-20), alignment: .topLeading)
            .position(x: w/2, y: h/2)
            .foregroundColor(.init("mint_cream"))
                
        }
        .onAppear {
            updateValuesFromSetCT()
        }
        
    }
}

struct EditCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        EditCubeTypeView(controller: CTEditController(), contentView: ContentView(), setCT: CubeType())
    }
}
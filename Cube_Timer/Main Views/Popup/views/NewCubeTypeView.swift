//
//  NewCubeTypeView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/19/20.
//

import SwiftUI

struct NewCubeTypeView: View {
    
    var parent: PopupView
    
    @State var description: String = ""
    @State var d1: Int = 3
    @State var d2: Int = 3
    @State var d3: Int = 3
    
    let configDimensionOptions: [Int] = [2,3,4,5,6,7,8,9]
    
    var body: some View {
        
        GeometryReader { geo in
            
            let w: CGFloat = geo.size.width
            let h: CGFloat = geo.size.height
            
            VStack {
                
                /*
                 *  title
                 */
                Text("ENTER A NEW CUBE")
                    .fontWeight(.black)
                    .font(.system(size: 20))
                    .foregroundColor(.init("mint_cream"))
                    .frame(width: w-20, alignment: .leading)
                    .offset(x: 20, y: 10)
                
                HStack {
                    
                    
                    Picker("Configure Dimensions", selection: $d1) {
                        ForEach(0..<configDimensionOptions.count) {
                            Text(String(self.configDimensionOptions[$0]))
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
                    
                    Picker("Configure Dimensions", selection: $d2) {
                        ForEach(0..<configDimensionOptions.count) {
                            Text(String(self.configDimensionOptions[$0]))
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
                    
                    Picker("Configure Dimensions", selection: $d3) {
                        ForEach(0..<configDimensionOptions.count) {
                            Text(String(self.configDimensionOptions[$0]))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 60, height: 30)
                    .labelsHidden()
                    .clipped()
                    
                    
                }
                .frame(width: (w-100), height: 60)
                
                /*
                 *  TextBox stuff
                 */
                ZStack {
                    Color.init("mint_cream")
                        .cornerRadius(3)
                        .shadow(radius: 4)
                    
                    TextField("enter a description", text: $description, onEditingChanged: { editing in
                        if editing {
                            parent.offsetPopup(y: -1*(h/2)) // moves the popup up a little so they can see what they are typing
                        }else {
                            parent.offsetPopup(y: 0) // moves the popup back to the center
                        }
                    })
                    .frame(width: w-120)
                    .font(.system(size:14))
                    .foregroundColor(.init("black_chocolate"))
                
                }
                .frame(width: w-100, height: 30, alignment: .center)
               
                
                /*
                 *  Go button
                 */
                ZStack {
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
                            
                            Text("CREATE!")
                                .foregroundColor(.white)
                                .font(.system(size:13))
                                .fontWeight(.bold)
                        }
                        .frame(width: 90, height: 35, alignment: .center)
                    })
                }
                .frame(width: w-100, alignment: .trailing)
                
                
            }
            .frame(width: w - 20, height: h - 20, alignment: .topLeading)
            .position(x: w/2, y: h/2)
        }
        
    }
}

struct NewCubeTypeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            NewCubeTypeView(parent: PopupView(contentView: ContentView()))
        }
        .previewLayout(PreviewLayout.fixed(width: 350, height: 200))
    }
}

//
//  EditSolveView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/27/20.
//

import SwiftUI

struct EditSolveView: View {
    
    var controller: EditSolveController
    var parent: PopupController
    
    var solves: [SolveItem] = []
    
    init(controller: EditSolveController, parent: PopupController, solves: [SolveItem], selection: Int? = 1) {
        self.controller = controller
        self.parent = parent
        self.solves = solves
        print("numer of solves: ", solves.count)
    }
    
    /* this will be replaced by controller.cTypeHandler.types
    let configTypes: [String] = [
        "3x3x3, Origional",
        "4x4x4, Origional Brand",
        "5x5x5, Origional Brand",
        "6x6x6, Origional Brand"
    ]
    */
    
    @State var selection: Int = 0
    
    /*
     * called from view when button is pressed
    private func update() {
        // should call controller and the controller deals with solveHandler to get it updated
        self.controller.setCtTo(ct: controller.cTypeHandler.typeControllers[selection].ct, solves: solves)
    }
     */
    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
                /*
                 *  the view with all the selected solves
                 */
                HStack {
                    ForEach (solves) { s in
                        SolveElementView(solveItem: s)
                            .environmentObject(SolveElementController(si: s))
                        //Text(s.getTimeCapture()!.getInSolidForm())
                    }
                }
                .padding(.top, 10)
                .frame(width: geo.size.width)
                
                VStack {
                    Text("UPDATE CUBE TYPE")
                        .fontWeight(.black)
                    
                    Picker(selection: $selection, label: Text("Picker")) {
                        ForEach(0..<controller.cTypeHandler.getCubeTypes().count) {
                            Text( controller.cTypeHandler.getCubeTypes()[$0].name )
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geo.size.width * 0.8, height: 70)
                    .labelsHidden()
                    .clipped()
                    
                }
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .frame(width: geo.size.width, alignment: .center)
                
                
                ZStack {
                    Button(action: {
                        self.controller.setCtTo(ct: controller.cTypeHandler.getCubeTypes()[selection], solves: solves)
                        parent.hidePopup()
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
                }
                .frame(width: geo.size.width-100, alignment: .trailing)
                
            }
            .foregroundColor(Color.init("mint_cream"))
            
        }// end geo
        
    }
    
    
}

struct EditSolveView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
        
            EditSolveView(controller: EditSolveController(), parent: PopupController(), solves: [])
            
        }
        .previewLayout(PreviewLayout.fixed(width: 350, height: 200))
    }
}

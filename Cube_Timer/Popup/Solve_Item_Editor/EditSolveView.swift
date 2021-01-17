//
//  EditSolveView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/27/20.
//

import SwiftUI

struct EditSolveView: View {
    
    @EnvironmentObject var controller: EditSolveController
    @EnvironmentObject var parent: PopupController
    @EnvironmentObject var allSolvesController: AllSolvesController
    @EnvironmentObject var cTypeHandler: CTypeHandler
    
    
    var solveControllers: [SolveElementController] = []
    var solves: [SolveItem] {
        var res: [SolveItem] = []
        for sc in solveControllers {
            res.append(sc.si)
        }
        return res
    }
    
    init(/*controller: EditSolveController, parent: PopupController,*/ solves: [SolveElementController], selection: Int? = 1) {
     //   self.controller = controller
    //    self.parent = parent
        self.solveControllers = solves
        print("numer of solves: ", solves.count)
    }
    
    
    
 
    
    @State var selection: Int = 0

    
    var body: some View {
        
        GeometryReader { geo in
            
            VStack {
                
       
                
                VStack(spacing: 0) {
                    Text("UPDATE CUBES FOR \(allSolvesController.selected.count) SOLVES")
                        .font(Font.custom("Heebo-Black", size: 20))
                        .padding(20)
                    
                    Picker(selection: $selection, label: Text("Picker")) {
                        ForEach(0..<controller.cTypeHandler.getCubeTypes().count) {
                            SingleCubeTypeView(controller: controller.cTypeHandler.typeControllers[$0], asSidebar: false)
                            //Text( controller.cTypeHandler.getCubeTypes()[$0].name )
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: geo.size.width * 0.65, height: 70)
                    .labelsHidden()
                   // .clipped()
                    .offset(y: -15) // damn
                    
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
                            RoundedButton(color: Color.init("mint_cream"), text: "UPDATE", textColor: Color.init("very_dark_black"))
          
                        }
                        .frame(width: 90, height: 35, alignment: .center)
                    })
                }
                .frame(width: geo.size.width-100, alignment: .trailing)
                
            }
            .foregroundColor(Color.init("mint_cream"))
            
        }// end geo
        .onAppear {
            self.selection = cTypeHandler.getIndexFrom(id: cTypeHandler.selected.id!)
        }
        
    }
    
    
}

struct EditSolveView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
        
            EditSolveView(/*controller: EditSolveController(), parent: PopupController(),*/ solves: [])
            
        }
        .previewLayout(PreviewLayout.fixed(width: 350, height: 200))
    }
}

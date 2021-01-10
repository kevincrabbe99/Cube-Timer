//
//  DeleteSolvesView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/30/20.
//

import SwiftUI

struct DeleteSolvesView: View {
    
    @EnvironmentObject var allSolvesController: AllSolvesController
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var solveHandler: SolveHandler
    
    var body: some View {
        
        VStack {
            
            Text("Are you sure you want to delete \(allSolvesController.selected.count) solves?"/* \(allSolvesController.selected.count > 1 ? "solves?" : "solve?")"*/)
                .font(Font.custom("Heebo-Black", size: 24))
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            HStack(spacing: 20) {
                
                Button(action: {
                    cvc.hidePopup()
                }, label: {
                    RoundedButton(color: Color.init("mint_cream"), text: "CANCEL", textColor: Color.init("very_dark_black"))
              
                })
                
                Button(action: {
                    solveHandler.deleteSelectedSolves() // deletes solves
                    cvc.hidePopup()
                }, label: {
                    RoundedButton(color: Color.init("red"), text: "DELETE")
                })
                
                
            }
            
        } // end main vstack
        .foregroundColor(.init("mint_cream"))
        .padding(20)
        
    }
}

struct RoundedButton: View {
    
    var color: Color
    var text: LocalizedStringKey
    var textColor: Color = Color.white
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(color.opacity(0.8))
                .border(color, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                .cornerRadius(3)
            
            Text(text)
                .fontWeight(.bold)
                .foregroundColor(textColor)
        }
        .frame(width: 120, height: 35)
    }
    
}

struct DeleteSolvesView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
        
            DeleteSolvesView()
                .environmentObject(AllSolvesController())
            
        }
        .previewLayout(PreviewLayout.fixed(width: 350, height: 200))
    }
}

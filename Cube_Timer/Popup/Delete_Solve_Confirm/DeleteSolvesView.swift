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
                .font(Font.custom("Play-Bold", size: 27))
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .multilineTextAlignment(.center)
            
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
        .padding([.leading, .trailing], 20)
        .offset(y: -10)
        
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

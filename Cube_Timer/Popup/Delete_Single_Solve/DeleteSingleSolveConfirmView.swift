//
//  DeleteSingleSolveConfirmView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/15/21.
//

import SwiftUI

struct DeleteSingleSolveConfirmView: View {
    
    @EnvironmentObject var allSolvesController: AllSolvesController
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var solveHandler: SolveHandler
    
    var solveItem: SolveItem!
    
    init(toDelete: SolveItem) {
        self.solveItem = toDelete
    }
    
    var body: some View {
        
        
        
        VStack {
            
            
            Text(LocalizedStringKey("Are you sure you want to delete: \((self.solveItem.getTimeCapture()?.getAsReadable())!)"))
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
                    
                    // hide cvc popups before deleting
                    self.cvc.closeVideo()
                    self.cvc.closeDetails()
                    cvc.hidePopup()
                    
                    solveHandler.deleteSingleSolve(solveItemToDelete: self.solveItem)
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

struct DeleteSingleSolveConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteSingleSolveConfirmView(toDelete: SolveItem())
    }
}

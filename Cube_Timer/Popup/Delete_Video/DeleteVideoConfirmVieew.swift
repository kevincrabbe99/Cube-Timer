//
//  DeleteVideoConfirmVieew.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/15/21.
//

import SwiftUI

struct DeleteVideoConfirmVieew: View {
    @EnvironmentObject var allSolvesController: AllSolvesController
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var solveHandler: SolveHandler
    @EnvironmentObject var alertController: AlertController
    
    var solveItem: SolveItem!
    
    init(itemWithVideo: SolveItem) {
        self.solveItem = itemWithVideo
    }
    
    var body: some View {
        
        VStack {
            
            Text(LocalizedStringKey("Are you sure you want to delete the saved video for: \((self.solveItem.getTimeCapture()?.getAsReadable())!)"))
                .font(Font.custom("Play-Bold", size: 24))
                .padding(.leading, 20)
                .padding(.trailing, 20)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                
                /*
                Button(action: {
                    cvc.hidePopup()
                }, label: {
                    RoundedButton(color: Color.init("mint_cream"), text: "CANCEL", textColor: Color.init("very_dark_black"))
              
                })
                */
                
                Button(action: {
                    solveItem.saveVideoToPhotos()
                    self.alertController.makeAlert(icon: Image.init(systemName: "film"), title: "Video Saved!", text: "Successfully saved video to camera roll!", duration: 3, iconColor: Color.init("black_chocolate"))
                }, label: {
                    RoundedButton(color: Color.init("mint_cream"), text: "SAVE TO PHOTOS", textColor: Color.init("very_dark_black"))
                })
                
                Button(action: {
                    
                    // hide video popup before deleting
                    cvc.showingVideo = false
                    
                    solveHandler.deleteVideoFor(solveItem: solveItem)
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

struct DeleteVideoConfirmVieew_Previews: PreviewProvider {
    static var previews: some View {
        DeleteVideoConfirmVieew(itemWithVideo: SolveItem())
    }
}

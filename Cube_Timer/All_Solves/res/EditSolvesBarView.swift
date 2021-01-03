//
//  EditSolvesBar.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/30/20.
//

import SwiftUI

struct EditSolvesBarView: View {
    
    @EnvironmentObject var allSolvesController: AllSolvesController
    @EnvironmentObject var cvc: ContentViewController
    
    var body: some View {
        
        GeometryReader { geo in
            
            HStack {
                
                /*
                 *  the option buttons
                 */
                HStack(spacing: 30) {
                    
                    Button(action: {
                        cvc.tappedDeleteSolves()
                    }, label: {
                        ZStack {
                            Color.clear
                            Image(systemName: "trash.fill")
                        }
                    })
                    .frame(width: 30, height: 80)
                    .zIndex(9)
                    
                    Button(action: {
                        cvc.tappedEditSolves(solves: allSolvesController.selected)
                    }, label: {
                        ZStack {
                            Color.clear
                            Image(systemName: "square.and.pencil")
                        }
                    })
                    .frame(width: 30, height: 80)
                    .zIndex(9)
                }
                
                // shows whats selected
                ZStack {
                    
                    /*
                     *  hStack for SolveElemenst
                     */
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach (allSolvesController.selected) { s in
                                if s.selected {
                                    SolveElementView(controller: s)
                                }
                            }
                        }
                    }
                    .frame(width: 300) // idk why this works
                    
                    
                    
                   // Text("solves")
                    
                }
                .padding(.leading, 30)
                
            } // end main HStack
            .foregroundColor(.white)
            .frame(width: geo.size.width, height: 30, alignment: .trailing)
            
        } // end geo
         
    }
}

struct EditSolvesBarVIew_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.init("very_dark_black")
            
            EditSolvesBarView()
                .border(Color.red, width: 1)
                .environmentObject(AllSolvesController())
                .frame(width: 200, height: 30, alignment: .trailing)
            
        }.previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
            
    }
}

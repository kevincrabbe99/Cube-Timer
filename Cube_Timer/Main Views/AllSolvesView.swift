//
//  AllSolvesView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/28/20.
//

import SwiftUI

struct AllSolvesView: View {
    
    var parent: ContentView
    var solveHandler: SolveHandler
    
    func gotoPage(_ p: Page) {
        parent.setPageTo(p)
    }
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Color.init("very_dark_black")
                
                
                
                ScrollView {
                    VStack {
                        ForEach (solveHandler.solves) { s in
                            Button(action: {
                                self.deleteFromCell(s)
                            }, label: {
                                HStack {
                                    Text( s.getTimeCapture()?.getAsReadable() ?? "-" )
                                    Spacer()
                                    Text( s.getDateString() )
                                    
                                }
                            })
                            Spacer()
                        }
                    }
                    .frame(width: 300)
                }
                
                HStack {
                    Button(action: {
                        gotoPage(.Main)
                    }, label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                    })
                }
                .frame(width: geo.size.width, alignment: .leading)
                .foregroundColor(.white)
                
                
            }
                
        }
    }
    
    func deleteFromCell(_ s: SolveItem) {
        print("should delete \(s.timeMS)")
        solveHandler.delete(s)
    }
    
}

struct AllSolvesView_Previews: PreviewProvider {
    static var previews: some View {
        AllSolvesView(parent: ContentView(), solveHandler: SolveHandler())
    }
}

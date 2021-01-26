//
//  ScrambleView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/25/21.
//

import SwiftUI


struct ScrambleView: View {
    
    @EnvironmentObject var scrambleController: ScrambleController
    
    
    var gridItemLayout = Array(repeating: GridItem(.flexible(), spacing: 3), count: ScrambleController.columns)
    
   
    var body: some View {
        /*
         *  DISPLAY PART
         */
        VStack(alignment: .leading, spacing: 0) {
         
            
            /*
             *  SEQUENCE
             */
            ZStack {
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: gridItemLayout, alignment: .trailing)  {
                    
                        ForEach(scrambleController.currnetScramble) { t in
                            ScrambleTurn(controller: t)
                        }
                        
                    }
                }
                .frame(height: scrambleController.heightBasedOnCount)
                .offset(y: 0)
                .onTapGesture {
                    scrambleController.toggleMaxamize()
                }
                .animation(.spring())
            }
            
            /*
             *  HEADER
             */
            HStack(spacing: 15) {
                ZStack {
                    Color.init("green")
                        .opacity(0.75)
                        .cornerRadius(3)
                    
                    Text("NEW SCRAMBLE")
                        .font(Font.custom("Play-Bold", size: 10))
                        .padding([.leading, .trailing], 5)
                        
                }
                .fixedSize()
                .frame(height: 20)
                .opacity(scrambleController.showingPrevious ? 0.3 : 1)
                
                ZStack {
                    Color.init("yellow")
                        .opacity(0.75)
                        .cornerRadius(3)
                    
                    Text("PREVIOUS SCRAMBLE")
                        .font(Font.custom("Play-Bold", size: 10))
                        .padding([.leading, .trailing], 5)
                        
                }
                .fixedSize()
                .frame(height: 20)
                .opacity(scrambleController.showingPrevious ? 1 : 0.3)
            }
            //.padding(.top, 15)
            .animation(.spring())
            
            
        }
        .frame(width: scrambleController.dynamicWidth - 200, alignment: .leading)
        .offset(y: 10)
        .onAppear {
            scrambleController.generateNewScramble()
        }
    }
}

struct ScrambleView_Previews: PreviewProvider {
    static var previews: some View {
        ScrambleView()
    }
}

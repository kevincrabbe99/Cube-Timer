//
//  DetailsView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/14/21.
//

import SwiftUI

struct DetailsView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var controller: DetailsViewController
    
    var body: some View {
        ZStack {
            
          
                
            VStack {
                HStack {
                    if controller.hasSolveItem {
                        
                        Text(controller.readableDate)
                            .font(Font.custom("Play-Bold", size: 14))
                    }
                    
                    Spacer()
                    
                    IconButton(icon: Image.init(systemName: "star"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24)
                        .padding(.trailing, 10)
                    
                    if controller.solveItem!.hasVideo {
                        Button(action: {
                            cvc.closeDetails()
                            cvc.openVideo(solveItem: controller.solveItem!)
                        }, label: {
                            IconButton(icon: Image.init(systemName: "play.rectangle.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24, iconWidth: 12, iconHeight: 9)
                                .padding(.trailing, 10)
                        })
                    }
                    
                    Button(action: {
                        cvc.tappedDeleteSingleSolve(itemToDelete: controller.solveItem)
                    }, label: {
                        IconButton(icon: Image.init(systemName: "trash.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24)
                            .padding(.trailing, 20)
                    })
                    
                
                    IconButton(icon: Image.init(systemName: "xmark"), bgColor: Color.init("red"), iconColor: Color.init("mint_cream"), width: 24, height: 24)
                        .onTapGesture {
                            cvc.closeDetails()
                        }
                }
                
                ZStack {
                    
                    Color.init("very_dark_black")
                        .cornerRadius(5)
                        .opacity(0.8)
                    
                    // dont show if SolveItem is not present
                    if controller.hasSolveItem {
                        
                        VStack {
                            HStack {
                                LabelDisplay(label: "Recorded Time")
                                Spacer()
                                TimeDisplay(label: (controller.solveItem?.getTimeCapture()?.getAsReadable())!)
                            }
                            HStack {
                                LabelDisplay(label: "Avg. Comparison")
                                Spacer()
                                TimeDisplay(label: controller.compareAvg.getAsReadable())
                            }
                            HStack {
                                LabelDisplay(label: "Med. Comparison")
                                Spacer()
                                TimeDisplay(label: controller.compareMed.getAsReadable())
                            }
                            HStack {
                                LabelDisplay(label: "Best Comparison")
                                Spacer()
                                TimeDisplay(label: controller.compareBest.getAsReadable())
                            }
                            HStack {
                                LabelDisplay(label: "Worst Comparison")
                                Spacer()
                                TimeDisplay(label: controller.compareWorst.getInSolidForm())
                            }
                        }
                        .frame(width: 300, alignment: .topLeading)
                        // .font(Font.custom(("Chivo-Regular"), size: 11))
                        //.font(Font.custom(("Chivo-Regular"), size: 11))
                        
                        
                            
                        
                       
                            
                    }
                    
                    
                }
            }
            .padding(.top, 30)
            .padding(.bottom, 80)
            .frame(width: 360)
                
        }
    }
}

struct TimeDisplay: View {
    
    var label: String
    
    var body: some View {
        
        ZStack {
            Color.init("mint_cream")
                .opacity(0.8)
            
            Text(label)
                .font(Font.custom(("Chivo-Regular"), size: 11))
                .foregroundColor(Color.init("black_chocolate"))
        }
        .frame(width: 65, height: 24)
    }
    
}

struct LabelDisplay: View {
    
    var label: String
    
    var body: some View {
        
        Text(label)
            .font(Font.custom(("Play-Bold"), size: 13))
    
    }
    
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}

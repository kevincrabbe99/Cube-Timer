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
                        
                        Text(controller.readableDate ?? "Deleted Solve ERROR @903k")
                            .font(Font.custom("Play-Bold", size: 14))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        controller.toggleIsFavorite()
                    }, label: {
                        IconButton(icon: (controller.isFavorite ? Image.init(systemName:"star.fill") : Image.init(systemName:"star")), bgColor: .init("mint_cream"), iconColor: (controller.isFavorite ? Color.init("yellow") : Color.init("black_chocolate")), width: 24, height: 24)
                            .padding(20)
                    })
                    .padding(.trailing, 10)
                    .frame(width: 30, height: 30, alignment: .center)
                    
                    
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
                            
                            
                            HStack(alignment: .center) {
                                
                                
                                if !controller.solveItem.cubeType.isCustom() { // not editing or not as sidebar
                                    CubeIcon(Int(controller.solveItem.cubeType.d1),Int(controller.solveItem.cubeType.d2),Int(controller.solveItem.cubeType.d3), width: 20)
                                        .opacity(0.8)
                                        .offset(y: 3)
                                } else {
                                    IconButton(icon: Image(systemName: "app.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 20, height: 20)
                                    //Image(systemName: "app")
                                    //    .frame(width: 15, height: 15)
                                }
                                
                                VStack(alignment:.leading) {
                                    
                                    
                                    Text(controller.solveItem.cubeType.name)
                                        .font(Font.custom("Play-Bold", size: 22))
                                        .tracking(controller.solveItem.cubeType.isCustom() ? 0 : 5)
                                        .lineLimit(1)
                                    Text(controller.solveItem.cubeType.descrip)
                                        .font(Font.custom("Play-Regular", size: 10))
                                        .lineLimit(1)
                                        .opacity(0.75)
                                }
                                .frame(alignment: .center)
                                .offset(x: 10)
                                
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("Recorded Time")
                                        .font(Font.custom(("Play-Bold"), size: 10))
                                        .offset(y: 6)
                                    
                                    ZStack {
                                        Color.init("mint_cream")
                                            .opacity(0.8)
                                            .cornerRadius(3)
                                        
                                        Text((controller.solveItem?.getTimeCapture()?.getAsReadable())!)
                                            .font(Font.custom(("Chivo-Bold"), size: 11))
                                            .foregroundColor(Color.init("black_chocolate"))
                                    }
                                    .frame(width: 55, height: 24)
                                    
                                }
                                .frame(alignment: .trailing)
                                
                            }
                            .padding(.top, 10)
                            
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    LabelDisplay(label: "Compared to .Avg.")
                                    TimeDisplay(label: controller.compareAvg)
                                }
                                .frame(alignment: .leading)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    LabelDisplay(label: "Compared to Med.")
                                    TimeDisplay(label: controller.compareMed)
                                }
                                .frame(alignment: .trailing)
                                
                                
                            }
                            
                            
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    LabelDisplay(label: "Compared to Best")
                                    TimeDisplay(label: controller.compareBest)
                                }
                                .frame(alignment: .leading)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    LabelDisplay(label: "Compared to Worst")
                                    TimeDisplay(label: controller.compareWorst)
                                }
                                .frame(alignment: .trailing)
                                
                                
                            }
                            
                            HStack {
                                
                                VStack(alignment: .leading) {
                                    LabelDisplay(label: "Percentile")
                                    TimeDisplay(label: controller.percentile)
                                }
                                .frame(alignment: .leading)
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    LabelDisplay(label: "z-score")
                                    TimeDisplay(label: controller.zScore)
                                }
                                .frame(alignment: .trailing)
                            }
                            
                        }
                        .frame(width: 290, alignment: .leading)
                        .offset(y: -15)
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
                .cornerRadius(3)
            
            Text(label)
                .font(Font.custom(("Chivo-Regular"), size: 11))
                .foregroundColor(Color.init("black_chocolate"))
        }
        .frame(width: 55, height: 24)
    }
    
}

struct LabelDisplay: View {
    
    var label: String
    
    var body: some View {
        
        Text(label)
            .font(Font.custom(("Play-Bold"), size: 10))
            .offset(y: 6)
            .opacity(0.8)
    
    }
    
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView()
    }
}

//
//  DetailsView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/14/21.
//

import SwiftUI
import Firebase

struct DetailsView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var controller: DetailsViewController
    @EnvironmentObject var alertController: AlertController
    @EnvironmentObject var settingsController: SettingsController
    
    var body: some View {
        ZStack {
            
            if controller.solveItem.managedObjectContext != nil {
                    
                VStack {
                    HStack {
                        if controller.hasSolveItem {
                            
                            Text(controller.getReadableDate() ?? "Deleted Solve ERROR @903k")
                                .font(Font.custom("Play-Bold", size: 13))
                            
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.shareDetails()
                        }, label: {
                            ZStack {
                            IconButton(icon: Image.init(systemName:"square.and.arrow.up"), bgColor: Color.init("mint_cream"), iconColor: Color.init("very_dark_black"), width: 24, height: 24, iconWidth: 9, iconHeight: 11)
                                .padding(.trailing, 20)
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                        })
                        
                        
                        Button(action: {
                            controller.toggleIsFavorite()
                        }, label: {
                            ZStack {
                            IconButton(icon: (controller.isFavorite ? Image.init(systemName:"star.fill") : Image.init(systemName:"star")), bgColor: .init("mint_cream"), iconColor: (controller.isFavorite ? Color.init("yellow") : Color.init("very_dark_black")), width: 24, height: 24)
                                .padding(.trailing, 20)
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                        })
                        
                        
                        if controller.solveItem!.hasVideo {
                            Button(action: {
                                cvc.closeDetails()
                                cvc.openVideo(solveItem: controller.solveItem!)
                            }, label: {
                                ZStack {
                                IconButton(icon: Image.init(systemName: "play.rectangle.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24, iconWidth: 12, iconHeight: 9)
                                    .padding(.trailing, 20)
                                }
                                .frame(width: 30, height: 30, alignment: .center)
                            })
                        }
                        
                        Button(action: {
                            cvc.tappedDeleteSingleSolve(itemToDelete: controller.solveItem)
                        }, label: {
                            ZStack {
                            IconButton(icon: Image.init(systemName: "trash.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24)
                                .padding(.trailing, 20)
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                        })
                        
                        Button(action: {
                            cvc.closeDetails()
                        }, label: {
                            ZStack {
                                IconButton(icon: Image.init(systemName: "xmark"), bgColor: Color.init("red"), iconColor: Color.init("mint_cream"), width: 24, height: 24)
                            }
                            .frame(width: 30, height: 30, alignment: .center)
                        })
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
                                        LabelDisplay(label: "Compared to Avg.")
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
                                        TimeDisplay(label: controller.getPercentile)
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
                .foregroundColor(Color.init("mint_cream"))
              
            }  // end if
            
        }
    }
    
    
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    
    public func shareDetails() {
        lightTap.impactOccurred()
        // create view
        let capView = DetailsViewCapture()
            .environmentObject(cvc)
            .environmentObject(controller)
            .environmentObject(settingsController)
        
        let capImage = capView.snapshot()
        
        let shareText = "Checkout this \(String((controller.solveItem.getTimeCapture()?.getAsText())!)) solve I recorded using StatTimer - Timer Tracker! #StatTimerApp https://apple.co/2Q9a3Hb"
        
        Analytics.logEvent(AnalyticsEventShare, parameters: [
            "group": controller.solveItem.cubeType.name as NSObject,
            "group_description": controller.solveItem.cubeType.descrip as NSObject,
            "seconds": controller.solveItem.timeMS as NSObject,
            "z_score": controller.zScore as NSObject
        ])
        
        let vc = UIActivityViewController(activityItems: [capImage, shareText], applicationActivities: [])
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
    }
    
    
}

struct TimeDisplay: View {
    
    var label: String
    
    var body: some View {
        
        ZStack {
            Color.init("mint_cream")
                .opacity(0.8)
                .cornerRadius(3)
            
            Text( LocalizedStringKey(label) )
                .font(Font.custom(("Chivo-Regular"), size: 11))
                .foregroundColor(Color.init("black_chocolate"))
        }
        .frame(width: 55, height: 24)
    }
    
}

struct LabelDisplay: View {
    
    var label: String
    
    var body: some View {
        
        Text( LocalizedStringKey(label) )
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

//
//  DetailsViewCapture.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/17/21.
//

import SwiftUI

struct DetailsViewCapture: View {
  
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var controller: DetailsViewController
    @EnvironmentObject var settingsController: SettingsController
    
    
    var body: some View {
        ZStack {
            Color.init("very_dark_black")
            
            VStack(alignment: .center, spacing: 4) {
                Image(uiImage: UIImage.appIcon!)
                    .cornerRadius(10)
                
                Text("StatTimer")
                    .font(Font.custom("Play-Bold", size: 8))
                    .opacity(0.7)
            }
            .opacity(0.3)
            .scaleEffect(0.8)
            
            if controller.solveItem.managedObjectContext != nil {
                    
                VStack {
                    HStack {
                        if controller.hasSolveItem {
                            
                            Text(LocalizedStringKey(controller.getReadableDate() ?? "Deleted Solve ERROR @903k"))
                                .font(Font.custom("Play-Bold", size: 14))
                                .opacity(0.7)
                            
                        }
                        
                        Spacer()
                        
                        
                        Image(systemName: controller.isFavorite ? "star.fill" : "star")
                            .resizable()
                            .foregroundColor(controller.isFavorite ? Color.init("yellow") : Color.init("mint_cream"))
                            .frame(width: 15, height: 15)
                            .padding(.trailing, 20)
                        
                        if controller.solveItem.hasVideo {
                            Image.init(systemName: "film")
                                .resizable()
                                .foregroundColor(Color.init("mint_cream"))
                                .frame(width: 15, height: 13)
                        }
             
                    }
                    .frame(width: 290)
                    
                    ZStack {
                        
                        
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
                                        Text(LocalizedStringKey("Recorded Time"))
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
                .padding(.top, 10)
                .padding(.bottom, 10)
                .frame(width: 320)
                .foregroundColor(Color.init("mint_cream"))
              
            }  // end if
            
        }
        .environment(\.locale, .init(identifier: settingsController.getDefaultLanguage))
    }
    
}

struct DetailsViewCapture_Previews: PreviewProvider {
    static var previews: some View {
        DetailsViewCapture()
    }
}


extension UIImage {
    static var appIcon: UIImage? {
        guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String:Any],
              let primaryIconsDictionary = iconsDictionary["CFBundlePrimaryIcon"] as? [String:Any],
              let iconFiles = primaryIconsDictionary["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else { return nil }
        return UIImage(named: lastIcon)
    }
}

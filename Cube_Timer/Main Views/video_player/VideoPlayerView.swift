//
//  VideoPlayerView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/13/21.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    @EnvironmentObject var cvc: ContentViewController
    
    // controller
    @EnvironmentObject var controller: VideoPlayerController
    
    var body: some View {
        
        ZStack {
           
                
            VStack {
                HStack {
                    
                    // dont show if SolveItem is not present
                    if controller.hasSolveItem {
                        
                        Text(controller.readableDate)
                            .font(Font.custom("Play-Bold", size: 14))
                        
                        ZStack {
                            Color.init("green")
                                .cornerRadius(3)
                                .opacity(0.8)
                            Text((controller.solveItem?.getTimeCapture()?.getAsReadable())!)
                                .font(Font.custom("Play-Bold", size: 13))
                        }
                        .frame(width: 65, height: 24)
                        .padding(.leading, 10)
                        
                    }
                        
                    Spacer()
                    
                    
                    Button(action: {
                        controller.toggleIsFavorite()
                    }, label: {
                        IconButton(icon: (controller.isFavorite ? Image.init(systemName:"star.fill") : Image.init(systemName:"star")), bgColor: .init("mint_cream"), iconColor: (controller.isFavorite ? Color.init("yellow") : Color.init("very_dark_black")), width: 24, height: 24)
                            .padding(20)
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                    
                    
                    Button(action: {
                        controller.deleteVideo() // UPDATE THIS to route to cvc
                    }, label: {
                        IconButton(icon: Image.init(systemName: "trash.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24)
                            .padding(20)
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                    
                    Button(action: {
                        controller.saveVideoToPhotos()
                    }, label: {
                        IconButton(icon: Image.init(systemName: "square.and.arrow.down.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24, iconWidth: 10, iconHeight: 11)
                            .padding(20)
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                    
                    Button(action: {
                        cvc.openDetails(solveItem: controller.solveItem!)
                    }, label: {
                        IconButton(icon: Image.init(systemName: "info"), bgColor: Color.init("mint_cream"), iconColor: Color.init("very_dark_black"), width: 24, height: 24, iconWidth: 8, iconHeight: 11)
                            .padding(30)
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                    .padding(.trailing, 20)
                    
                    Button(action: {
                        cvc.closeVideo()
                    }, label: {
                        IconButton(icon: Image.init(systemName: "xmark"), bgColor: Color.init("red"), iconColor: Color.init("mint_cream"), width: 24, height: 24)
                            .padding(20)
                    })
                    .frame(width: 30, height: 30, alignment: .center)
                    
                }
                .frame(height: 35)
                
                ZStack {
                    
                    Color.init("very_dark_black")
                        .cornerRadius(5)
                        .opacity(0.8)
                    
                    VideoPlayer(player: self.controller.player)
                        .onAppear() {
                            self.controller.player!.play()
                        }
                        .padding(.all, 5)
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 25)
            .padding(.leading, 70)
            .padding(.trailing, 70)
                
        }
        
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView()
    }
}

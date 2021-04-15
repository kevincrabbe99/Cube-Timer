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
                    
                    
                    IconButton(icon: Image.init(systemName: "star"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24)
                        .padding(.trailing, 10)
                    
                    IconButton(icon: Image.init(systemName: "trash.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24)
                        .padding(.trailing, 10)
                        .onTapGesture {
                            controller.deleteVideo() // UPDATE THIS to route to cvc
                        }
                    
                    IconButton(icon: Image.init(systemName: "square.and.arrow.down.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"), width: 24, height: 24, iconWidth: 10, iconHeight: 11)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            controller.saveVideoToPhotos()
                        }
                
                    IconButton(icon: Image.init(systemName: "info"), bgColor: Color.init("mint_cream"), iconColor: Color.init("very_dark_black"), width: 24, height: 24, iconWidth: 8, iconHeight: 11)
                        .padding(.trailing, 20)
                        .onTapGesture {
                            cvc.openDetails(solveItem: controller.solveItem!)
                        }
                    
                    IconButton(icon: Image.init(systemName: "xmark"), bgColor: Color.init("red"), iconColor: Color.init("mint_cream"), width: 24, height: 24)
                        .onTapGesture {
                            cvc.closeVideo()
                        }
                }
                
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

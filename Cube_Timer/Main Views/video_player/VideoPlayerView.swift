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
            
            Color.black
                .opacity(0.9)
            
            VStack {
                HStack {
                    Text("Apr 14, 2020 at 1:29am")
                        .font(Font.custom("Play-Bold", size: 14))
                    
                    ZStack {
                        Color.init("green")
                            .cornerRadius(3)
                            .opacity(0.8)
                        Text("55 seconds")
                            .font(Font.custom("Play-Bold", size: 13))
                    }
                    .frame(width: 90, height: 20)
                    .padding(.leading, 10)
                    
                    Spacer()
                    
                    
                    IconButton(icon: Image.init(systemName: "trash.fill"), bgColor: .init("mint_cream"), iconColor: .init("very_dark_black"))
                        .padding(.trailing, 10)
                
                    IconButton(icon: Image.init(systemName: "xmark"), bgColor: Color.init("red"), iconColor: Color.init("mint_cream"))
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

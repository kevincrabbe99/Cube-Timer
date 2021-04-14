//
//  VideoPlayerView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/13/21.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    private let player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
        print("initiated video player w url: ", url)
    }
    
    var body: some View {
        
        ZStack {
            
            Color.black
                .opacity(0.8)
            
            ZStack {
                VideoPlayer(player: self.player)
                    .onAppear() {
                        player.play()
                    }
            }
            
        }
        
    }
}

struct VideoPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerView(url: URL(fileURLWithPath: "fake_url"))
    }
}

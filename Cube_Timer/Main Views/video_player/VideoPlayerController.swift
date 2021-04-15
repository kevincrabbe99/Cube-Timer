//
//  VideoPlayerController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/14/21.
//

import Foundation
import SwiftUI
import AVKit

/*
 * Handles the current data being showin in the Video Player
 *  ie. url / SolveItem (with videoURL)
 */
class VideoPlayerController: ObservableObject {
    
    var cvc: ContentViewController!
    var solveHandler: SolveHandler!
    
    var player: AVPlayer?
    
    init() {
        self.player = nil
        print("initiated video player w url: NIL")
    }
    
    public func goto(url: URL) {
        self.player = AVPlayer(url: url)
        print("playback: playing url: ", url)
    }
    
    public func goto(name: String) {
        let url = DocumentDirectory.getVideosDirectory().appendingPathComponent(name)
        print("playback: VideoPlayerController().goto(name) | Attempting to play constructed url: ", url)
        self.goto(url: url)
    }
    
    
}


class DocumentDirectory {
    public static func getVideosDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        /*FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first*/
    }
}

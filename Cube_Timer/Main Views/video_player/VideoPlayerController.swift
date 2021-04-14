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
    }
    
    
}

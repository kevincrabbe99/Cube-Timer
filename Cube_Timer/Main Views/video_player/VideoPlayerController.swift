//
//  VideoPlayerController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/14/21.
//

import Foundation
import SwiftUI
import AVKit
import Photos

/*
 * Handles the current data being showin in the Video Player
 *  ie. url / SolveItem (with videoURL)
 */
class VideoPlayerController: ObservableObject {
    
    var cvc: ContentViewController!
    var solveHandler: SolveHandler!
    var alertController: AlertController!
    
    var player: AVPlayer?
    var solveItem: SolveItem?
    
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
    
    public func goto(solveItem: SolveItem) {
        let url = DocumentDirectory.getVideosDirectory().appendingPathComponent(solveItem.videoName!)
        self.solveItem = solveItem
        
        self.goto(url: url)
    }
    
    public var hasSolveItem: Bool {
        if solveItem == nil {
            return false
        } else {
            return true
        }
    }
    
    var readableDate: String {
        
        if solveItem == nil {
            return "Error #9w948"
        }
        
        let df = DateFormatter()
        df.dateFormat = "MMM dd, yyyy hh:mm:ss"
        return  df.string(from: solveItem!.timestamp)
    }
    
    
    /*
     * called by VideoPlayer ontap()
     */
    public func saveVideoToPhotos() {
        
        if solveItem == nil { return }
        
        if !solveItem!.hasVideo {
            
            self.alertController.makeAlert(icon: Image.init(systemName: "xmark.octagon.fill"), title: "Video Cannot be Saved", text: "Error saving video #3f802", duration: 3, iconColor: Color.init("yellow"))
            
            return }
        
        self.alertController.makeAlert(icon: Image.init(systemName: "film"), title: "Video Saved!", text: "Successfully saved video to camera roll!", duration: 3, iconColor: Color.init("black_chocolate"))
        
        solveItem!.saveVideoToPhotos()
        
        //print("Exported blurred video to camera roll: ", videoPathURL)
        
        /*
         * Save to photos
         */
        
            
    }
    
    /*
     *  calls solveHandler to delete video for a solve
     */
    public func deleteVideo() {
        cvc.tappedDeleteSingleVideoFor(solveItem: solveItem!)
        //solveHandler.deleteVideoFor(solveItem: solveItem!)
    }
    
}


class DocumentDirectory {
    public static func getVideosDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        /*FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first*/
    }
}

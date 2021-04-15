//
//  CameraViewController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 3/30/21.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI
import Photos

final class CameraViewController: UIViewController {
    
    var cameraController: CameraController!
    var previewView: UIView!
    
    var delegate: CameraControllerDelegate!
  
    
    override func viewDidLoad() {
        
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
            previewView.contentMode = UIView.ContentMode.scaleAspectFit
            view.addSubview(previewView)
            
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.previewView)
            }
        
    }
    
    /*
     * called after init,
     *  gives refs to the delegate
     */
    override func viewDidAppear(_ animated: Bool) {
        cameraController.delegate = delegate
        delegate.setControllerRef(cameraController) // sets the camera controller for the delegate
    }
    
    /*
     *  Routes recording command to -> cameraController
     *      called by: extension
    public func record() {
        cameraController.startRecording()
    }
     */
    
    
}




struct CameraView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = CameraViewController
 
    var cameraController: CameraController!
    var cvc: ContentViewController!
    
    //@Environment(\.presentationMode) var presentationMode
 
     class Coordinator: NSObject, UINavigationControllerDelegate, CameraControllerDelegate {
         
         var cameraController: CameraController?
         var parent: CameraView
         
         required init(_ p: CameraView) {
             self.cameraController = nil
             self.parent = p
         }
         
         func setControllerRef(_ ref: CameraController) {
             self.cameraController = ref
             print("set reference to camera controller in CameraView")
         }
         
         /*
          *  Camera FUNCTIONS ROUTER
          */
        func recordingStopped(saved: Bool) {
            print("stop recording, saved = ", saved)
        }
         
        func recordingStarted() {
            print("start recording")
        }
        
        func recordingSaved(url: URL) {
            print("camera vc: recording saved to: ", url)
            
            /*
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
            }) { saved, error in
                if saved {
                    /*
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    */
                    print("SAVED VIDEO TO CAMERA ROLL")
                }else {
                    print("ERROR SAVING VIDEO TO CAMERA ROLL: ", error)
                }
            }
            */
            
            /*
             * check if path exists before offering to open
             */
            //if FileManager.default.fileExists(atPath: url.absoluteString) {
                //parent.cvc.openVideo(url: url)
            //}
            
            
        }
         
         func cameraWorking() {
             print("camera working")
         }
         
         func cameraNowWorking(error: CameraControllerError) {
             print("error recording: ", error.localizedDescription)
         }
         
     }
     
     func makeCoordinator() -> Coordinator {
         Coordinator(self)
     }
     
     func makeUIViewController(context: Context) -> CameraViewController {
        let vc = CameraViewController()
        vc.delegate = context.coordinator
        vc.cameraController = cameraController
        return vc
     }
     
     func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
          //uiViewController.record()
     }
}
 





/*
extension CameraViewController : UIViewControllerRepresentable{
   typealias UIViewControllerType = CameraViewController
   
   
   //@Environment(\.presentationMode) var presentationMode
   
   class Coordinator: NSObject, UINavigationControllerDelegate, CameraControllerDelegate {
       
       var cameraController: CameraController?
       var parent: CameraViewController
       
       required init(_ p: CameraViewController) {
           self.cameraController = nil
           self.parent = p
       }
       
       func setControllerRef(_ ref: CameraController) {
           self.cameraController = ref
           print("set reference to camera controller in CameraView")
       }
       
       /*
        *  Camera FUNCTIONS ROUTER
        */
       func startRecord() {
           print("start recording")
       }
       
       func stopRecord() {
           print("stop recording")
       }
       
       func cameraWorking() {
           print("camera working")
       }
       
       func cameraNowWorking(error: CameraControllerError) {
           print("error recording: ", error.localizedDescription)
       }
       
       
       
   }
   
   func makeCoordinator() -> Coordinator {
       Coordinator(self)
   }
   
   func makeUIViewController(context: Context) -> CameraViewController {
       let vc = CameraViewController()
       vc.delegate = context.coordinator
       return vc
   }
   
   func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        uiViewController.record()
   }
}
 
 */

 

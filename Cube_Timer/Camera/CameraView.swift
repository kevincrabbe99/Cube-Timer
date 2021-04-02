//
//  CameraView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/2/21.
//

import Foundation
import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @Binding var image: UIImage?
    
    var body: some View {
        
        ZStack {
            CameraRepresentable(image: self.$image)
            
        }
        
    }
    
}

struct CameraRepresentable: UIViewControllerRepresentable {
   
    
    
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = CameraController()
        controller.delegate = context.coordinator
        return controller
    }
 
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
        
    class Coordinator: NSObject, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
        let parent: CameraRepresentable
        
        init(_ parent: CameraRepresentable) {
            self.parent = parent
        }
        
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            
            //parent.didTapCapture = false
            
            if let imageData = photo.fileDataRepresentation() {
                parent.image = UIImage(data: imageData)
            }
          //  parent.presentationMode.wrappedValue.dismiss()
        }
        
        func videoOutput(_ output: AVCaptureMovieFileOutput) {
            
        }
        
    }
    
}

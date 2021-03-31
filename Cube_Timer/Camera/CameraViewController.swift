//
//  CameraViewController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 3/30/21.
//

import Foundation
import UIKit
import SwiftUI

final class CameraViewController: UIViewController {
    
    let cameraController = CameraController()
    var previewView: UIView!
 
    override func viewDidLoad() {
        
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFill
            view.addSubview(previewView)
            
            cameraController.prepare {(error) in
                if let error = error {
                    print(error)
                }
                
                try? self.cameraController.displayPreview(on: self.previewView)
            }
        
    }
    
}


/*
 *  Make compatable with SwiftUI
 */
extension CameraViewController : UIViewControllerRepresentable{
    public typealias UIViewControllerType = CameraViewController
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
        return CameraViewController()
    }
    
    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
    }
}

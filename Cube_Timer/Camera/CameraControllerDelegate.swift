//
//  CameraControllerDelegate.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 4/13/21.
//

import Foundation


protocol CameraControllerDelegate {
    
    var parent: CameraView { get set }
    var cameraController: CameraController? {get set}
    
    init(_ p: CameraView)
    
    func setControllerRef(_ ref: CameraController)
    
    
    func startRecord()
    func stopRecord()
    func recordingSaved(url: URL)
    func cameraWorking()
    func cameraNowWorking(error: CameraControllerError)
}

enum CameraControllerError: Swift.Error {
    case captureSessionAlreadyRunning
    case captureSessionIsMissing
    case inputsAreInvalid
    case invalidOperation
    case noCamerasAvailable
    case noMicFound
    case unknown
}


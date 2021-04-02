//
//  CameraController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 3/30/21.
//

import AVFoundation
import Foundation
import UIKit

class CameraController: NSObject, ObservableObject {
    
    // @Environment vars
    var solveHandler: SolveHandler!
    
    // camera vars
    var captureSession: AVCaptureSession?
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var backCameraInput: AVCaptureDeviceInput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    
    enum CameraControllerError: Swift.Error {
        case captureSessionAlreadyRunning
        case captureSessionIsMissing
        case inputsAreInvalid
        case invalidOperation
        case noCamerasAvailable
        case unknown
    }
    
    // state vars
    @Published var videoState: CameraMode = CameraMode.disabled
    
    enum CameraMode {
        case disabled
        case standby
        case recording
    }
    
    @Published var cameraInputState = CameraInput.frontCamera
    enum CameraInput {
        case frontCamera
        case backCamera
    }
    
    @Published var microphoneState = MicrophoneStates.enabled
    enum MicrophoneStates {
        case enabled
        case muted
    }
    
    
    public func toggleMicrophoneEnabled() {
        
        if microphoneState == .enabled {
            microphoneState = .muted
        } else {
            microphoneState = .enabled
        }
        
    }
    
    public func toggleCameraInput() {
        
        if cameraInputState == .frontCamera {
            cameraInputState = .backCamera
            
            do {
                try self.setCameraBack()
            } catch {
                print("Error setting camera input")
            }
            
            
            
            
            
            
        } else {
            cameraInputState = .frontCamera
        }
        
    }
    
    
    public func toggleVideoState() {
        
        print("toggling video state from : ", videoState)
        
        if videoState == .disabled { // video is disabled, -> enable
            videoState = .standby
        } else { // video is enabled, -> disable
            videoState = .disabled
        }
        
    }
    
    public func startRecording() {
        
        videoState = .recording
        
    }
    
    public func stopRecording() {
        
        videoState = .standby
        
    }
    
    public var isRecording: Bool {
        if videoState == .recording {
            return true
        }
        
        return false
    }
    
    
    
/*
 *  general CAMREA METHODS
 */
    
    private func setCameraBack() throws {
        
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        captureSession.beginConfiguration()
        let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        captureSession.removeInput(currentInput!)
        
        let newCameraDevice = getCamera(with: .back)
        let newViewInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        captureSession.addInput(newViewInput!)
        captureSession.commitConfiguration()
           
    }
    
    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else {
            return nil
        }
        
        return devices.filter {
            $0.position == position}.first
    }
    
    func displayPreview(on view: UIView) throws {
        guard let captureSession = self.captureSession, captureSession.isRunning else { throw CameraControllerError.captureSessionIsMissing }
            
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = .landscapeLeft
        
        view.layer.insertSublayer(self.previewLayer!, at: 0)
        self.previewLayer?.frame = view.frame
    }
    
    
    func prepare(completionHandler: @escaping (Error?) -> Void){
        func createCaptureSession(){
            self.captureSession = AVCaptureSession()
        }
        /*
         *  sets the camera to face the front
         */
        func configureCaptureDevices() throws {
            
            // set front camera
            let fCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front)
            self.frontCamera = fCamera
            
            // set back camera
            let bCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back)
            self.backCamera = bCamera;
            
            try fCamera?.lockForConfiguration()
            frontCamera?.unlockForConfiguration()
            
            try bCamera?.lockForConfiguration()
            bCamera?.unlockForConfiguration()
                
        }
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
               
            if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                   
                if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!)}
                else { throw CameraControllerError.inputsAreInvalid }
                   
            }
            else { throw CameraControllerError.noCamerasAvailable }
               
            captureSession.startRunning()
               
        }
           
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
            }
                
            catch {
                DispatchQueue.main.async{
                    completionHandler(error)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(nil)
            }
        }
    }
}

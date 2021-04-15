//
//  CameraController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 3/30/21.
//

import AVFoundation
import Foundation
import UIKit

enum CameraMode {
    case disabled
    case standby
    case recording
}

class CameraController: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // @Environment vars
    var solveHandler: SolveHandler!
    
    // camera vars
    var captureSession: AVCaptureSession?
    var movieOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    var captureConnection: AVCaptureConnection?
    
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    
    var frontCameraInput: AVCaptureDeviceInput?
    var backCameraInput: AVCaptureDeviceInput?
    
    var microphone: AVCaptureDevice?
    var microphoneInput: AVCaptureDeviceInput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    
    var delegate: CameraControllerDelegate!
    
    
    
    // state vars
    @Published var videoState: CameraMode = CameraMode.disabled
    
    
    
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
    
    
    public func turnOffCamera() {
        captureSession?.stopRunning()
    }
    
    public func turnOnCamera() {
        captureSession?.startRunning()
    }
    
    
    /*
     * Toggles whether camera is showing
     */
    public func toggleVideoState() {
        
        print("toggling video state from : ", videoState)
        
        if videoState == .disabled { // video is disabled, -> enable
            videoState = .standby
        } else { // video is enabled, -> disable
            videoState = .disabled
            
            // stp[ camera
            captureSession?.stopRunning()
        }
        
    }
    
    
    
    
    /*
     *  Toggles either back or front camera
     */
    public func toggleCameraInput() {
        
        if cameraInputState == .frontCamera {
            cameraInputState = .backCamera
            
            do {
                try self.setCamera(pos: .back)
            } catch {
                print("Error setting camera input")
            }
    
        } else {
            cameraInputState = .frontCamera
            
            do {
                try self.setCamera(pos: .front)
            } catch {
                print("Error flipping camera to front")
            }
            
        }
        
        print("toggled cameras")
        
    }
    
    /*
     *  toggle microphone by remving and adding from inputs
     */
    public func toggleMicrophoneEnabled() {
        
        
        if microphoneState == .enabled {
            microphoneState = .muted
        } else {
            microphoneState = .enabled
        }
        
        do {
            try setMicrophone(microphoneState)
        } catch {
            self.handleError(e: CameraControllerError.captureSessionIsMissing)
        }
        
        
        print("toggled microphone")
        
    }
    
    
    
    
    
    
    
    public var isRecording: Bool {
        if videoState == .recording {
            return true
        }
        
        return false
    }
    
    
    
    

    
    
    
    /*
     * record stuff
     */
    public func startRecording() throws  -> URL {
        
        //guard let connection = self.movieOutput.connection(with: .video) else { throw CameraControllerError.inputsAreInvalid }
        
        /*
         * check if already reacording so add 2 inputs
        if movieOutput != nil {
            if movieOutput!.isRecording {
                
                self.stopRecording(save: false)
                
                throw CameraControllerError.inputsAreInvalid
            }
        }
         */
        
        print("start recording from CameraController")
        videoState = .recording
        
        // define URL
        //let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let documentsPath = DocumentDirectory.getVideosDirectory() 
        
        // define date string
        let date = Date()
        let dFormatter = DateFormatter()
        dFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
        dFormatter.timeZone = NSTimeZone.local
        let dateString = dFormatter.string(from: date)
        
        // define output url
        let outputURL =  documentsPath.appendingPathComponent("\(dateString).mov")
        
        // set lastURL ref to be used by the TimerController to link this video and the current solve
        self.lastURL = outputURL
        
        // remove item incase it already exists
        try? FileManager.default.removeItem(at: outputURL)
        
        print("recording to URL: ", outputURL)
        
        
        
        /*
         self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
         self.previewLayer?.connection?.videoOrientation = .landscapeLeft
         */
        self.movieOutput.connection(with: .video)?.videoOrientation = .landscapeLeft
        
        //self.captureConnection = AVCaptureConnection(inputPorts: csInputPorts, output: movieOutput!)
        //captureSession?.addConnection(captureConnection!)
        self.movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        
        
        // return saveto url
        return outputURL
        
        delegate.recordingStarted()
        
    }
    
    
   public var lastURL: URL?
    
    /*
     * stop recording, save if timer has started
     */
    public func stopRecording(save: Bool = true) {
        print("video: stop recording")
        
        
        if videoState != .recording { return }
        videoState = .standby
        
        
        self.movieOutput.stopRecording()
        
        // delete video if save = false
        if !save {
            do {
                try FileManager.default.removeItem(at: (self.movieOutput.outputFileURL)!)
                print("deleted video that was just created")
            } catch {
                print("Error deleting video which never got initiated: CameraController().stopRecording()")
            }
        }
        
        
        // call to delegate (just incase)
        delegate.recordingStopped(saved: save)
    
    }
    
    
    


/*
 *  general CAMREA METHODS
 */
        
    
    /*
     *   switches out the camera input
     */
    private func setCamera(pos: AVCaptureDevice.Position) throws {
        
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        captureSession.beginConfiguration()
        //let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput
        if pos == .back {
            captureSession.removeInput(frontCameraInput!)
            captureSession.addInput(backCameraInput!)
        } else {
            captureSession.removeInput(backCameraInput!)
            captureSession.addInput(frontCameraInput!)
        }
            /*
        let newCameraDevice = getCamera(with: pos)
        let newViewInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        captureSession.addInput(newViewInput!)
 */
        captureSession.commitConfiguration()
        
    }
    
    
    
    private func setMicrophone(_ state: MicrophoneStates) throws {
        
        guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
        
        if microphoneState == .muted {
            
            captureSession.beginConfiguration()
            captureSession.removeInput(microphoneInput!)
            captureSession.commitConfiguration()
            
        } else {
            
            captureSession.beginConfiguration()
            if captureSession.canAddInput(microphoneInput!) {
                captureSession.addInput(microphoneInput!)
            } else { throw CameraControllerError.noMicFound }
            captureSession.commitConfiguration()
            
        }
        
    }
        
        
    
    /*
     * returns first video camera
     */
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
    
    
    
    /*
     * The Main Initiation Method
     */
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
            
            
            self.microphone = AVCaptureDevice.default(for: .audio)
            
                
        }
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
               
            // setup camera, init front camera input
            if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                  
                // add front camera input
                if captureSession.canAddInput(self.frontCameraInput!) {
                    captureSession.addInput(self.frontCameraInput!)
                    
                }
                else { throw CameraControllerError.inputsAreInvalid }
                   
            }
            else { throw CameraControllerError.noFrontCameraAvailable }
            
            // setup back camera, dont set as output at first tho
            if let backCamera = self.backCamera {
                self.backCameraInput = try AVCaptureDeviceInput(device: backCamera)
            } else { throw CameraControllerError.noBackCameraAvailable }
            
            // setup microphone
            if let defMic = self.microphone {
                self.microphoneInput = try AVCaptureDeviceInput(device: defMic)
                
                // add microphone input
                if captureSession.canAddInput(self.microphoneInput!) {
                    captureSession.addInput(self.microphoneInput!)
                }
                else { throw CameraControllerError.noMicFound }
            }
            
            
            
        }
        func configureOutputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
            
            // define new MovieOut Instance
            self.movieOutput = AVCaptureMovieFileOutput()
            // remove all outputs from captureSession
            for output in captureSession.outputs {
                captureSession.removeOutput(output)
            }
            // add new movieOutputInstance
            if captureSession.canAddOutput(movieOutput) {
                captureSession.addOutput(movieOutput)
            }

            
            //captureSession.addOutput(self.movieOutput)
            //captureSession.commitConfiguration()
            captureSession.startRunning()
            
        }
           
        DispatchQueue(label: "prepare").async {
            do {
                createCaptureSession()
                try configureCaptureDevices()
                try configureDeviceInputs()
                try configureOutputs()
                
                self.delegate.cameraWorking()
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
    
    
    
    
    
    
    /*
     * ERROR ROUTER
     */
    private func handleError(e: CameraControllerError) {
        print("error: ", e.localizedDescription)
    }
    
}



extension CameraController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        print("AVCAPTURE DELEGATE: recording saved! url: ", outputFileURL.absoluteURL)
        delegate.recordingSaved(url: outputFileURL)
        
    }
    
    
}

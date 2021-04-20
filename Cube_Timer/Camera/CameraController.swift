//
//  CameraController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 3/30/21.
//

import AVFoundation
import Foundation
import UIKit
import SwiftUI

enum CameraMode {
    case disabled
    case standby
    case recording
}

class CameraController: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // @Environment vars
    var solveHandler: SolveHandler!
    var cvc: ContentViewController!
    var alertController: AlertController!
    
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
    
    
    @Published public var recordingText: String = "Recording..."
    
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    let hapticGenerator = UINotificationFeedbackGenerator()
    
    
    var micPermissionsGranted = false
    var videoPermissionsGranted = false
    
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
        
        if captureSession == nil { return }
        
        captureSession?.commitConfiguration()
        
        captureSession?.stopRunning()
        
    }
    
    public func turnOnCamera() {
        if captureSession == nil { return }
        
        captureSession?.commitConfiguration()
        captureSession?.startRunning()
    }
    
    
    
    /*
     * Toggles whether camera is showing
     */
    public func toggleVideoState() {
        
        print("toggling video state from : ", videoState)
        
        // check for permissions
        self.checkPermissions()
        // apply permissions
        if !self.videoPermissionsGranted {
            self.videoPermissionsAlert()
            hapticGenerator.notificationOccurred(.error)
            return
        }
        
        if videoState == .disabled { // video is disabled, -> enable
            hapticGenerator.notificationOccurred(.success)
            self.enableVideoState()
        } else { // video is enabled, -> disable
            hapticGenerator.notificationOccurred(.error)
            videoState = .disabled
            
            // stp[ camera
            captureSession?.stopRunning()
        }
        
    }
    
    private func videoPermissionsAlert() {
        self.alertController.makeAlert(icon: Image.init(systemName: "video.slash.fill"),  title: "Camera permissions not granted", text: "Please enable camera permissions within the device settings in order to use this feature.")
    }
    
    private func audioPermissionsAlert() {
        self.alertController.makeAlert(icon: Image.init(systemName: "mic.slash.fill"),  title: "Microphone permissions not granted", text: "Please enable microphone permissions whithin the device settings in order to use this feature.")
    }
    
    
    public func enableVideoState() {
        
        if !self.videoPermissionsGranted {
            return
        }
        
        hapticGenerator.prepare()
        videoState = .standby
    }
    
    
    
    
    /*
     *  Toggles either back or front camera
     */
    public func toggleCameraInput() {
        
        lightTap.impactOccurred()
        
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
        
        lightTap.impactOccurred()
        
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
        
        // check permissions
        if !self.videoPermissionsGranted {
            throw CameraControllerError.noCamerasAvailable
        }
        
        // check if already recording
        if self.isRecording {
            // stop current recording
            self.stopRecording()
        }
        
        
        
        print("start recording from CameraController")
        videoState = .recording
        recordingText = "Recording..."
        
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
        self.lastVideoName = outputURL.lastPathComponent
        
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
    
    
   public var lastVideoName: String?
    
    /*
     * stop recording, save if timer has started
     */
    public func stopRecording(save: Bool = true) {
        print("video: stop recording")
        
        
        if videoState != .recording { return }
        videoState = .standby
        
        
        self.movieOutput.stopRecording()
        
        // delete video if save = false
        if !save &&
            self.movieOutput.outputFileURL == nil{
            do {
                try FileManager.default.removeItem(at: DocumentDirectory.getVideosDirectory().appendingPathComponent(lastVideoName!))
                print("deleted video that was just created")
            } catch {
                print("Error deleting video which never got initiated: CameraController().stopRecording()")
            }
        }
        
        
        // call to delegate (just incase)
        delegate.recordingStopped(saved: save)
    
    }
    
    
    /*
     * Enterance for TimerController to start countdown for mainview camera buttons and status
     */
    var recordingCountDownTimer: Timer?
    var currentTimerCountdown: Int? = 3 // init to 3 cause fuck it
    public func startRecordingCountdown(from: Int) {
        currentTimerCountdown = from + 1 // idk why but adding 1 here makes everything below work...
        recordingText = ""
        countTimerDown()
        recordingCountDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countTimerDown), userInfo: nil, repeats: true)
        
    }
    
    /*
     *  counds down the timer by 1, called by method above on timer
     */
    @objc func countTimerDown() {
        // if 0 then invalidate and set recordingText back to origional state
        if currentTimerCountdown == 0 {
            recordingCountDownTimer?.invalidate()
            self.recordingText = "Recording..."
        } else {
            DispatchQueue.main.async {
                self.recordingText.append( String("\(self.currentTimerCountdown!)... ") )
            }
        }
        self.currentTimerCountdown! -= 1
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
            if captureSession.canAddInput(backCameraInput!) {
                captureSession.addInput(backCameraInput!)
            }
        } else {
            captureSession.removeInput(backCameraInput!)
            if captureSession.canAddInput(frontCameraInput!) {
                captureSession.addInput(frontCameraInput!)
            }
        }
            /*
        let newCameraDevice = getCamera(with: pos)
        let newViewInput = try? AVCaptureDeviceInput(device: newCameraDevice!)
        captureSession.addInput(newViewInput!)
 */
        captureSession.commitConfiguration()
        
    }
    
    
    
    private func setMicrophone(_ state: MicrophoneStates) throws {
        
    
        guard micPermissionsGranted else {
            self.audioPermissionsAlert()
            
            throw CameraControllerError.noMicFound }
        
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
     *  Checks for permissions before configuring the camera
     */
    func checkPermissions() {
        
        // check for video permissions
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            self.videoPermissionsGranted = true
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    self.videoPermissionsGranted = true
                } else {
                   self.videoPermissionsGranted = false
                }
            })
        }
        
        // check for audio permissions
        if AVCaptureDevice.authorizationStatus(for: .audio) ==  .authorized {
            self.micPermissionsGranted = true
        } else {
            AVCaptureDevice.requestAccess(for: .audio, completionHandler: { (granted: Bool) in
                if granted {
                    self.micPermissionsGranted = true
                } else {
                   self.micPermissionsGranted = false
                }
            })
        }
        
        print("VIDEOPERMS: ", self.videoPermissionsGranted)
        print("MICPERMS: ", self.micPermissionsGranted)
        
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
        
        print("new camera feed")
        
        do {
            try AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
        } catch {
            print(error)
        }
        
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
        
        
        /*
         * sets input and device vars
         *  adds inputs to captureSession
         */
        func configureDeviceInputs() throws {
            guard let captureSession = self.captureSession else { throw CameraControllerError.captureSessionIsMissing }
               
            // setup camera, init front camera input
            if let frontCamera = self.frontCamera {
                self.frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                  
                if self.cameraInputState == .frontCamera {
                    if captureSession.canAddInput(self.frontCameraInput!) {
                        captureSession.addInput(self.frontCameraInput!)
                        
                    }
                    else { throw CameraControllerError.inputsAreInvalid }
                }
                   
            }
            else { throw CameraControllerError.noFrontCameraAvailable }
            
            // setup back camera, dont set as output at first tho
            if let backCamera = self.backCamera {
                self.backCameraInput = try AVCaptureDeviceInput(device: backCamera)
                
                if self.cameraInputState == .backCamera {
                    if captureSession.canAddInput(self.backCameraInput!) {
                        captureSession.addInput(self.backCameraInput!)
                        
                    }
                    else { throw CameraControllerError.inputsAreInvalid }
                }
                
            } else { throw CameraControllerError.noBackCameraAvailable }
            
            // check mic premissions
            if self.micPermissionsGranted {
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
            createCaptureSession()
            self.checkPermissions()
            if self.videoPermissionsGranted {
                do {
                    try configureCaptureDevices()
                    try configureDeviceInputs()
                    try configureOutputs()
                    
                    self.delegate.cameraWorking()
                }  catch {
                    DispatchQueue.main.async{
                        completionHandler(error)
                    }
                    
                    return
                }
            } else {
                // video permissions not granted
                print("VIDEOPERMS not granted")
                self.videoPermissionsAlert()
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

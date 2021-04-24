//
//  ContentViewController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/28/20.
//

import Foundation
import SwiftUI
import Firebase


class ContentViewController: ObservableObject {
    
    var ctEditController: CTEditController!
    var popupController: PopupController!
    var cTypeHandler: CTypeHandler!
    var timer: TimerController!
    var allSolvesController: AllSolvesController!
    var detailsViewController: DetailsViewController!
    
    
    // sidebar positioning
    @Published var sidebar: Bool = false
    var sidebarOutPos: CGPoint {
        if UIDevice.IsIpad {
            return CGPoint(x: -1 * (UIScreen.main.bounds.width/6)+45, y: UIScreen.main.bounds.height/2)
        }else {
            return CGPoint(x: -1 * (UIScreen.main.bounds.width/6)+45, y: UIScreen.main.bounds.height/2)// 45 shows 5px of the sidebar always
        }
    }
    var sidebarInPos: CGPoint {
        if UIDevice.IsIpad {
            return CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.height/2)
        }else {
            return CGPoint(x: (UIDevice.hasNotch ? UIScreen.main.bounds.width/6 : (UIScreen.main.bounds.width/4)-15), y: UIScreen.main.bounds.height/2)
        }
    }
    let sidebarWidth: CGFloat = (UIDevice.hasNotch ? (UIScreen.main.bounds.width / 3) : (UIScreen.main.bounds.width / 2.4))
    @Published var sidebarDraggin: Bool = false
    @Published var sbBgOpacity: Double = 0
    @Published var sbXPos: CGFloat = -1 * (UIScreen.main.bounds.width/6)+45 // initialize it to sidebarOutPos x value
    
    
    // sidebar edit mode
    @Published var sbEditMode: Bool = false
    
    
    // popup stuff
    @Published var popupShowing: Bool = false
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    
    
    
    // page states
    @Published var onPage: Page = .Main
    // transition vars
    let ASV_Y_OFFSET_INIT: CGFloat = -150
    @Published var allSolvesViewYOffset: CGFloat = -150 // should match ASV_Y_OFFSET_INIT
    @Published var mainViewOpacity: Double = 1
    @Published var pageTransitionPercentage: Double = 0
    @Published var allSolvesViewScale: CGFloat = 0.9
    let SCALE_DIFFERENCE: CGFloat = 0.1
    let PAGE_DRAG_MAX: CGFloat = 150
    let ASV_Y_ABS_OFFSET: CGFloat = 150 // AllSolveView Y Absolute Offset
    var blockTransition: Bool = false
    @Published var blockGesture: Bool = false // this is set by the timer and has a 0.5 second buffer from when timerstops
    
    
    // settigns page
    @Published var inSettings: Bool = false
    
    // camera stuff
    var cameraController: CameraController!
    
    // video stuff
    var videoPlayerController: VideoPlayerController!
    @Published var showingVideo: Bool = false
    
    @Published var showingDetails: Bool = false
    
    
    init() {
        let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    /*
     * this me
     */
    @objc func appMovedToBackground() {
        print("App moved to background, setting page to, ", self.onPage.rawValue)
        if self.onPage == .Main {
            self.setStateForMain()
        } else {
            self.setStateForAllSolves()
        }
    }
    
    /*
     *  opens details popup
     */
    public func openDetails(solveItem: SolveItem) {
        
        print("opening_details for SolveItem: ", solveItem.timeMS)
        self.detailsViewController.goto(solveItem: solveItem)
        self.showingDetails = true
        
        Analytics.logEvent("open_details_popup", parameters: [
            "group": solveItem.cubeType.name as NSObject,
            "group_description": solveItem.cubeType.descrip as NSObject,
            "seconds": solveItem.timeMS as NSObject,
            "hasVideo": solveItem.hasVideo.description as NSObject
        ])
        
    }
    
    public func closeDetails() {
        lightTap.impactOccurred()
        self.showingDetails = false
    }
    
    /*
     *  listens for a play video call from anywhere
     */
    public func openVideo(url: URL) {
        
        print("playing video, current in cvc, url: ", url)
        self.videoPlayerController.goto(url: url)
        self.showingVideo = true
        
        
        
    }
    
    public func openVideo(name: String) {
        
        print("playing video, current in cvc, name: ", name)
        self.videoPlayerController.goto(name: name)
        self.showingVideo = true
        
    }
    
    public func openVideo(solveItem: SolveItem) {
        
        print("playing video, current in cvc, solveItem: ", solveItem.timeMS)
        self.videoPlayerController.goto(solveItem: solveItem)
        self.showingVideo = true
            
        Analytics.logEvent("open_vieo_popup", parameters: [
            "group": solveItem.cubeType.name as NSObject,
            "group_description": solveItem.cubeType.descrip as NSObject,
            "seconds": solveItem.timeMS as NSObject
        ])
        
    }
    
    /*
     *  listens for a close video call from VideoPlayerController.swift
     */
    public func closeVideo() {
        lightTap.impactOccurred()
        self.videoPlayerController.stopPlayer()
        self.showingVideo = false
    }
    
    
    
    /*
     *  THE DRAG GESTURE TO SWITCH VIEWS
     * called by AllSolvesView & Buttons View
     */
    public func dragChanged(_ v: DragGesture.Value) {
        
        // this blocks ransition pages during and 0.4 seconds after the timer stops, set by timerController
        if blockGesture { return }
        
        if onPage == .Main { // if on main page
            
            let transY: CGFloat = v.translation.height
            
            
            // leave if we are draggin up
            if transY < 0 || timer.bothActivated || timer.timerGoing {
                self.blockTransition = true
                return
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.blockTransition = false
                }
            }
            
            // calculate percentage
            self.pageTransitionPercentage = Double(transY / PAGE_DRAG_MAX)
            
            // apply percentage to main view opacity
            self.mainViewOpacity = 1 - self.pageTransitionPercentage
            
            // apply percentage to allSolveView Y offset
            let yOffset: CGFloat = ASV_Y_OFFSET_INIT + CGFloat(self.pageTransitionPercentage) * ASV_Y_ABS_OFFSET
            self.allSolvesViewYOffset = (yOffset > 0 ? 0 : yOffset)
            
            // scale stuff
            let newScale: CGFloat = 1 - (SCALE_DIFFERENCE * CGFloat(1-pageTransitionPercentage))
            self.allSolvesViewScale = (newScale > 1 ? 1 : newScale)
        
        } else { // if on the other page
            
            // leave if we are draggin down
            if v.translation.height > 0 || allSolvesController.selecting {
                return
            }
            
            
            let transY: CGFloat = (v.translation.height * -1)
            
            // calculate percentage
            self.pageTransitionPercentage = Double(transY / PAGE_DRAG_MAX)
            
            // apply percentage to main view opacity
            self.mainViewOpacity = self.pageTransitionPercentage
            
            // apply percentage to allSolveView Y offset
            let yOffset: CGFloat = CGFloat(self.pageTransitionPercentage) * (ASV_Y_ABS_OFFSET * -1)
            self.allSolvesViewYOffset = (yOffset < ASV_Y_OFFSET_INIT ? ASV_Y_OFFSET_INIT : yOffset)
            
            // scale stuff
            let newScale: CGFloat = 1 - (SCALE_DIFFERENCE * CGFloat(1-pageTransitionPercentage))
            self.allSolvesViewScale = (newScale < 0.9 ? 0.9 : newScale)
            
        }
        
    }
    
    /*
     *  THE DRAG ENDED GESTURE  TO SWITCH VIEWS
     * called by AllSolvesView & Buttons View
     */
    public func dragEnded(_ v: DragGesture.Value) {
        let transY: CGFloat = abs( v.translation.height )
        
        // calculate percentage
        self.pageTransitionPercentage = Double(transY / PAGE_DRAG_MAX)
        
        // this blocks ransition pages during and 0.4 seconds after the timer stops, set by timerController
        if blockGesture { return }
        
        if onPage == .Main {
            
            // leave if we are draggin up
            if v.translation.height < 0 || blockTransition  /*timer.bothActivated || timer.timerGoing*/  {
                self.setPageTo(self.onPage)
                return
            }
            
            if self.pageTransitionPercentage > 0.5 { // goto all solves view
                
                /*
                self.allSolvesViewYOffset = 0
                self.mainViewOpacity = 0
                self.pageTransitionPercentage = 1
                self.allSolvesViewScale = 1
                */
                setStateForAllSolves()
 
            } else {
                /*
                self.allSolvesViewYOffset = -150
                self.mainViewOpacity = 1
                self.pageTransitionPercentage = 0
                self.allSolvesViewScale = 0.9
                */
                
                setStateForMain()
                
            }
            
            setPageTo(.showAll)
        } else {
            // leave if we are draggin down
            if v.translation.height > 0 || timer.bothActivated || timer.timerGoing  {
                
                /// go to all solves view just incase
                setStateForAllSolves()
                
                return
            }
            
            if self.pageTransitionPercentage < 0.5 { // goto all solves view
                
                setStateForAllSolves()
                
            } else {
                
                setStateForMain()
                
            }
            
            setPageTo(.Main)
        }
        
    }
    
    
    func setPageTo(_ p: Page) {
        lightTap.impactOccurred()
        
        if p == .settings {
            self.setStateForSettings()
        }else { // a button that was not settings was pressed
            // check if we need to exit settings
            if self.onPage == .settings {
                self.inSettings = false
            }
        }
        
        if p == .showAll { // load solves before going there
            // update solves in
            self.setStateForAllSolves()
            self.allSolvesController.updateSolves()
            self.onPage = .showAll
        }
        
        if p == .Main {
            self.setStateForMain()
            self.onPage = .Main
        }
        
        
        self.sbEditMode = false
        
        self.pushOutSidebar()
        
        
    }
    
    
    /*
     *  Sets all the states for Settings page
     */
    private func setStateForSettings() {
        if !inSettings  {
            
            if cameraController.isInRecordingBuffer {
                cameraController.stopRecording(save: true)
            }
            
            self.inSettings = true
            self.onPage = .settings
            
        } else {
            self.inSettings = false
            self.setPageTo(.Main)
        }
        
    }
    
    private func setStateForAllSolves() {
        self.allSolvesViewYOffset = 0
        self.mainViewOpacity = 0
        self.pageTransitionPercentage = 1
        self.allSolvesViewScale = 1
        
        /*
         *  hide camera layer if not disabled
         */
        if cameraController.videoState != .disabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.cameraController.turnOffCamera()
            }
        }
      
    }
    
    private func setStateForMain() {
        self.allSolvesViewYOffset = -150
        self.mainViewOpacity = 1
        self.pageTransitionPercentage = 0
        self.allSolvesViewScale = 0.9
        
        /*
         *  hide camera layer if not disabled
         */
        if cameraController == nil { return }
        if cameraController.videoState != .disabled {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cameraController.turnOnCamera()
            }
        }
    }
    
    
    /*
     *  shows popup to confirm they want to delete a single video
     * triggered by AllSolvesView popups from within MainView
     */
    public func tappedDeleteSingleVideoFor(solveItem: SolveItem) {
        showPopup(v: AnyView(DeleteVideoConfirmVieew(itemWithVideo: solveItem)))
        //self.showingDetails = false
    }
    
    /*
     *  shows popup to confirm they want to delete a single solve
     * triggered by AllSolvesView popups from within MainView
     */
    public func tappedDeleteSingleSolve(itemToDelete: SolveItem) {
        showPopup(v: AnyView(DeleteSingleSolveConfirmView(toDelete: itemToDelete)))
        //self.showingDetails = false
    }
    
    /*
     *  shows popup to confirm they want to delete
     * triggered by EditSolvesBarView from within AllSolvesView
     */
    public func tappedDeleteSolves() {
        showPopup(v: AnyView(DeleteSolvesView()))
    }
    
    /*
     *  this is triggered when user wants to edit solves from AllSolvesView
            * pass SolveElementController so we can use that to unselect within th epopup
     */
    public func tappedEditSolves(solves: [SolveElementController]) {
        showPopup(  v: AnyView(EditSolveView(/*controller: editSolveController, parent: popupController,*/ solves: solves, selection: 1)),
                    title: "MOVE \(allSolvesController.selected.count) SAVED TIMES TO...")
    }
    
    /*
     *  This is triggered when the user taps new Cube Type Icon
            * called by onClick listener in SidebarView.swift
     */
    public func tappedAddCT() {
        print("[cvc] creating popup for new CubeType")
        showPopup(v: AnyView(NewCubeTypeView(controller: ctEditController)), title: "CREATE A NEW GROUPING")
    }
    
    /*
     *  When editing a CT we bring up the add CT view and change it a lil
     */
    public func tappedEditCT(id: UUID) {
        let ct = cTypeHandler.getControllerFrom(id: id)!.ct
        showPopup(v: AnyView(EditCubeTypeView(controller: ctEditController, parent: popupController, setCT: ct)),
                  title: "EDIT, \(ct.name)")
    }
    
    public func showPopup(v: AnyView, title: LocalizedStringKey? = nil) {
        lightTap.impactOccurred()
        popupController.set(v, title: title)
        popupShowing = true
        
        print("[cvc] popupShowing = ", popupShowing)
    }
    
    public func hidePopup() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        lightTap.impactOccurred()
        
        
        popupShowing = false
    }
    
    
    
    /*
     *  The drag gesture for the sidebar
            This is called by SidebarView.swift
     */
    var sbDrag: some Gesture {
        DragGesture()
            .onChanged { [self] (trans) in
                self.sidebarDraggin = true
                
                let xTrans = trans.translation.width
                
                self.sbXPos = xTrans
                
                if sbXPos >= sidebarInPos.x {
                    self.sbXPos = sidebarInPos.x
                }
                
                // shoadow stuff
                let p = self.sbXPos / sidebarInPos.x
                self.sbBgOpacity = Double((0.8)*p)
                
            }
            .onEnded { [self] (trans) in
                self.sidebarDraggin = false
                
                //var xTrans = trans.translation.width
        
                if self.sbXPos > sidebarOutPos.x/2 {
                    self.pullInSidebar()
                }else {
                    self.pushOutSidebar()
                }
                
            }
    }
    
    var sbTab: some Gesture {
        TapGesture().onEnded { [self] (e) in
            if !sidebarDraggin {
                self.toggleSidebar()
            }
        }
    }
    
    func toggleSidebar() {
        if sidebar {
            self.pushOutSidebar()
        }else {
            self.pullInSidebar()
        }
    }
    
    func pullInSidebar() {
       // if !sidebar {
            sidebar = true
            self.sbXPos = self.sidebarInPos.x
            self.sbBgOpacity = 0.8
       // }
    }
    
    func pushOutSidebar() {
       // if sidebar {
            sidebar = false
            self.sbXPos = self.sidebarOutPos.x
            self.sbBgOpacity = 0
       // }
        
        // cancel edit mode
        self.sbEditMode = false
    }
    
    var peripheralOpacity: Double  {
        if timer.startApproved || timer.timerGoing || timer.oneActivated{
            return -0.3
        }else {
            return 0.5
        }
    }
    

    
    
}

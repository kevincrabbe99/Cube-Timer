//
//  ContentViewController.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 12/28/20.
//

import Foundation
import SwiftUI


class ContentViewController: ObservableObject {
    
    var ctEditController: CTEditController!
    var popupController: PopupController!
    var cTypeHandler: CTypeHandler!
    var timer: TimerController!
    var allSolvesController: AllSolvesController!
    
    
    // sidebar positioning
    @Published var sidebar: Bool = false
    let sidebarOutPos: CGPoint = CGPoint(x: -1 * (UIScreen.main.bounds.width/6)+45, y: UIScreen.main.bounds.height/2)// 45 shows 5px of the sidebar always
    let sidebarInPos: CGPoint = CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.height/2)
    let sidebarWidth: CGFloat = UIScreen.main.bounds.width / 3
    @Published var sidebarDraggin: Bool = false
    @Published var sbBgOpacity: Double = 0
    @Published var sbXPos: CGFloat = -1 * (UIScreen.main.bounds.width/6)+45 // initialize it to sidebarOutPos x value
    
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
    
    
    /*
     *  THE DRAG GESTURE TO SWITCH VIEWS
     * called by AllSolvesView & Buttons View
     */
    public func dragChanged(_ v: DragGesture.Value) {
       
        if onPage == .Main { // if on main page
            
        
            let transY: CGFloat = v.translation.height
            
            // leave if we are draggin up
            if transY < 0 || timer.bothActivated || timer.timerGoing {
                return
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
            if v.translation.height > 0 {
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
        print("draggin ended: ", v.translation.height)
        
        let transY: CGFloat = abs( v.translation.height )
        
        // calculate percentage
        self.pageTransitionPercentage = Double(transY / PAGE_DRAG_MAX)
        
        if onPage == .Main {
            
            // leave if we are draggin up
            if v.translation.height < 0 ||  timer.bothActivated || timer.timerGoing  {
                return
            }
            
            if self.pageTransitionPercentage > 0.5 { // goto all solves view
                
                self.allSolvesViewYOffset = 0
                self.mainViewOpacity = 0
                self.pageTransitionPercentage = 1
                self.allSolvesViewScale = 1
                
            } else {
                
                self.allSolvesViewYOffset = -150
                self.mainViewOpacity = 1
                self.pageTransitionPercentage = 0
                self.allSolvesViewScale = 0.9
                
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
        
        
        if p == .showAll { // load solves before going there
            // update solves in
            self.setStateForAllSolves()
            self.allSolvesController.updateSolves()
        }else {
            self.setStateForMain()
        }
        
        
        self.onPage = p
        
    }
    
    private func setStateForAllSolves() {
        self.allSolvesViewYOffset = 0
        self.mainViewOpacity = 0
        self.pageTransitionPercentage = 1
        self.allSolvesViewScale = 1
    }
    
    private func setStateForMain() {
        self.allSolvesViewYOffset = -150
        self.mainViewOpacity = 1
        self.pageTransitionPercentage = 0
        self.allSolvesViewScale = 0.9
    }
    
    
    
    
    
    
    
    /*
     *  this is triggered when user wants to edit solves from AllSolvesView
            * pass SolveElementController so we can use that to unselect within th epopup
     */
    public func tappedEditSolves(solves: [SolveElementController]) {
        showPopup(v: AnyView(EditSolveView(/*controller: editSolveController, parent: popupController,*/ solves: solves, selection: 1)))
    }
    
    /*
     *  This is triggered when the user taps new Cube Type Icon
            * called by onClick listener in SidebarView.swift
     */
    public func tappedAddCT() {
        print("creating new Cube Type view")
        showPopup(v: AnyView(NewCubeTypeView(controller: ctEditController, parent: popupController)))
    }
    
    /*
     *  When editing a CT we bring up the add CT view and change it a lil
     */
    public func showCTPopupFor(id: UUID) {
        let ct = cTypeHandler.getControllerFrom(id: id)!.ct
        showPopup(v: AnyView(EditCubeTypeView(controller: ctEditController, parent: popupController, setCT: ct)))
    }
    
    public func showPopup(v: AnyView) {
        print("setting popupShowing to: true")
        lightTap.impactOccurred()
        popupController.set(v)
        popupShowing = true
        print("popupShowing = ", popupShowing)
    }
    
    public func hidePopup() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        lightTap.impactOccurred()
        print("setting popupShowing to: false")
        popupShowing = false
       // shaderOpacity = 0
        print("popup hidden")
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
                
                var xTrans = trans.translation.width
        
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
    }
    
    var peripheralOpacity: Double  {
        if timer.startApproved || timer.timerGoing || timer.oneActivated{
            return -0.3
        }else {
            return 0.5
        }
    }
    

    
    
}

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
    
    // page states
    @Published var onPage: Page = .Main
    @Published var sidebar: Bool = false
    
    // sidebar positioning
    let sidebarOutPos: CGPoint = CGPoint(x: -1 * (UIScreen.main.bounds.width/6)+45, y: UIScreen.main.bounds.height/2)// 45 shows 5px of the sidebar always
    let sidebarInPos: CGPoint = CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.height/2)
    let sidebarWidth: CGFloat = UIScreen.main.bounds.width / 3
    @Published var sidebarDraggin: Bool = false
    @Published var sbBgOpacity: Double = 0
    @Published var sbXPos: CGFloat = -1 * (UIScreen.main.bounds.width/6)+45 // initialize it to sidebarOutPos x value
    
    // popup stuff
    @Published var popupShowing: Bool = false
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    
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
    private func showPopup() {
        popupShowing = true
        //shaderOpacity = 0.8
        print("popup showing")
    }
    */
    
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
    
    func setPageTo(_ p: Page) {
        if p == .showAll { // load solves before going there
            // update solves in
            self.allSolvesController.updateSolves()
        }
        self.onPage = p
    }

    
    
}

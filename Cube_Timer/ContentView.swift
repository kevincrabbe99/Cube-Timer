//
//  ContentView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI
import CoreData

enum Page: String {
    case Main = "Main Page"
    case showAll = "Show All Solves"
}



struct ContentView: View {
    
    
    @State var onPage: Page = .Main
    @State var sidebar: Bool = false
    
    let w: CGFloat = UIScreen.main.bounds.width
    let h: CGFloat = UIScreen.main.bounds.height
    
    let sidebarOutPos: CGPoint = CGPoint(x: -1 * (UIScreen.main.bounds.width/6)+45, y: UIScreen.main.bounds.height/2)// 45 shows 5px of the sidebar always
    let sidebarInPos: CGPoint = CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.height/2)
    let sidebarWidth: CGFloat = UIScreen.main.bounds.width / 3
    @State var sidebarDraggin: Bool = false
    @State var sbBgOpacity: Double = 0
    @State var sbXPos: CGFloat = -1 * (UIScreen.main.bounds.width/6)+45 // initialize it to sidebarOutPos x value
    
    @ObservedObject var timer: TimerController = TimerController()
    @ObservedObject var solveHandler: SolveHandler = SolveHandler()
    @ObservedObject var bo3Controller: BO3Controller = BO3Controller()
    @ObservedObject var sbController: SidebarController = SidebarController()
    @ObservedObject var cTypeHandler: CTypeHandler = CTypeHandler()
    @ObservedObject var popupController: PopupController = PopupController()
    @ObservedObject var ctEditController: CTEditController = CTEditController()
    
    
    // vars for popup
    @State var popupShowing: Bool = false
    
    // vars for edit ct mode
    
    
    
   // @State var shaderOpacity: Double = 0
    
    
    /*
     *  This is thie first init, we link all the controller and handlers here
     */
    init() {
        // set timer controllers
        self.timer.solveHandler = solveHandler
        self.timer.bo3Controller = bo3Controller
        self.timer.CTypeHandler = cTypeHandler
        
        // set solveHandler controllers
        self.solveHandler.timer = timer
        self.solveHandler.bo3Controller = bo3Controller
        self.solveHandler.sbController = sbController
        self.solveHandler.CTypeHandler = cTypeHandler
        
        // set the timers BO3 Controller
        //self.timer.bo3Controller = bo3Controller
        self.bo3Controller.solveHandler = solveHandler
        self.bo3Controller.timerController = timer
        self.bo3Controller.CTypeHandler = cTypeHandler
        
        // side bar controller stuff
        self.sbController.solveHandler = solveHandler
        self.sbController.cTypeHandler = cTypeHandler
        
        // popu controller stuff
        self.popupController.contentView = self
        self.popupController.cTypeHandler = cTypeHandler
        
        // cube type editor controller
        self.ctEditController.cTypeHandler = cTypeHandler
        
        
        // set popupview
      
        
        // update the stopwatch display to show the last solve time
        self.timer.setDisplayToLastSolve()
    }
    
    
    /*
     *  When editing a CT we bring up the add CT view and change it a lil
     */
    public func showCTPopupFor(id: UUID) {
        let ct = cTypeHandler.getFrom(id: id)
        showPopup(v: AnyView(EditCubeTypeView(controller: ctEditController, contentView: self, setCT: ct)))
    }
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    public func showPopup(v: AnyView) {
        lightTap.impactOccurred()
        popupController.set(v)
        popupShowing = true
    }
    
    public func hidePopup() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        lightTap.impactOccurred()
        popupShowing = false
       // shaderOpacity = 0
        print("popup hidden")
    }
    
    /*
     *  This is triggered when the user taps new Cube Type Icon
            * called by onClick listener in SidebarView.swift
     */
    public func tappedAddCT() {
        showPopup(v: AnyView(NewCubeTypeView(controller: ctEditController, contentView: self)))
        print("popup showing")
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
            .onChanged { (trans) in
                self.sidebarDraggin = true
                
                let xTrans = trans.translation.width
                
                self.sbXPos = xTrans
                
                if sbXPos >= sidebarInPos.x {
                    sbXPos = sidebarInPos.x
                }
                
                // shoadow stuff
                let p = sbXPos / sidebarInPos.x
                self.sbBgOpacity = Double((0.8)*p)
                
            }
            .onEnded { (trans) in
                self.sidebarDraggin = false
                
                var xTrans = trans.translation.width
        
                if sbXPos > sidebarOutPos.x/2 {
                    self.pullInSidebar()
                }else {
                    self.pushOutSidebar()
                }
                
            }
    }
    
    var sbTab: some Gesture {
        TapGesture().onEnded { (e) in
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
        self.onPage = p
    }

    
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                
             
                
                switch onPage {
                case .Main:
                    MainView(parent: self, timer: timer, solveHandler: solveHandler, bo3Controller: bo3Controller)
                        .zIndex(0)
                case .showAll:
                    AllSolvesView(parent: self, solveHandler: solveHandler)
                        .zIndex(0)
                default:
                    MainView(parent: self, timer: timer, solveHandler: solveHandler, bo3Controller: bo3Controller)
                        .zIndex(0)
                }
                
                // add stuff for sidebar
                // the tab for the sidebar
            
                
                Color.black
                    .opacity(sbBgOpacity)
                    .animation(.spring())
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                    .zIndex(1)
                    .onTapGesture { // close sidebar when tapped
                        self.pushOutSidebar()
                    }
                
                SidebarView(contentView: self, cTypeHandler: cTypeHandler)
                    .frame(width: geo.size.width / 3, height: geo.size.height)
                    //.position(x: geo.size.width / 6, y: geo.size.height/2)
                    .position(x: sbXPos, y: geo.size.height/2)
                    .animation(.spring())
                    .zIndex(3)
                
                
                /*
                 *  popup stuff
                 */
                if popupShowing {
                    Color.black
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.2)))
                        .zIndex(6)
                        .opacity(0.5)
                        .onTapGesture {
                            self.hidePopup()
                        }
                    
                    PopupView(contentView: self, ctEditController: ctEditController, popupController: popupController)
                        .transition(AnyTransition.move(edge: .top))
                        .animation(.spring())
                        // .transition(AnyTransition.opacity.combined(with: .slide).animation(.spring()))
                        .zIndex(9)
                }
                
            }
        
        }
        .edgesIgnoringSafeArea(.all)
    
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(PreviewLayout.fixed(width: 568, height: 320))
            //.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//
//  ContentView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI
import CoreData
import Firebase

enum Page: String {
    case Main = "Main Page"
    case showAll = "Show All Solves"
    case settings = "Settings"
}



struct ContentView: View {

    @ObservedObject var cTypeHandler: CTypeHandler = CTypeHandler()
    @ObservedObject var timer: TimerController = TimerController()
    @ObservedObject var solveHandler: SolveHandler = SolveHandler()
    
    @ObservedObject var barGraphController: BarGraphController = BarGraphController()
    
    @ObservedObject var bo3Controller: BO3Controller = BO3Controller()
    @ObservedObject var sbController: SidebarController = SidebarController()
    @ObservedObject var popupController: PopupController = PopupController()
    @ObservedObject var ctEditController: CTEditController = CTEditController()
    
    @ObservedObject var allSolvesController: AllSolvesController = AllSolvesController()
   // @ObservedObject var solvesGridController: SolvesGridController = SolvesGridController()
    @ObservedObject var editSolveController: EditSolveController = EditSolveController()
    @ObservedObject var settingsController: SettingsController = SettingsController()
    @ObservedObject var alertController: AlertController = AlertController()
    
  
    @StateObject var cvc: ContentViewController = ContentViewController()
    
    /*
     *  This is thie first init, we link all the controller and handlers here
     */
    init() {
        
        
        // set CTypeHandler
        self.cTypeHandler.contentView = self
        self.cTypeHandler.solveHandler = solveHandler
        self.cTypeHandler.allSolvesController = allSolvesController
        
        // set timer controllers
        self.timer.solveHandler = solveHandler
        self.timer.bo3Controller = bo3Controller
        self.timer.cTypeHandler = cTypeHandler
        self.timer.settingsController = settingsController
        
        // set solveHandler controllers
        self.solveHandler.timer = timer
        self.solveHandler.bo3Controller = bo3Controller
        self.solveHandler.sbController = sbController
        self.solveHandler.cTypeHandler = cTypeHandler
        self.solveHandler.allSolvesController = allSolvesController
        self.solveHandler.barGraphController = barGraphController
        
        
        self.solveHandler.solvesByTimeFrame.cTypeHandler = cTypeHandler
        self.solveHandler.solvesByTimeFrame.allSolvesController = allSolvesController
        
        // bar graph controller stuff
        self.barGraphController.solveHandler = solveHandler
        self.barGraphController.timer = timer
        self.barGraphController.cTypeHandler = cTypeHandler
        
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
        
        // all solves controller stuff
        self.allSolvesController.contentView = self
        self.allSolvesController.solvesData = solveHandler.solvesByTimeFrame
        self.allSolvesController.cTypeHandler = cTypeHandler
        
        // edit popup controller stuff
        self.editSolveController.cTypeHandler = cTypeHandler
        self.editSolveController.solvesData = solveHandler.solvesByTimeFrame
        self.editSolveController.allSolvesController = allSolvesController
        
        // settings controller refs
        self.settingsController.alertController = alertController
        
        
        
        // update the stopwatch display to show the last solve time
        self.timer.setDisplayToLastSolve()
        
    }
    
    var sidebarWidth: CGFloat {
        if UIDevice.IsIpad {
            return UIScreen.main.bounds.width / 3
        }
        if UIDevice.hasNotch {
            return UIScreen.main.bounds.width / 3
        }
        
        // old iphone
        return UIScreen.main.bounds.width / 2.4
    }
    
    let gradient = Gradient(colors: [.init("very_dark_black"), .init("dark_black")])
    var body: some View {
        
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .opacity(0.6)
                
             
                ZStack {
                    
                    AllSolvesView(parent: self)
                        .offset(y: cvc.allSolvesViewYOffset)
                        .scaleEffect(cvc.allSolvesViewScale)
                        
                    
                    MainView(parent: self, solveHandler: solveHandler, bo3Controller: bo3Controller)
                        .opacity(cvc.mainViewOpacity)
                       
                    if cvc.inSettings {
                        SettingsView()
                            .transition(.move(edge: .bottom))
                    }
                    
                    
                    
                }
                .animation(.spring())
                
              
                // add stuff for sidebar
                // the tab for the sidebar
            
                
                Color.black
                    .opacity(cvc.sbEditMode ? 1 : cvc.sbBgOpacity)
                    .animation(.spring())
                    .frame(width: geo.size.width, height: geo.size.height)
                    .position(x: geo.size.width/2, y: geo.size.height/2)
                    .zIndex(1)
                    .onTapGesture { // close sidebar when tapped
                        cvc.pushOutSidebar()
                    }
                
                SidebarView(contentView: self, cTypeHandler: cTypeHandler)
                    //.frame(width: (UIDevice.current.hasNotch || UIDevice.IsIpad ? (geo.size.width / 3) : (geo.size.width / 2.4)), height: geo.size.height)
                    .frame(width: sidebarWidth)
                    //.position(x: geo.size.width / 6, y: geo.size.height/2)
                    .position(x: cvc.sbXPos, y: geo.size.height/2)
                    .offset(x: (UIDevice.hasNotch || UIDevice.IsIpad ? 0 : -20))
                    .animation(.spring())
                    .zIndex(3)
                
                
                /*
                 *  popup stuff
                 */
                if cvc.popupShowing {
                    Color.black
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.2)))
                        .zIndex(6)
                        .opacity(0.75)
                        .onTapGesture {
                            cvc.hidePopup()
                        }
                    
                    PopupView(contentView: self/*, ctEditController: ctEditController, popupController: popupController*/)
                        .transition(AnyTransition.move(edge: .top))
                        .animation(.spring())
                        // .transition(AnyTransition.opacity.combined(with: .slide).animation(.spring()))
                        .zIndex(9)
                }
                
                AlertView()
                    .zIndex(100)
                
            }
        
        }
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.all)
        .onAppear() {
            // contentViewController stuff
            
            // objects that need to reference the cvc
            self.cTypeHandler.cvc = cvc
            self.popupController.cvc = cvc
            self.timer.cvc = cvc
            
            // objects which cvc needs to reference 
            self.cvc.ctEditController = ctEditController
            self.cvc.popupController = popupController
            self.cvc.cTypeHandler = cTypeHandler
            self.cvc.timer = timer
            self.cvc.allSolvesController = allSolvesController
        
            
            solveHandler.updateSolves(to: solveHandler.currentTimeframe) // sets timeframe and updates everything
            
            // FOR DEV PURPOSE: Uncommenting this will create 50 random solves to the default cubetype
            //solveHandler.addGenericSampleSolves(count: 150) //are u sure?
        }
       .environment(\.locale, .init(identifier: "hi")) // DEV USE ONLY
        .environmentObject(solveHandler)
        .environmentObject(cTypeHandler)
        .environmentObject(allSolvesController)
        .environmentObject(popupController)
        .environmentObject(editSolveController)
        .environmentObject(ctEditController)
        .environmentObject(cvc)
        .environmentObject(timer)
        .environmentObject(settingsController)
        .environmentObject(alertController)
        .environmentObject(barGraphController)
        .onAppear(
        
        
        )
    
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
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

extension UIDevice {
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    static var IsIpad: Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
}

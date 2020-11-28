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
    
    @ObservedObject var timer: TimerController = TimerController()
    @ObservedObject var solveHandler: SolveHandler = SolveHandler()
    @ObservedObject var bo3Controller: BO3Controller = BO3Controller()

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
    
    /*
     *  This is thie first init, we link all the controller and handlers here
     */
    init() {
        // set timer controllers
        self.timer.solveHandler = solveHandler
        self.timer.bo3Controller = bo3Controller
        
        // set solveHandler controllers
        self.solveHandler.timer = timer
        self.solveHandler.bo3Controller = bo3Controller
        
        // set the timers BO3 Controller
        //self.timer.bo3Controller = bo3Controller
        self.bo3Controller.solveHandler = solveHandler
        self.bo3Controller.timerController = timer
        
        // update the stopwatch display to show the last solve time
        self.timer.setDisplayToLastSolve()
    }
    
    
    var body: some View {
        
        switch onPage {
        case .Main:
            MainView(parent: self, timer: timer, solveHandler: solveHandler, bo3Controller: bo3Controller)
        case .showAll:
            AllSolvesView(parent: self, solveHandler: solveHandler)
        default:
            MainView(parent: self, timer: timer, solveHandler: solveHandler, bo3Controller: bo3Controller)
        }
        
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

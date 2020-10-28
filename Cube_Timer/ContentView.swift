//
//  ContentView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    
    @ObservedObject var timer: TimerController = TimerController()
    //@ObservedObject var solveHandler: SolveHandler = SolveHandler()

    var peripheralOpacity: Double  {
        if timer.startApproved || timer.timerGoing || timer.oneActivated{
            return -0.3
        }else {
            return 0.5
        }
    }
    /*
    init() {
        self.timer.solveHandler = solveHandler
        self.solveHandler.timer = timer
    }
     */
    
    var body: some View {
        GeometryReader { geo in
            Color.init("very_dark_black")
            ZStack {
                
                ButtonsView(timer: timer)
                TopBar(tc: timer)
                    .position(x: geo.size.width/2, y: geo.size.height-50)
                    .opacity(peripheralOpacity + 0.3)
                    .animation(.easeIn)
                StatsPreviewView(timer: timer /*solveHandler: solveHandler*/)
                    .offset(y:-30)
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
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

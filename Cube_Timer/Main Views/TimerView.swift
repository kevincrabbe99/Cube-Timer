//
//  StatsPreviewView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI
import CoreData

/*(
 * INCLUDES:    over/under stats
 *              stopwatch display
 *              last 3 solve bar
 */
struct TimerView: View {
     
   // @Environment(\.managedObjectContext) private var viewContext
    /*
    @FetchRequest(entity: SolveItem.entity(), sortDescriptors: [])
    var fetchedSolves: FetchedResults<SolveItem>
    */
    
    var parent: MainView!
    
    
    //var type: PuzzleType = .a3x3x3
    //var brand: PuzzleBrand = .rubiks
    
    @ObservedObject var timer: TimerController
    @ObservedObject var solveHandler: SolveHandler
    @ObservedObject var bo3Controller: BO3Controller
    
    
    init(p: MainView, t: TimerController, s: SolveHandler, bo3c: BO3Controller) {
        self.parent = p
        self.timer = t
        self.solveHandler = s
        self.bo3Controller = bo3c
        // pass over s & t to BO3Controllerz
    }
    /*
     *
     */
    private func setControllers() {
    }
    
    
    
    var peripheralOpacity: Double  {
        if (timer.oneActivated || timer.timerGoing) {
            return 0
        }else {
            return 0.5
        }
    }
    
    var statBarGraphOpacity: Double  {
        if timer.bothActivated || timer.timerGoing {
            return 0
        }else {
            return 0.9
        }
    }
    
    /*
     * updates bar width based on last 3 count
     */
    var slvsBarWidth: CGFloat {
        let totalWidth = 280
        let singleLabelWidth = totalWidth / 3
        return CGFloat(singleLabelWidth * 3)
    }
    
    /*
     *  updates height of last 3 bar
     *  Gets taller if in last3 timeframe
     */
    var slvsBarHeight: CGFloat {
        if solveHandler.currentTimeframe == .LastThree { // height of BO view
            return 100
        } else { // return regular bar height
            return 20 // regular bar heightr
        }
    }
 
    var slvsBGOpacity: Double {
        if solveHandler.currentTimeframe == .LastThree { // height of BO view
            return 1
        } else { // return regular bar height
            return 0.6 // regular bar heightr
        }
    }
    
/*
    @State var slvsBarWidth: CGFloat = 250
    @State var slvsBarHeight: CGFloat = 20
    @State var slvsOffsetY: CGFloat = 0
    @State var slvsOpacity: Double = 1
    @State var slvsTextOpacity: Double = 1
*/
    func openShowAllSolves() {
        /*
        slvsBarWidth = UIScreen.main.bounds.width
        slvsBarHeight = UIScreen.main.bounds.height
        slvsOffsetY = 30
        slvsOpacity = 1
        slvsTextOpacity = 0
        */
        parent.gotoPage(.showAll)
    }
    
    func closeShowAllSolves() {
        /*
        slvsBarWidth = 280
        slvsBarHeight = 20
        slvsOffsetY = 0
        slvsOpacity = 1
        slvsTextOpacity = 1
        */
    }
    
    
    
    var body: some View {

        VStack {
            
            /*
             *  Timer elements
             */
            VStack {
                
                /* only show upper stuff if there is a solve */
               if solveHandler.size > 0 {
                    /*
                     *  The stuff above the timer
                     */
                    HStack {
                        
                        /*
                         *  compared to average display (above stopwatch)
                         */
                        HStack {
                            Text("\(timer.overUnderTime)")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                            Text("(\(timer.overUnderPercentage, specifier: "%.0f")%)")
                                .font(.system(size: 12))
                        
                        }
                        .frame(width: 210, alignment: .leading)
                        //.frame(width: 260, alignment: .leading)
                        .foregroundColor(timer.statColor)
                        
                        /*
                         *  The delete last button
                         */
                            Button(action: {
                                solveHandler.deleteLast()
                            }, label: {
                                ZStack {
                                    Image(systemName: "delete.left.fill")
                                        .font(.system(size: 14))
                                    
                                }
                                .frame(width: 50, height: 50, alignment: .trailing)
                            })
                            
                    }
                    .offset(y: 5)
                    .frame(width: 260, height: 20)
                
                
               }// end if
                
                /*
                 *  THE ACTUAL TIMER
                 */
                StopwatchDisplayView(timer: timer)
                    .frame(width: 250)
                   // .animation(.spring())`
            }
            
            /*
             *  displays the last 3 bar under the timer
             */
            ZStack {
                
                Button(action: { // background / label
                    openShowAllSolves()
                }, label: {
                    ZStack {
                        Color(.init("very_dark_black"))
                            .cornerRadius(5)
                            .animation(.easeInOut(duration: 0.15))
                            .frame(width: ((slvsBarWidth/3) * CGFloat(solveHandler.last3.count) ), height: slvsBarHeight)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.white.opacity(0.6),lineWidth: 1)
                                    .animation(.easeInOut(duration: 0.15))
                                    .frame(width: ((slvsBarWidth/3) * CGFloat(solveHandler.last3.count) ), height: slvsBarHeight)
                            )
                    }
                    /*
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white.opacity(0.6),lineWidth: 1)
                        .animation(.easeInOut(duration: 0.15))
                        .frame(width: ((slvsBarWidth/3) * CGFloat(solveHandler.last3.count) ), height: slvsBarHeight)
                    */
                })
                
                /*
                 *  The last 3 solves bar
                 */
                VStack {
                    
                    
                    // only show if in 3X mode
                    if solveHandler.currentTimeframe == .LastThree {
                        /*
                         * BEST OF 3 Gamemode
                         */
                        //BestOfThreeView(timer: timer, solveHandler: solveHandler)
                        BestOfThreeView(c: self.bo3Controller) // bo3Controoler is initiated in ContentView.swift
                    }else {
                    
                        HStack(spacing: 30.0) {
                            ForEach(solveHandler.last3) { s in
                                Text(TimeCapture.init(s.timeMS).getAsReadable() )
                                    .fontWeight(.bold)
                                    .opacity(0.6)
                                    .font(.system(size: 13))
                                    /*
                                    .gesture(
                                        TapGesture()
                                            .onEnded { _ in
                                                print("tapped")
                                                self.solveHandler.delete(s)
                                            }
                                    )*/
                                    
                            }
                        } // end last 3 bar [HStack]
                        
                    } // end if
                    
                }
            }
            .frame(width: 280, height: 20, alignment: .top)
            .offset(y: -30)
            .zIndex(90)
            .opacity(timer.peripheralOpacity)
            .animation(
                Animation.easeOut(duration: 0.15)
            )
            
            /*
             *  Displays the bar graph at all times
             */
            StatsBarView(timer: timer, solveHandler: solveHandler)
                .offset(y: -15)
                .opacity(statBarGraphOpacity)
                .animation(Animation.easeOut(duration: 0.15))
            
 
        }
        .foregroundColor(.white)
        .animation(.spring())
        .offset(y: solveHandler.size == 0 ? 50 : 0)
        .onAppear() {
            timer.setDisplayToLastSolve()
        }
    }
    
}

struct StatsPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
        Color.black
            TimerView(p: MainView(parent: ContentView(),solveHandler: SolveHandler(), bo3Controller: BO3Controller()), t: TimerController(), s: SolveHandler(), bo3c: BO3Controller())
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
        .previewLayout(.fixed(width: 250, height: 150))
    }
}

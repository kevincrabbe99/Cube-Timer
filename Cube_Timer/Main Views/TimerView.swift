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
     

    
    var parent: MainView!
    
 
    @ObservedObject var timer: TimerController
    @ObservedObject var solveHandler: SolveHandler
    @ObservedObject var bo3Controller: BO3Controller
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var allSolvesController: AllSolvesController
    
    @EnvironmentObject var settingsController: SettingsController
    
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
            return 90
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
    

    func openShowAllSolves() {

        parent.gotoPage(.showAll)
    }
    
    
    
    
    
    var body: some View {

        VStack(spacing: 0) {
            
            /*
             *  Timer elements
             */
            //VStack {
                
                /* only show upper stuff if there is a solve */
               if solveHandler.size > 0 {
                    
                    /* check if they are saving solves */
                    if !settingsController.pauseSavingSolves {
                        /*
                         *  The stuff above the timer
                         */
                        HStack {
                            /*
                             *  compared to average display (above stopwatch)
                             */
                            HStack {
                                Text("\(timer.overUnderTime)")
                                    .font(Font.custom("Chivo-Bold", size: 12))
                                Text("(\(timer.overUnderPercentage, specifier: "%.0f")%)")
                                    .font(Font.custom("Chivo-Regular", size: 12))
                            
                            }
                            .frame(width: 210, alignment: .leading)
                            //.frame(width: 260, alignment: .leading)
                            .foregroundColor(timer.statColor)
                            
                            Spacer()
                            
                            /*
                             *  The delete last button
                             */
                            if !timer.timerGoing && !timer.oneActivated && !timer.bothActivated {
                                Button(action: {
                                   // solveHandler.deleteLast()
                                    allSolvesController.updateSolves()
                                    cvc.openDetails(solveItem: solveHandler.getLastSolve()!)
                                }, label: {
                                    ZStack {
                                  /*     Image(systemName: "delete.left.fill")
                                            .font(.system(size: 14)) */
                                        IconButton(icon: Image(systemName: "info"), bgColor: Color.init("mint_cream"), iconColor: Color.init("very_dark_black"), width: 15, height: 15, iconWidth: 6, iconHeight: 8)
                                        
                                    }
                                    .frame(width: 50/*, height: 25*/, alignment: .trailing)
                                })
                            }
                                
                        }
                        .frame(width: 280, height: 20, alignment: .leading)
                        //.offset(y: ( timer.timerGoing || timer.oneActivated || timer.bothActivated ?  0 : 20 ))
                        .zIndex(30)
                    
                    } else {
                         // if not savig solves
                        ZStack {
                            Text("Currently not saving solves, change in settings")
                                .font(Font.custom("Play-Bold", size: 10))
                        }
                        .frame(width: 280, height: 20, alignment: .leading)
                        .opacity(0.7)
                    }
                }// end if
                
                
                /*
                 *  THE ACTUAL TIMER
                 */
                StopwatchDisplayView(timer: timer)
                    .frame(width: 250, height: 60)
                    .offset(y: (solveHandler.solves.count == 0 ? -15 : 0)) // push up if no solves
                
            //} // end main ZStack
            //.frame(height: 150)
            
            
                
                if !settingsController.pauseSavingSolves {
                    /*
                     *  displays the last 3 bar under the timer
                     */
                    ZStack {
                        
                        Button(action: { // background / label
                            openShowAllSolves()
                        }, label: {
                            
                            if (solveHandler.currentTimeframe == .LastThree && solveHandler.solves.count >= 3)  {
                                if !(timer.timerGoing || timer.oneActivated || timer.bothActivated) {
                                    
                                    ZStack {
                                        Color(.init("very_dark_black"))
                                            .cornerRadius(5)
                                            .frame(width: ((slvsBarWidth/3) * CGFloat(solveHandler.last3.count) ), height: slvsBarHeight)
                                            
                                            .addBorder(Color.black.opacity(0.95), width: 1, cornerRadius: 5)
                                            .animation(.easeOut(duration: 0.15))

                                    }
                                    .offset(y: 5)
                                }
                            } else if (solveHandler.currentTimeframe == .LastThree) {
                                // background for last 3 solves
                                ZStack {
                                    Color.init("very_dark_black")
                                        .cornerRadius(5)
                                        .addBorder(Color.black.opacity(0.95), width: 1, cornerRadius: 5)
                                        .transition(.opacity)
                                    
                                    /*
                                     * Complete more solves PROMPT
                                     */
                                    Text("COMPLETE \( 3 - solveHandler.solves.count) MORE SOLVES")
                                        .foregroundColor(Color.init("mint_cream"))
                                        .fontWeight(.bold)
                                        .font(Font.custom("Heebo-Black", size: 12))
                                        .opacity(0.8)
                                }
                                .frame(width: slvsBarWidth, height: 50)
                                .offset(y: 5)
                                
                            }
                    
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
                                if solveHandler.solves.count >= 3 {
                                    BestOfThreeView(c: self.bo3Controller) // bo3Controoler is initiated in ContentView.swift
                                        .frame(width: 300, height: slvsBarHeight)
                                }
                                
                            }else {
                            } // end if
                            
                        }
                    }
                    .frame(width: 280, height: 20, alignment: .top)
                    .zIndex(90)
                    .animation(
                        Animation.easeOut(duration: 0.15)
                    )
                    
                    /*
                     *  Displays the bar graph at all times
                     */
                    StatsBarView(timer: timer, solveHandler: solveHandler)
                        // .opacity(statBarGraphOpacity)
                        //.offset(y: 20)
                        .animation(Animation.easeOut(duration: 0.15))
                    
                } // end guard for pauseSavingSolves
        }
        .foregroundColor(.white)
        .offset(y: solveHandler.size == 0 ? 60 : 10)
        .onAppear() {
            timer.setDisplayToLastSolve()
        }
        .animation(.easeOut(duration: 0.15))
        
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

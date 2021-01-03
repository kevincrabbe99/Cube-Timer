//
//  TopBar.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI


struct TimeframeBar: View {
    
    @ObservedObject var solveHandler: SolveHandler
    
    //@State var selectedPos: Int = 1
    
    //var selectedTimeFrame: Int = 0
    //var timeFrames: [STDButton] = []
    
    init(sh: SolveHandler) {
        self.solveHandler = sh
    }
    
    func switchTimeFrameTo(_ tf: Timeframe) {
        solveHandler.currentTimeframe = tf
        print("sp: ", solveHandler.currentTimeframeButtonPos)
    }
    
    let lightTap = UIImpactFeedbackGenerator(style: .light)
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.init("very_dark_black")
                    .cornerRadius(5)
                    .shadow(color: .init("shadow_color"), radius: 7, x: 0, y: 6)
                    //.opacity(0.65)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.init("mint_cream").opacity(0.5))
                    .addBorder(Color.init("mint_cream").opacity(0.8), width: 1, cornerRadius: 4)
                    .frame(width: 35, height: 25)
                    .foregroundColor(.white)
                    .position( x: 31.5, y: 12.5 ) // THIS X VALUE: is the initial left constraint
                    .offset(x: CGFloat(solveHandler.currentTimeframeButtonPos * 55))
                    .animation(.default)
                
                
                HStack(spacing: 20.0) {
                    
                    /*
                    *   NEEDS TO BE UPDATED: make it so it shows only needed timeframes
                    */
                    Button(action: {
                        lightTap.impactOccurred()
                        self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.LastThree)
                        solveHandler.updateSolves(to: .LastThree)
                    }) {
                        ZStack {
                            Text("3X")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 100)
                    }
                    
                    Button(action: {
                        lightTap.impactOccurred()
                        self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.Today)
                        solveHandler.updateSolves(to: .Today)
                    }) {
                        ZStack {
                            Text("1D")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 100)
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.Week) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                            self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.Week)
                            solveHandler.updateSolves(to: .Week)
                        }) {
                            ZStack {
                                Text("1W")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.OneMonth) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                            self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.OneMonth)
                            solveHandler.updateSolves(to: .OneMonth)
                        }) {
                            ZStack {
                                Text("1M")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.ThreeMonths) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                            self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.ThreeMonths)
                            solveHandler.updateSolves(to: .ThreeMonths)
                        }) {
                            ZStack {
                                Text("3M")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.Year) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                            self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.Year)
                            solveHandler.updateSolves(to: .Year)
                        }) {
                            ZStack {
                                Text("1Y")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    Button(action: {
                        lightTap.impactOccurred()
                        self.solveHandler.currentTimeframeButtonPos = Int(CGFloat((solveHandler.solvesByTimeFrame.getApplicableTimeframes().count - 1))) // the count is the total of solveHandler.getApplicabletimeFrames().count + ( -1 )
                        solveHandler.updateSolves(to: .All)
                    }) {
                        ZStack {
                            Text("ALL")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 100)
                    }
                    
                }
                .frame(height: 25) // needed to set the height of the dark bar
            }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .frame(width: 57 * CGFloat(solveHandler.solvesByTimeFrame.getApplicableTimeframes().count)) // this is wht width of the dark bar: NEEDS UPDATING: to conform to needed timeframes
        }
        .frame(width: 390, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    /*
     *  Returns an INT representing the position of that timeframe button within the bottom bar
        CALLED BY: self.body
     
     *  NEEDS UPDATING: wtf is going on here
     */
    private func getIndexOfTfButton(_ tf: Timeframe) -> Int {
        
        let applicableTimeframes = solveHandler.solvesByTimeFrame.getApplicableTimeframes()
        
        if !applicableTimeframes.contains(tf) { // return 0 if the tf DNE
            return 0
        }
        
        /*
         *  All variables used to calculate position
         */
        let hasL3: Bool = applicableTimeframes.contains(.LastThree)
        let hasDay: Bool = applicableTimeframes.contains(.Today)
        let hasWeek: Bool = applicableTimeframes.contains(.Week)
        let hasMonth: Bool = applicableTimeframes.contains(.OneMonth)
        let has3Month: Bool = applicableTimeframes.contains(.ThreeMonths)
        let hasYear: Bool = applicableTimeframes.contains(.Year)
        let hasAll: Bool = applicableTimeframes.contains(.All)
        
        // -1 means DNE
        var L3Pos: Int = 0
        var oneDayPos: Int = 0
        var weekPos: Int = 0
        var monthPos: Int = 0
        var threeMonthsPos: Int = 0
        var yearPos: Int = 0
        var allPos: Int = 0
        /*
         *  Calculates the position of each button depending on the buttons before it
         */
    // L3
        if hasL3 {
            //L3Pos = 0 // set
            oneDayPos += 1
            weekPos += 1
            monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // 1D
        if hasDay {
            //oneDayPos += 1
            weekPos += 1
            monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // W
        if hasWeek {
            //oneDayPos += 1
            //weekPos += 1
            monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // 1M
        if hasMonth {
            //oneDayPos += 1
            //weekPos += 1
            //monthPos += 1
            threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // 3M
        if has3Month {
            //oneDayPos += 1
            //weekPos += 1
            //monthPos += 1
            //threeMonthsPos += 1
            yearPos += 1
            allPos += 1
        }
    // T
        if hasYear {
            //oneDayPos += 1
            //weekPos += 1
            //monthPos += 1
            //threeMonthsPos += 1
            //yearPos += 1
            allPos += 1
        }
        
    // do not need to implement for ALL
        
        /*
         *  Return calculated position
         */
        switch tf {
            case .LastThree:
                return L3Pos
            case .Today:
                return oneDayPos
            case .Week:
                return weekPos
            case .OneMonth:
                return monthPos
            case .ThreeMonths:
                return threeMonthsPos
            case .Year:
                return yearPos
            case .All:
                return allPos
            default:
                return 1
        }
       
    }
    
}

/*
struct STDButton: View {
    
    var label: Timeframe
    var id: Int
    var selection: SelectedPos
    var parent: TopBar
    
    
    var body: some View {
        Button(action: {
            print("tapped: ", label.rawValue)
            parent.switchTimeFrameTo(label)
            selection.set(label)
        }) {
            /*if selected {
                ZStack {
                    Color.white
                        .cornerRadius(5)
                    Text(self.label.rawValue)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .frame(width: 35, height: 25)
                
            }else {*/
                ZStack {
                    Text(self.label.rawValue)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(width: 35, height: 25)
            //}
        }
    }
}
 */

struct selectedButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TimeframeBar(sh: SolveHandler())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: 25))
    }
}

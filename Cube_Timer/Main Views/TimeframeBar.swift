//
//  TopBar.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI

/*
class SelectedPos: ObservableObject {
    
    @Published var selectedPos: CGFloat = 0
    init(_ pos: CGFloat) {
        selectedPos = pos
    }
    func set(_ pos: CGFloat) {
        selectedPos = pos
    }
    
    /*
     *  Used to calculate the position of the slider
     */
    func set(_ pos: Timeframe) {
        switch pos {
        case .LastThree:
            self.selectedPos = 0
        case .Today:
            self.selectedPos = 1
        case .Week:
            self.selectedPos = 2
        case .OneMonth:
            self.selectedPos = 3
        case .ThreeMonths:
            self.selectedPos = 4
        case .Year:
            self.selectedPos = 5
        case .All:
            self.selectedPos = 6
        default:
            self.selectedPos = 7
        }
        print("selectedPos ", selectedPos)
    }
}
 */

struct TimeframeBar: View {
    
    @ObservedObject var solveHandler: SolveHandler
    
    @State var selectedPos: Int = 1
    
    //var selectedTimeFrame: Int = 0
    //var timeFrames: [STDButton] = []
    
    init(sh: SolveHandler) {
        self.solveHandler = sh
    }
    
    func switchTimeFrameTo(_ tf: Timeframe) {
        solveHandler.currentTimeframe = tf
        print("sp: ", selectedPos)
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.init("very_dark_black")
                    .cornerRadius(5)
                    .shadow(color: .init("shadow_color"), radius: 7, x: 0, y: 6)
                    //.opacity(0.65)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.init("dark_white"))
                    .frame(width: 35, height: 25)
                    .foregroundColor(.white)
                    .position( x: 31.5, y: 12.5 ) // THIS X VALUE: is the initial left constraint
                    .offset(x: CGFloat(selectedPos * 55))
                    .animation(.default)
                
                
                HStack(spacing: 20.0) {
                    
                    /*
                    *   NEEDS TO BE UPDATED: make it so it shows only needed timeframes
                    */
                    
                    
                    Button(action: {
                        self.selectedPos = getIndexOfTfButton(.LastThree)
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
                        self.selectedPos = getIndexOfTfButton(.Today)
                        solveHandler.updateSolves(to: .Today)
                    }) {
                        ZStack {
                            Text("1D")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 100)
                    }
                    
                    if solveHandler.getApplicableTimeframes().contains(.Week) { // guard to check if solves in timeframe exist
                        Button(action: {
                            self.selectedPos = getIndexOfTfButton(.Week)
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
                    
                    if solveHandler.getApplicableTimeframes().contains(.OneMonth) { // guard to check if solves in timeframe exist
                        Button(action: {
                            self.selectedPos = getIndexOfTfButton(.OneMonth)
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
                    
                    if solveHandler.getApplicableTimeframes().contains(.ThreeMonths) { // guard to check if solves in timeframe exist
                        Button(action: {
                            self.selectedPos = getIndexOfTfButton(.ThreeMonths)
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
                    
                    if solveHandler.getApplicableTimeframes().contains(.Year) { // guard to check if solves in timeframe exist
                        Button(action: {
                            self.selectedPos = getIndexOfTfButton(.Year)
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
                        self.selectedPos = Int(CGFloat((solveHandler.getApplicableTimeframes().count - 1))) // the count is the total of solveHandler.getApplicabletimeFrames().count + ( -1 )
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
            .frame(width: 57 * CGFloat(solveHandler.getApplicableTimeframes().count)) // this is wht width of the dark bar: NEEDS UPDATING: to conform to needed timeframes
        }
        .frame(width: 390, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    
    /*
     *  Returns an INT representing the position of that timeframe button within the bottom bar
        CALLED BY: self.body
     
     *  NEEDS UPDATING: wtf is going on here
     */
    private func getIndexOfTfButton(_ tf: Timeframe) -> Int {
        
        let applicableTimeframes = solveHandler.getApplicableTimeframes()
        
        switch tf {
        case .LastThree:
            return 0
        case .Today:
            return 1
        case .Week:
            return 2
        case .OneMonth:
            if applicableTimeframes.contains(.Week) {
                return 3
            }
            return 4
        case .ThreeMonths:
            if  applicableTimeframes.contains(.Week) &&
                applicableTimeframes.contains(.OneMonth){
                return 4
            } else if   applicableTimeframes.contains(.Week) ||
                        applicableTimeframes.contains(.OneMonth) {
                return 5
            }
            return 3
        case .Year:
            if applicableTimeframes.count <= 7 {
                return applicableTimeframes.count - 1
            } else  {
                return applicableTimeframes.count - 1
            }
        
        case .All:
            return applicableTimeframes.count
        
        
        default:
            return 0
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

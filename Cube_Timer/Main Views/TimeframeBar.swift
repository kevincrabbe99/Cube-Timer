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
                        //self.solveHandler.currentTimeframeButtonPos = self.solveHandler.getIndexOfTfButton(.LastThree)
                        solveHandler.updateSolves(to: .LastThree)
                    }) {
                        ZStack {
                            Text("3X")
                                .font(Font.custom("Chivo-Bold", size: 16))
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 100)
                    }
                    
                    Button(action: {
                        lightTap.impactOccurred()
                        //self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.Today)
                        solveHandler.updateSolves(to: .Today)
                    }) {
                        ZStack {
                            Text("1D")
                                .font(Font.custom("Chivo-Bold", size: 16))
                                .offset(x: 2)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 100)
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.Week) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                           // self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.Week)
                            solveHandler.updateSolves(to: .Week)
                        }) {
                            ZStack {
                                Text("1W")
                                    .font(Font.custom("Chivo-Bold", size: 16))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.OneMonth) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                            //self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.OneMonth)
                            solveHandler.updateSolves(to: .OneMonth)
                        }) {
                            ZStack {
                                Text("1M")
                                    .font(Font.custom("Chivo-Bold", size: 16))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.ThreeMonths) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                            //self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.ThreeMonths)
                            solveHandler.updateSolves(to: .ThreeMonths)
                        }) {
                            ZStack {
                                Text("3M")
                                    .font(Font.custom("Chivo-Bold", size: 16))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    if solveHandler.solvesByTimeFrame.getApplicableTimeframes().contains(.Year) { // guard to check if solves in timeframe exist
                        Button(action: {
                            lightTap.impactOccurred()
                            //self.solveHandler.currentTimeframeButtonPos = getIndexOfTfButton(.Year)
                            solveHandler.updateSolves(to: .Year)
                        }) {
                            ZStack {
                                Text("1Y")
                                    .font(Font.custom("Chivo-Bold", size: 16))
                                    .foregroundColor(.white)
                            }
                            .frame(width: 35, height: 100)
                        }
                    }
                    
                    Button(action: {
                        lightTap.impactOccurred()
                        //self.solveHandler.currentTimeframeButtonPos = Int(CGFloat((solveHandler.solvesByTimeFrame.getApplicableTimeframes().count - 1))) // the count is the total of solveHandler.getApplicabletimeFrames().count + ( -1 )
                        solveHandler.updateSolves(to: .All)
                    }) {
                        ZStack {
                            Text("ALL")
                                .font(Font.custom("Chivo-Bold", size: 16))
                                .foregroundColor(.white)
                                .offset(x: 1)
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
    
    
    
}

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

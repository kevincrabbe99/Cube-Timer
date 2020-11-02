//
//  TopBar.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI

class SelectedPos: ObservableObject {
    @Published var selectedPos: CGFloat = 0
    init(_ pos: CGFloat) {
        selectedPos = pos
    }
    func set(_ pos: CGFloat) {
        selectedPos = pos
    }
    func set(_ pos: Timeframe) {
        switch pos {
        case .LastThree:
            self.selectedPos = 0
        case .Today:
            self.selectedPos = 1
        case .OneMonth:
            self.selectedPos = 2
        case .ThreeMonths:
            self.selectedPos = 3
        case .Year:
            self.selectedPos = 4
        case .All:
            self.selectedPos = 5
        default:
            self.selectedPos = 1
        }
        print("selectedPos ", selectedPos)
    }
}

struct TopBar: View {
    
    @ObservedObject var solveHandler: SolveHandler
    
    @State var selectedPos: CGFloat = 1
    
    //var selectedTimeFrame: Int = 0
    //var timeFrames: [STDButton] = []
    
    init(sh: SolveHandler) {
        self.solveHandler = sh
        /*
        timeFrames = [ STDButton(label: .LastThree, id: 0, selection: selectedPos, parent: self),
                       STDButton(label: .Today, id: 1, selection: selectedPos, parent: self),
                       STDButton(label: .OneMonth, id: 2, selection: selectedPos, parent: self),
                       STDButton(label: .ThreeMonths, id: 3, selection: selectedPos, parent: self),
                       STDButton(label: .Year, id: 4, selection: selectedPos, parent: self),
                       STDButton(label: .All, id: 5, selection: selectedPos, parent: self)]
        */
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
                    .opacity(0.65)
                
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 35, height: 25)
                    .foregroundColor(.white)
                    .position( x: 42.5, y: 12.5 )
                    .offset(x: selectedPos * 55)
                    .animation(.default)
                
                HStack(spacing: 20.0) {
                    
                    /*
                    ForEach(timeFrames, id: \.id) { btn in
                        btn
                    }
                    */
                    
                    Button(action: {
                        self.selectedPos = 0
                        solveHandler.currentTimeframe = .LastThree
                    }) {
                        ZStack {
                            Text("3X")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 25)
                    }
                    
                    Button(action: {
                        self.selectedPos = 1
                        solveHandler.currentTimeframe = .Today
                    }) {
                        ZStack {
                            Text("1D")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 25)
                    }
                    
                    Button(action: {
                        self.selectedPos = 2
                        solveHandler.currentTimeframe = .OneMonth
                    }) {
                        ZStack {
                            Text("1M")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 25)
                    }
                    
                    Button(action: {
                        self.selectedPos = 3
                        solveHandler.currentTimeframe = .ThreeMonths
                    }) {
                        ZStack {
                            Text("3M")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 25)
                    }
                    
                    Button(action: {
                        self.selectedPos = 4
                        solveHandler.currentTimeframe = .Year
                    }) {
                        ZStack {
                            Text("1Y")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 25)
                    }
                    
                    Button(action: {
                        self.selectedPos = 5
                        solveHandler.currentTimeframe = .All
                    }) {
                        ZStack {
                            Text("ALL")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: 35, height: 25)
                    }
                    
                }
            }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .frame(width: 360)
        }
        .frame(width: 400, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}

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
        TopBar(sh: SolveHandler())
            .previewLayout(.fixed(width: /*@START_MENU_TOKEN@*/400.0/*@END_MENU_TOKEN@*/, height: 25))
    }
}

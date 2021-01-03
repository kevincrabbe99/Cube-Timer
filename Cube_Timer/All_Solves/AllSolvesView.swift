//
//  AllSolvesView.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/28/20.
//

import SwiftUI

struct AllSolvesView: View {
    
    /*
    var parent: ContentView
    var solvesData: SolvesFromTimeframe
 `` */
    
    @EnvironmentObject var cvc: ContentViewController
    @EnvironmentObject var controller: AllSolvesController
    
    var parent: ContentView
    //var controller: AllSolvesController
    
    let gradient = Gradient(colors: [.init("very_dark_black"), .init("dark_black")])
    
    // solves grid stuff
   // var solvesGridController: SolvesGridController
 
    
    func gotoPage(_ p: Page) {
        cvc.setPageTo(p)
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                
                Color.black
                Rectangle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .opacity(0.6)
                    .gesture ( // gesture for transitioning to allSolvesView
                        DragGesture()
                            .onChanged { value in
                                cvc.dragChanged(value)
                            }
                            .onEnded { value in
                                cvc.dragEnded(value)
                            }
                    )
                
                /*
                 *  outer stack contains 2 cells left and right
                 */
                HStack {
                    
                    /*
                     *  verticle list with all sidebar elements
                     */
                    VStack {
                        
                   
                            
                        VStack(alignment:.trailing) {
                            Text(controller.cTypeHandler.selected.name)
                                //.font(.system(size: 30))
                                .font(Font.custom("Play-Bold", size: 33))
                                //.fontWeight(.black)
                                .tracking(5)
                                .offset(x: 5)
                            Text(controller.cTypeHandler.selected.descrip)
                                .font(Font.custom("Play-Regular", size: 15))
                                // .font(.system(size: 12))
                                //.fontWeight(.bold)
                                .opacity(0.75)
                        }.frame(width: 150, alignment: .trailing)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        StatLabelVertical(label: "BEST", solve: controller.best)
                        
                        Spacer()
                        
                        StatLabelVertical(label: "WORST", solve: controller.worst)
                        
                        Spacer()
                        
                        StatLabelVertical(label: "MEDIAN", value: controller.median)
                            
                        
                        
 
                        
                        
                        
                    }// end sidebar vstack
                    .frame(width: 150, height: geo.size.height, alignment: .top)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    
                    
                    /*
                     *  vertical list w 2 cells, top bar and bottom solvesView
                     */
                    VStack(spacing: 0.0) {
                        
                        /*
                         *  hStack with topBar stats
                         */
                        HStack {
                                
                            
                            if !(controller.selected.count > 0) { // if there are no selected solves
                                
                                StatLabelHorizontal(label: "SOLVES", value: Double(controller.count ?? 0), showDecimal: false)
                                StatLabelHorizontal(label: "AVERAGE", value: Double(controller.average ?? 0))
                                StatLabelHorizontal(label: "STD. DEV", value: Double(controller.stdDev ?? -1))
                      
                            } else {
                                
                                
                                EditSolvesBarView()
                                    .frame(width: geo.size.width - 400)
                                
                                
                            } // end if
                         
                        }
                        .frame(height: 30, alignment: .trailing)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.trailing, 60)
                        
                        
                        /*
                         *  the main view with all the solves
                         */
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.init("very_dark_black"))
                                .innerShadow(color: Color.black.opacity(0.15), radius: 0.05)
                                .mask(RoundedRectangle(cornerRadius: 10))
                                .opacity(0.3)
                            
                            
                            ScrollView {
                                LazyVStack {
                                    Group {
                                        TimeGroupView(controller: controller.tgControllerToday)
                                            .frame(height: controller.tgControllerToday.height)
                                        TimeGroupView(controller: controller.tgControllerYesterday)
                                            .frame(height: controller.tgControllerYesterday.height)
                                        TimeGroupView(controller: controller.tgControllerThisWeek)
                                            .frame(height: controller.tgControllerThisWeek.height)
                                        TimeGroupView(controller: controller.tgControllerThisMonth)
                                            .frame(height: controller.tgControllerThisMonth.height)
                                        TimeGroupView(controller: controller.tgControllerLastMonth)
                                            .frame(height: controller.tgControllerLastMonth.height)
                                    }
                                    
                                    Group {
                                        TimeGroupView(controller: controller.tgControllerJan)
                                            .frame(height: controller.tgControllerJan.height)
                                        TimeGroupView(controller: controller.tgControllerFeb)
                                            .frame(height: controller.tgControllerFeb.height)
                                        TimeGroupView(controller: controller.tgControllerMar)
                                            .frame(height: controller.tgControllerMar.height)
                                    }
                                    Group {
                                        TimeGroupView(controller: controller.tgControllerApr)
                                            .frame(height: controller.tgControllerApr.height)
                                        TimeGroupView(controller: controller.tgControllerMay)
                                            .frame(height: controller.tgControllerMay.height)
                                        TimeGroupView(controller: controller.tgControllerJun)
                                            .frame(height: controller.tgControllerJun.height)
                                    }
                                    Group {
                                        TimeGroupView(controller: controller.tgControllerJul)
                                            .frame(height: controller.tgControllerJul.height)
                                        TimeGroupView(controller: controller.tgControllerAug)
                                            .frame(height: controller.tgControllerAug.height)
                                        TimeGroupView(controller: controller.tgControllerSep)
                                            .frame(height: controller.tgControllerSep.height)
                                    }
                                    Group {
                                        TimeGroupView(controller: controller.tgControllerOct)
                                            .frame(height: controller.tgControllerOct.height)
                                        TimeGroupView(controller: controller.tgControllerNov)
                                            .frame(height: controller.tgControllerNov.height)
                                        TimeGroupView(controller: controller.tgControllerDec)
                                            .frame(height: controller.tgControllerDec.height)
                                    }
                                    
                                }
                              //  .frame(width: 300, height: 200, alignment: <#T##Alignment#>)
                            }
                            .padding(20)
                        }
                        //.padding(.top, 20)
                        .padding(.leading, 20)
                        .padding(.trailing, 40)
                        .padding(.bottom, 30)
                    }
                    
                } // end main hStack
            
            } // end main ZStack, no more color
            
            
        }
        
        
        
        /*
        GeometryReader { geo in
            ZStack {
                Color.init("very_dark_black")
                
                
                
                
                
                ScrollView {
                    VStack {
                        ForEach (solveHandler.solves) { s in
                            Button(action: {
                                self.deleteFromCell(s)
                            }, label: {
                                HStack {
                                    Text( s.getTimeCapture()?.getAsReadable() ?? "-" )
                                    Spacer()
                                    Text( s.getDateString() )
                                    
                                }
                            })
                            Spacer()
                        }
                    }
                    .frame(width: 300)
                }
                
                HStack {
                    Button(action: {
                        gotoPage(.Main)
                    }, label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                    })
                }
                .frame(width: geo.size.width, alignment: .leading)
                .foregroundColor(.white)
                
                
            }
                
        }
         */
    }
    
    func deleteFromCell(_ s: SolveItem) {
        print("should delete \(s.timeMS)")
        //controller.solvesData.delete(s)
    }
    
}

struct AllSolvesView_Previews: PreviewProvider {
    static var previews: some View {
      //  AllSolvesView(parent: ContentView(), solvesData: SolvesFromTimeframe(), solvesGridController: SolvesGridController())
        AllSolvesView(parent: ContentView())
                .previewLayout(.fixed(width: 2436 / 3.0, height: 1125 / 3.0))
    }
}


/*
 * INSET SHADOW RESOURCES
 */
extension View {
    func innerShadow(color: Color, radius: CGFloat = 0.1) -> some View {
        modifier(InnerShadow(color: color, radius: min(max(0, radius), 1)))
    }
}

private struct InnerShadow: ViewModifier {
    var color: Color = .gray
    var radius: CGFloat = 0.1

    private var colors: [Color] {
        [color.opacity(0.75), color.opacity(0.0), .clear]
    }

    func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .overlay(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .top, endPoint: .bottom)
                    .frame(height: self.radius * self.minSide(geo)),
                         alignment: .top)
                .overlay(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .bottom, endPoint: .top)
                    .frame(height: self.radius * self.minSide(geo)),
                         alignment: .bottom)
                .overlay(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .leading, endPoint: .trailing)
                    .frame(width: self.radius * self.minSide(geo)),
                         alignment: .leading)
                .overlay(LinearGradient(gradient: Gradient(colors: self.colors), startPoint: .trailing, endPoint: .leading)
                    .frame(width: self.radius * self.minSide(geo)),
                         alignment: .trailing)
        }
    }

    func minSide(_ geo: GeometryProxy) -> CGFloat {
        CGFloat(3) * min(geo.size.width, geo.size.height) / 2
    }
}

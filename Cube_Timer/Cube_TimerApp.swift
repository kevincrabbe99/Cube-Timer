//
//  Cube_TimerApp.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 10/19/20.
//

import SwiftUI
import CoreData

@main
struct Cube_TimerApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let persistanceContainer = PersistenceController.shared
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
            
        }
    }
}

struct Cube_TimerApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}

//
//  AppDelegate.swift
//  Cube Timer
//
//  Created by Kevin Crabbe on 1/17/21.
//

import Foundation
import SwiftUI
import UIKit
import Firebase

//@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        print("didFinishLaunchingWithOptions")
        
        FirebaseApp.configure()
        
        return true
    }
}

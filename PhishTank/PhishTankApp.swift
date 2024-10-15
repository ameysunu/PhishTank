//
//  PhishTankApp.swift
//  PhishTank
//
//  Created by Amey Sunu on 05/10/2024.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct PhishTankApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}

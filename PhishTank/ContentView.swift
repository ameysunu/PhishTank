//
//  ContentView.swift
//  PhishTank
//
//  Created by Amey Sunu on 05/10/2024.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    var body: some View {
        SignView()
            .onAppear {
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    if(user?.userID != nil){
                        print("User is logged in")
                    } else {
                        print("User is logged out")
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}

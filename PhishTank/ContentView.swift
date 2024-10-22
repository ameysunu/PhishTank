//
//  ContentView.swift
//  PhishTank
//
//  Created by Amey Sunu on 05/10/2024.
//

import SwiftUI
import GoogleSignIn

struct ContentView: View {
    
    @State var isUserSignedIn: Bool = false
    @State var currentUser: GIDGoogleUser?
    
    var body: some View {
        Group{
            if isUserSignedIn {
                HomeView(user: currentUser)
            } else {
                SignView()
            }
        }
            .onAppear{
                GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                    if(user?.userID != nil){
                        print("User is logged in")
                        currentUser = user
                        self.isUserSignedIn = true
                    } else {
                        print("User is logged out")
                        self.isUserSignedIn = false
                    }
                }
            }
    }
}

#Preview {
    ContentView()
}

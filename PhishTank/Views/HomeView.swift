//
//  HomeView.swift
//  PhishTank
//
//  Created by Amey Sunu on 19/10/2024.
//

import SwiftUI
import GoogleSignIn

struct HomeView: View {
    
    var user: GIDGoogleUser?
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Hello, \(user?.profile?.name ?? "User")")
                .font(.title)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}

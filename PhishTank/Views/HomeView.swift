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
    
    let items: [(String, String)] = [("Phishing", "Check for phishing texts or emails"), ("Breaches", "Check if your email has been in a potential breach"), ("Recents", "Your recent activities")]
    let columns = [
           GridItem(.flexible()),
           GridItem(.flexible()),
           GridItem(.flexible())
       ]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Hello, \(user?.profile?.name ?? "User")")
                .font(.title)
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items, id: \.0){ item in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.25))
                            VStack (alignment: .leading, spacing: 5){
                                Text(item.0)
                                    .font(.title)
                                    .foregroundColor(.white)
                                Text(item.1)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding()
            Spacer()
            
            HStack{
                    Image("Gemini")
                        .resizable()
                        .frame(width: 75, height: 46.375)
                
                Text("Results generated with Google Gemini")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}

#Preview {
    HomeView()
}

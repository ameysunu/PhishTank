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
    
    let items: [(String, String, SheetType)] = [("Phishing", "Check for phishing texts or emails", .phishing), ("Breaches", "Check if your email has been in a potential breach", .breach), ("Recents", "Your recent activities", .recents)]
    
    let columns = [
           GridItem(.flexible()),
           GridItem(.flexible()),
           GridItem(.flexible())
       ]
    
    @State private var selectedItem: SheetType? = nil
    
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
                        .onTapGesture {
                            selectedItem = item.2
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
        .sheet(item: $selectedItem) { item in
            item.view
        }
    }
}

enum SheetType: Identifiable {
    case phishing, breach, recents
    
    var id: Int {
        hashValue
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .phishing:
            Phishing()
        case .breach:
            Phishing()
        case .recents:
            Phishing()
        }
    }
}

#Preview {
    HomeView()
}

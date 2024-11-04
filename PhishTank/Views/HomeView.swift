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
    @AppStorage("enableMonitoring") private var enableMonitoring: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text("Hello, \(user?.profile?.name ?? "User")")
                    .font(.title)
                Spacer()
                Button(action:{
                    selectedItem = .security
                }){
                    Text("Security Recommendations")
                }
                Button(action:{
                    GIDSignIn.sharedInstance.signOut()
                }){
                    Text("Logout")
                }
            }
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
                
                Spacer()
                
                if(enableMonitoring){
                    Button(action:{
                        selectedItem = .monitoring
                    }){
                        Image(systemName: "chart.xyaxis.line")
                    }
                }
            }
        }
        .padding()
        .sheet(item: $selectedItem) { item in
            item.view(dismiss: {
                selectedItem = nil
            })
        }
    }
}

enum SheetType: Identifiable {
    case phishing
    case breach
    case recents
    case security
    case monitoring

    var id: Int {
        self.hashValue
    }
    
    @ViewBuilder
    func view(dismiss: @escaping () -> Void) -> some View {
        switch self {
        case .phishing:
            Phishing(dismiss: dismiss)
        case .breach:
            Breach(dismiss: dismiss)
        case .recents:
            Recents(dismiss: dismiss)
        case .security:
            SecurityView(dismiss: dismiss)
        case .monitoring:
            MonitoringView(dismiss: dismiss)
        }
    }
}


#Preview {
    HomeView()
}

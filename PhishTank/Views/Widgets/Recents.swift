//
//  Recents.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI
import  FirebaseFirestore
import GoogleSignIn

struct Recents: View {
    var currentUser: GIDGoogleUser?
    var dismiss: () -> Void
    @ObservedObject private var viewModel = UserViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Text("Recents")
                    .font(.title)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Close")
                }
            }
            .padding()
            
            TabView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.phishData, id: \.id) { data in
                            DataRow(data: data)
                        }
                    }
                    .padding()
                }

                    .tabItem {
                        Label("Phish Data", systemImage: "list.dash")
                    }

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.breachData, id: \.id) { data in
                            DataRow(data: data)
                        }
                    }
                    .padding()
                }
                    .tabItem {
                        Label("Breach Data", systemImage: "square.and.pencil")
                    }
            }
            
        }
        .onAppear {
            viewModel.initializeDataFetching()
        }
    }
}


struct DataRow: View {
    var data: RecentData

    var body: some View {
        VStack(alignment: .leading) {
            Text("Text Value: \(data.textValue)")
            Text("Gemini Result: \(data.geminiResult)")
            Text("Type: \(data.type ? "True" : "False")")
            Divider()
        }
        .padding(.vertical, 4)
        
    }
}

class UserViewModel: ObservableObject {
    @Published var phishData: [RecentData] = []
    @Published var breachData: [RecentData] = []
    private var db = Firestore.firestore()
    private var googleID: String?
    
    func getGoogleSignIn(completion: @escaping () -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user, error == nil {
                self.googleID = user.userID
                print("Google ID retrieved: \(self.googleID ?? "No ID")")
                completion()
            } else {
                print("Error retrieving Google user: \(error?.localizedDescription ?? "Unknown error")")
                completion()
            }
        }
    }
    
    func fetchPhishData() {
        guard let googleID = self.googleID else {
            print("No Google user ID found!")
            return
        }
        
        print("Fetching phish data for googleID: \(googleID)")
        
        db.collection("phishtank-phish-data").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found!")
                return
            }
            
            // Update on the main thread
            DispatchQueue.main.async {
                self.phishData = documents.compactMap { doc in
                    let docIDPrefix = doc.documentID.split(separator: "-").first ?? ""
                    
                    if docIDPrefix == googleID {
                        print("Matched Google ID: \(googleID) with document ID prefix: \(docIDPrefix)")
                        do {
                            return try doc.data(as: RecentData.self)
                        } catch {
                            print("Error decoding document: \(error)")
                        }
                    }
                    return nil
                }
                print("Fetched \(self.phishData.count) phish data documents.")
            }
        }
    }
    
    func fetchBreachData() {
        guard let googleID = self.googleID else {
            print("No Google user ID found!")
            return
        }
        
        print("Fetching breach data for googleID: \(googleID)")
        
        db.collection("phishtank-breach-data").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No documents found!")
                return
            }
            
            // Update on the main thread
            DispatchQueue.main.async {
                self.breachData = documents.compactMap { doc in
                    let docIDPrefix = doc.documentID.split(separator: "-").first ?? ""
                    
                    if docIDPrefix == googleID {
                        do {
                            return try doc.data(as: RecentData.self)
                        } catch {
                            print("Error decoding document: \(error)")
                        }
                    }
                    return nil
                }
                print("Fetched \(self.phishData.count) phish data documents.")
            }
        }
    }
    
    func initializeDataFetching() {
        getGoogleSignIn {
            self.fetchPhishData()
            self.fetchBreachData()
        }
    }
}



struct RecentData: Identifiable, Codable {
    var id: String
    var textValue: String
    var geminiResult: String
    var type: Bool
}

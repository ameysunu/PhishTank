//
//  Recents.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI
import  FirebaseFirestore
import GoogleSignIn
import FirebaseAuth

struct Recents: View {
    var currentUser: GIDGoogleUser?
    var firebaseUser: User?
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
    private var firebaseUid: String?
    
    
    func checkIsUserSignedIn(completion: @escaping(Bool) -> Void){
        getGoogleSignIn { success in
            if(!success){
                self.getFirebaseUserSignIn{ fbSuccess in
                    if(fbSuccess){
                        completion(true)
                    }
                    completion(false)
                }
            }
            completion(true)
        }
    }
    
    func getGoogleSignIn(completion: @escaping (Bool) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user = user, error == nil {
                self.googleID = user.userID
                print("Google ID retrieved: \(self.googleID ?? "No ID")")
                completion(true)
            } else {
                print("Error retrieving Google user: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
            }
        }
    }
    
    func getFirebaseUserSignIn(completion: @escaping (Bool) -> Void){
        let user = FirebaseAuth.Auth.auth().currentUser
        if(user != nil){
            firebaseUid = user?.uid
            completion(true)
        } else {
            print("User sign in failed")
            completion(false)
        }
    }
    
    func fetchPhishData() {
        var userId = ""
        
        if (googleID != nil) {
            userId = googleID!
            
        } else {
            print("No google user found")
            
            if( firebaseUid != nil ){
                print("No firebase user found")
                userId = firebaseUid!
            }
        }
        
        if(userId.isEmpty){
            return
        }
        
        print("Fetching phish data for googleID: \(userId)")
        
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
                    
                    if docIDPrefix == userId {
                        print("Matched User ID: \(userId) with document ID prefix: \(docIDPrefix)")
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
        var userId = ""
        
        if (googleID != nil) {
            userId = googleID!
            
        } else {
            print("No google user found")
            
            if( firebaseUid != nil ){
                print("No firebase user found")
                userId = firebaseUid!
            }
        }
        
        if(userId.isEmpty){
            return
        }
        
        print("Fetching breach data for googleID: \(userId)")
        
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
                    
                    if docIDPrefix == userId {
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
        checkIsUserSignedIn{ success in
            if(success){
                self.fetchPhishData()
                self.fetchBreachData()
            }
        }
    }
}



struct RecentData: Identifiable, Codable {
    var id: String
    var textValue: String
    var geminiResult: String
    var type: Bool
}

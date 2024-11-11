//
//  MonitoringView.swift
//  PhishTank
//
//  Created by Amey Sunu on 04/11/2024.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

struct MonitoringView: View {
    
    var dismiss: () -> Void
    @ObservedObject private var viewModel = MonitoringViewModel()
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
            HStack{
                
                Text("Monitoring")
                    .font(.title)
                Spacer()
                Button(action:{
                    dismiss()
                }){
                    Text("Close")
                }
                
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.monitoringData, id: \.id) { data in
                        MonitorDataRow(data: data)
                    }
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            viewModel.initializeDataFetching()
        }
    }
}


struct MonitorDataRow: View {
    var data: MonitoringData

    var body: some View {
        VStack(alignment: .leading) {
            Text(data.textValue)
                .font(.subheadline)
            Divider()
        }
        .padding(.vertical, 4)
        
    }
}

class MonitoringViewModel: ObservableObject {
    @Published var monitoringData: [MonitoringData] = []
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
    
    func fetchMonitorData() {
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
        
        db.collection("phishtank-monitoring-data").getDocuments { (snapshot, error) in
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
                self.monitoringData = documents.compactMap { doc in
                    let docIDPrefix = doc.documentID.split(separator: "-").first ?? ""
                    
                    if docIDPrefix == userId {
                        print("Matched User ID: \(userId) with document ID prefix: \(docIDPrefix)")
                        do {
                            return try doc.data(as: MonitoringData.self)
                        } catch {
                            print("Error decoding document: \(error)")
                        }
                    }
                    return nil
                }
            }
        }
    }
    
    
    func initializeDataFetching() {
        checkIsUserSignedIn{ success in
            if(success){
                self.fetchMonitorData()
            }
        }
    }
}


struct MonitoringData: Identifiable, Codable {
    var id: UUID
    var textValue: String
}

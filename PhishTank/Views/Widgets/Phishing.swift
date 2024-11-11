//
//  Phishing.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct Phishing: View {
    var dismiss: () -> Void
    @State private var inputText: String = ""
    
    let _geminiController = GeminiController()
    @State private var isLoading = false
    @State private var geminiResponse: String = ""
    @State private var phishingFactor: String = ""
    
    @State private var phishValue: String = ""
    @State private var phishColor: Color = .secondary

    var body: some View {
        VStack (alignment: .leading){
            HStack{
                
                Text("Phishing")
                    .font(.title)
                Spacer()
                Button(action:{
                    dismiss()
                }){
                    Text("Close")
                }
                
            }
            
            Text("Enter contents of an email or message that you think might be a phishing attempt.")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if(geminiResponse.isEmpty){
                
                TextEditor(text: $inputText)
                    .frame(height: 300)
                    .font(.caption)
                    .padding()
                
                Button(action:{
                    Task{
                        isLoading = true
                        let results = await _geminiController.sendPhishingRequest(prompt: inputText)
                        geminiResponse = results.result
                        phishValue = results.phishingFactor ?? "0"
                        
                        
                        let phishFactor = _geminiController.checkPhishingLevel(phishingFactor: results.phishingFactor ?? "")
                        phishingFactor =  phishFactor.type
                        phishColor = phishFactor.color
                        
                        if(!geminiResponse.isEmpty){
                            isLoading = false
                        }
                    }
                }){
                    if(isLoading){
                        Text("Analyzing...")
                    } else {
                        Text("Analyze")
                    }
                }
                .disabled(isLoading)
            } else {
                
                VStack(alignment: .leading, spacing: 5){
                    Text(phishingFactor)
                        .font(.title2)
                        .foregroundColor(phishColor)
                    
                    
                    HStack(spacing: 2) {
                        ForEach(0 ..< 10) { index in
                            Rectangle()
                                .foregroundColor(index < Int(phishValue) ?? 0 ? phishColor : Color.secondary.opacity(0.3))
                        }
                    }
                    .frame(maxHeight: 10)
                    .clipShape(Capsule())
                    
                    Text(geminiResponse)
                }
                .padding()
            }
        }
        .onAppear{
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if(user?.userID != nil){
                    _geminiController.user = user
                } else {
                    _geminiController.firebaseUser = FirebaseAuth.Auth.auth().currentUser
                }
            }
        }
        .padding()
    }
}

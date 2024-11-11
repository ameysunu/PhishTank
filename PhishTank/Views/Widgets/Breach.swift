//
//  Breach.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct Breach: View {
    var dismiss: () -> Void
    var _widController = WidgetController()
    var _geminiController = GeminiController()
    @State var email: String = ""
    @State var isLoading: Bool = false
    @State var breachData: [BreachAnalyticsResponse.ExposedBreaches.BreachDetail]? = []
    @State var isResponse: Bool = false
    @State var breachMeasures: String = ""
    @State var isBreachMeasureClicked: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
            HStack{
                
                Text("Breach")
                    .font(.title)
                Spacer()
                Button(action:{
                    dismiss()
                }){
                    Text("Close")
                }
                
            }
            
            if(!isResponse){
                
                TextField("Email Address", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                
                Button(action:{
                    isLoading = true
                    Task{
                        await breachData = _widController.checkForEmailBreach(email: email)
                        isResponse = true
                    }
                }){
                    if(isLoading){
                        Text ("Checking...")
                    } else {
                        Text("Check")
                    }
                }
                .disabled(isLoading)
            } else {
                
                if(breachData == nil){
                    Text("Congrats! No breaches have been detected on your email address")
                        .font(.title2)
                        .foregroundStyle(.green)
                } else {
                    
                    if(!breachMeasures.isEmpty){
                        
                        ScrollView{
                            
                            Text(breachMeasures)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                    } else {
                        
                        Text("Ohh no! Breaches have been detected on your email address")
                            .font(.title2)
                            .foregroundStyle(.red)
                        
                        ScrollView{
                            ForEach(breachData!, id: \.breach){ item in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.gray.opacity(0.25))
                                    HStack{
                                        AsyncImage(url: URL(string: item.logo ?? "https://upload.wikimedia.org/wikipedia/commons/5/53/Sheba1.JPG")) { image in
                                            image
                                                .resizable()
                                                .clipShape(Circle())
                                                .overlay {
                                                    Circle().stroke(Color.white, lineWidth: 4)
                                                }
                                                .shadow(radius: 7)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 100)
                                        .padding()
                                        
                                        VStack (alignment: .leading, spacing: 5){
                                            Text(item.breach!)
                                                .font(.title)
                                                .foregroundColor(.white)
                                            Text(item.details!)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            
                                            HStack{
                                                Text(item.domain!)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                                Spacer()
                                                Text("Exposed Date: \(item.xposed_date!)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                        .padding()
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        Button(action: {
                            Task {
                                var breachDetails = ""
                                
                                for data in breachData! {
                                    breachDetails.append(data.details!)
                                }
                                
                                breachMeasures = await _geminiController.getBreachMeasures(prompt: breachDetails)
                                print(breachMeasures)
                            }
                        }){
                            Text("Learn how to make your account more secure")
                        }
                        
                    }
                    
                    Button(action:{
                        isResponse = false
                        isLoading = false
                    }){
                        Text("Check another email")
                    }
                }
            }
            
        }
        .onAppear{
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                if(user?.userID != nil){
                    _widController.user = user
                } else {
                    _widController.firebaseUser = FirebaseAuth.Auth.auth().currentUser
                }
            }
        }
        .padding()
    }
}

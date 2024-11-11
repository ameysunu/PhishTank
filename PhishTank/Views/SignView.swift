//
//  SignView.swift
//  PhishTank
//
//  Created by Amey Sunu on 07/10/2024.
//

import SwiftUI

struct SignView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @State private var registerToggled: Bool = false
    @State private var isLoggedIn: Bool = false
    
   let _auth = Authentication()
    
    var body: some View {
        if isLoggedIn {
            HomeView()
        } else {
            HStack{
                VStack(alignment: .leading){
                    Text("Welcome to Phish Tank!")
                        .font(.title)
                    TextField("Email Address", text: $email)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                    SecureField("Password", text: $password)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                    Button("Sign In"){
                        let validator = _auth.emailPasswordValidator(email: email, password: password)
                        
                        if(validator.1){
                            _auth.signIn(email: email, password: password) { result, isSuccess in
                                if(isSuccess){
                                    print("Success - \(result))")
                                    isLoggedIn = true
                                } else {
                                    print(result)
                                    message = result
                                    showAlert.toggle()
                                }
                            }
                        } else {
                            message = validator.0
                            showAlert.toggle()
                        }
                    }
                    
                    Divider()
                        .padding()
                    
                    Button("Sign in with Google"){
                        _auth.googleSignIn { result in
                            if(result){
                                isLoggedIn = true
                            }
                        }
                    }
                    
                    Text("Don't have an account? Create now")
                        .font(.title3)
                        .padding(.top)
                        .onTapGesture {
                            registerToggled = true
                        }
                }
                
                Rectangle()
                    .frame(width: 1, height: 100)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                VStack(alignment: .leading){
                    HStack {
                        Image("FirebaseAuthentication")
                            .resizable()
                            .frame(width: 90, height: 81.75)
                        
                        Image("GoogleIAM")
                            .resizable()
                            .frame(width: 68, height: 68)
                    }
                    
                    Text("Authentication Powered by Firebase and Google Identity Platform")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                }
                
            }
            .padding()
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Warning"),
                    message: Text(message),
                    dismissButton: .default(Text("Ok"))
                )
            }
            .sheet(isPresented: $registerToggled) {
                RegisterView(isPresented: $registerToggled)
            }
        }
    }
}

#Preview {
    SignView()
}

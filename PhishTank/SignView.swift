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
    
   let _auth = Authentication()
    
    var body: some View {
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
                    
                }
                
                Text("Don't have an account? Create now")
                    .font(.title3)
                    .padding(.top)
            }
            
            Rectangle()
                .frame(width: 1, height: 100)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            VStack{
                
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
    }
}

#Preview {
    SignView()
}

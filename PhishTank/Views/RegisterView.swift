//
//  SignView.swift
//  PhishTank
//
//  Created by Amey Sunu on 14/10/2024.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var message: String = ""
    @Binding var isPresented: Bool
    
   let _auth = Authentication()
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Register an account")
                    .font(.title)
                TextField("Email Address", text: $email)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                SecureField("Password", text: $password)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                SecureField("Confirm Password", text: $confirmPassword)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disableAutocorrection(true)
                Button("Register"){
                   let validator = _auth.emailPasswordValidator(email: email, password: password)
                    
                    if(validator.1){
                        _auth.registerUser(email: email, password: password, confirmPassword: confirmPassword) { result, isSuccess in
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
                
                Button("Sign up with Google"){
                    
                }
                
                Text("Have an account? Sign in now")
                    .font(.title3)
                    .padding(.top)
                    .onTapGesture {
                        isPresented = false
                    }
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

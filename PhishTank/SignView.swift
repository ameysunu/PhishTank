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
    }
}

#Preview {
    SignView()
}

//
//  Breach.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI

struct Breach: View {
    var dismiss: () -> Void
    var _widController = WidgetController()
    @State var email: String = ""
    
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
            
            TextField("Email Address", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
            
            Button(action:{
                Task{
                   await _widController.checkForEmailBreach(email: email)
                }
            }){
                Text("Check")
            }

            
        }
        .padding()
    }
}

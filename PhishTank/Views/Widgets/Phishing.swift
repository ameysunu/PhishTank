//
//  Phishing.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI

struct Phishing: View {
    var dismiss: () -> Void
    @State private var inputText: String = ""

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
            
            TextEditor(text: $inputText)
                 .frame(height: 300)
                 .font(.caption)
                 .padding()
            
            Button(action:{
                dismiss()
            }){
                Text("Analyze")
            }
        }
        .padding()
    }
}

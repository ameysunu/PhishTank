//
//  Phishing.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI

struct Phishing: View {
    var dismiss: () -> Void
    var body: some View {
        VStack{
            HStack{
                
                Text("Phishing")
                Spacer()
                Button(action:{
                    dismiss()
                }){
                    Text("Close")
                }
                
            }
        }
        .padding()
    }
}

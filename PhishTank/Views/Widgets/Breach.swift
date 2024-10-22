//
//  Breach.swift
//  PhishTank
//
//  Created by Amey Sunu on 22/10/2024.
//

import SwiftUI

struct Breach: View {
    var dismiss: () -> Void
    var body: some View {
        VStack{
            HStack{
                
                Text("Breach")
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

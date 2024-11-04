//
//  MonitoringView.swift
//  PhishTank
//
//  Created by Amey Sunu on 04/11/2024.
//

import SwiftUI

struct MonitoringView: View {
    
    var dismiss: () -> Void
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
            HStack{
                
                Text("Monitoring")
                    .font(.title)
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

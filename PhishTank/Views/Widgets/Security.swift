//
//  Security.swift
//  PhishTank
//
//  Created by Amey Sunu on 04/11/2024.
//

import SwiftUI
import GoogleSignIn

struct SecurityView: View {
    
    var dismiss: () -> Void
    @State private var enableMonitoring = false
    @State private var enableProactiveReminders = false
    @State private var breachDays: String = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10){
            HStack{
                
                Text("Personalized Security Recommendations")
                    .font(.title)
                Spacer()
                Button(action:{
                    dismiss()
                }){
                    Text("Close")
                }
                
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.25))
                
                    
                    VStack (alignment: .leading, spacing: 5){
                        HStack{
                            VStack(alignment: .leading){
                                Text("User Behavior Monitoring")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Monitor user behavior to identify and prevent phishing attempts.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            Toggle("", isOn: $enableMonitoring)
                                .toggleStyle(.switch)
                            
                        }
                        
                    }
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
            
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.25))
                
                    
                    VStack (alignment: .leading, spacing: 5){
                        HStack{
                            VStack(alignment: .leading){
                                Text("Proactive Reminders")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Send a reminder after a breach check is done after a certain period of time.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            
                            Toggle("", isOn: $enableProactiveReminders)
                                .toggleStyle(.switch)
                            
                        }
                        
                    }
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        
        .sheet(isPresented: $enableProactiveReminders) {
            VStack(alignment: .leading){
                Text("Enter how many days you want to wait before sending a reminder before a breach check")
                TextField("Days", text: $breachDays)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .disableAutocorrection(true)
                Button(action:{
                    dismiss()
                }){
                    Text("Done")
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}

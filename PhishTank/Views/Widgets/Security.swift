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
    @State private var enableMonitoring: Bool = UserDefaults.standard.bool(forKey: "enableMonitoring")
    @State private var enableProactiveReminders: Bool = UserDefaults.standard.bool(forKey: "enableProactiveReminders")
    @State private var breachDays: String = ""
    @State private var isSheetPresented: Bool = false
    
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
                                .onChange(of: enableMonitoring) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "enableMonitoring")
                                }
                            
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
                                .onChange(of: enableProactiveReminders) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "enableProactiveReminders")
                                    if newValue && !UserDefaults.standard.bool(forKey: "hasShownReminderSheet") {
                                        isSheetPresented = true
                                        UserDefaults.standard.set(true, forKey: "hasShownReminderSheet")
                                    }
                                }
                            
                        }
                        
                    }
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        
        .sheet(isPresented: $isSheetPresented) {
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

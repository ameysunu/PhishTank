//
//  Widgets.swift
//  PhishTank
//
//  Created by Amey Sunu on 27/10/2024.
//

import Foundation
import GoogleSignIn
import FirebaseAuth

class WidgetController {
    
    var user: GIDGoogleUser?
    var firebaseUser: User?
    
    func checkForEmailBreach(email: String) async -> [BreachAnalyticsResponse.ExposedBreaches.BreachDetail]? {
        let urlString = "https://api.xposedornot.com/v1/breach-analytics?email=\(email)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let response = try decoder.decode(BreachAnalyticsResponse.self, from: data)
            
            if let breaches = response.exposedBreaches?.breaches_details {
                breaches.forEach { breach in
                    print("Breach: \(breach.breach ?? "Unknown")")
                    print("Details: \(breach.details ?? "No details")")
                    print("Domain: \(breach.domain ?? "No domain")")
                    print("Industry: \(breach.industry ?? "No industry")")
                    print("Logo URL: \(breach.logo ?? "No logo URL")")
                    print("Password Risk: \(breach.password_risk ?? "No risk info")")
                    print("References: \(breach.references ?? "No references")")
                    print("Searchable: \(breach.searchable ?? "No info")")
                    print("Verified: \(breach.verified ?? "No info")")
                    print("Exposed Data: \(breach.xposed_data ?? "No data")")
                    print("Exposed Date: \(breach.xposed_date ?? "No date")")
                    print("Exposed Records: \(breach.xposed_records ?? 0)")
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

                let currentDateTime = Date()
                let formattedDateTime = dateFormatter.string(from: currentDateTime)
                
                var userId = ""
                if(user != nil){
                    userId = user?.userID ?? "DEFAULT"
                } else {
                    if(firebaseUser != nil){
                        userId = firebaseUser?.uid ?? "DEFAULT"
                    } else {
                        userId = "DEFAULT"
                    }
                }
                
                let payload = GCPPayload(
                    isBreach: true,
                    data: GCPPayloadData(
                        textValue: email, geminiResult: "Total Breaches: \(breaches.count)", type: true
                    ),
                    userId: "\(userId)-\(formattedDateTime)"
                )
                
                do {
                    try await saveBreachData(payload: payload)
                } catch {
                    print("Failed to send data")
                }
                
                return breaches
            } else {
                print("No exposed breaches found.")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

                let currentDateTime = Date()
                let formattedDateTime = dateFormatter.string(from: currentDateTime)
                
                
                var userId = ""
                if(user != nil){
                    userId = user?.userID ?? "DEFAULT"
                } else {
                    if(firebaseUser != nil){
                        userId = firebaseUser?.uid ?? "DEFAULT"
                    } else {
                        userId = "DEFAULT"
                    }
                }
                
                let payload = GCPPayload(
                    isBreach: true,
                    data: GCPPayloadData(
                        textValue: email, geminiResult: "No Breaches", type: false
                    ),
                    userId: "\(userId)-\(formattedDateTime)"
                )
                
                
                do {
                    try await saveBreachData(payload: payload)
                } catch {
                    print("Failed to send data")
                }
                
                return nil
            }
        } catch {
            print("Failed to fetch data: \(error)")
            return nil
        }
    }
    
    func saveBreachData(payload: GCPPayload) async throws {
        guard let GCP_ENDPOINT = getValueFromSecrets(forKey: "GCP_CLOUD_RUN_RECENTS_ENDPOINT"),
              let requestUrl = URL(string: "\(GCP_ENDPOINT)/sendrequest") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(payload)
            request.httpBody = jsonData
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                }
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            throw error
        }
    }

    
    func getValueFromSecrets(forKey key: String) -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return plist[key] as? String
        }
        return nil
    }
    

}


@propertyWrapper
struct UserDefault<T>{
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get {
            UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct GCPPayload: Codable{
    var isBreach: Bool
    var data: GCPPayloadData
    var userId: String
}

struct GCPPayloadData: Codable{
    var textValue: String
    var geminiResult: String
    var type: Bool
}

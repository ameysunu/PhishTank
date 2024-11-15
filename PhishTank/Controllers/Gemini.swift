//
//  Gemini.swift
//  PhishTank
//
//  Created by Amey Sunu on 23/10/2024.
//

import Foundation
import GoogleGenerativeAI
import SwiftUICore
import GoogleSignIn
import FirebaseAuth

class GeminiController {
    
    var user: GIDGoogleUser?
    var firebaseUser: User?
    
    func sendPhishingRequest(prompt: String) async -> (result: String, phishingFactor: String?) {
        
        let API_KEY = getValueFromSecrets(forKey: "GEMINI_API")
        
        let safetySetting = SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone)
        let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: API_KEY!, safetySettings: [safetySetting])
        let modPrompt = "Tell me if this is a phishing email or text: \(prompt). At the end out of 10 tell me how dangerous does this seem to you. Return this as phishingFactor, just at the end. ex: phishingFactor: 10"
        
        do {
            let response = try await model.generateContent(modPrompt)
            print(response.text ?? "")
            let results = sanitizeGeminiResponse(response: response.text ?? "")
            
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
            
            if(results.phishingFactor != "Low"){
                
                let payload = GCPPayload(isBreach: false, data: GCPPayloadData(textValue: prompt, geminiResult: results.sanitizedText, type: true), userId: "\(userId)-\(formattedDateTime)")
                    do {
                        try await savePhishData(payload: payload)
                    } catch {
                    print("Failed to send data")
                }
                
            } else {
                let payload = GCPPayload(isBreach: false, data: GCPPayloadData(textValue: prompt, geminiResult: results.sanitizedText, type: false), userId: "\(userId)-\(formattedDateTime)")
                do {
                    try await savePhishData(payload: payload)
                } catch {
                print("Failed to send data")
            }
            }
            
            return(result: results.sanitizedText, phishingFactor: results.phishingFactor)
            
        }
        catch {
            print("Error: \(error)")
             return(result: "Error: \(error)", phishingFactor: "0")
        }
        
    }
    
    func getValueFromSecrets(forKey key: String) -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return plist[key] as? String
        }
        return nil
    }
    
    func sanitizeGeminiResponse(response: String) -> (sanitizedText: String, phishingFactor: String?) {
        let trimmedText = response.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var phishingFactor: String? = nil
        var cleanedText = trimmedText
        
        let pattern = "phishingFactor:\\s*(\\d+)"

        if let range = cleanedText.range(of: pattern, options: .regularExpression) {
            let match = String(cleanedText[range])
            phishingFactor = match.components(separatedBy: ":").last?.trimmingCharacters(in: .whitespaces)
            
            cleanedText.removeSubrange(range)
        }
        
        let lines = cleanedText.components(separatedBy: .newlines)
        
        let sanitizedLines = lines.map { $0.trimmingCharacters(in: .whitespaces) }
        
        let sanitizedText = sanitizedLines.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        
        return (sanitizedText: sanitizedText, phishingFactor: phishingFactor)
    }
    
    func checkPhishingLevel(phishingFactor: String) -> (type: String, color: Color) {
        print(phishingFactor)
        if let phishInt = Int(phishingFactor){
            if(phishInt < 3){
                return (type: "Low", color: Color.green)
            } else if (phishInt < 6){
                return (type: "Average", color: Color.yellow)
            } else {
                return (type: "High", color: Color.red)
            }
        } else {
            return (type: "Undefined", color: Color.blue)
        }
    }
    
    func getBreachMeasures(prompt: String) async -> String {
        
        let API_KEY = getValueFromSecrets(forKey: "GEMINI_API")
        
        let safetySetting = SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone)
        let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: API_KEY!, safetySettings: [safetySetting])
        let modPrompt = "My email id has been in a following breach: \(prompt). Let me know if you have information about this breach, and how can I safeguard my email from such breaches. Avoid using any symbols like * in the response"
        
        do {
            let response = try await model.generateContent(modPrompt)
            print(response.text ?? "")
            let results = sanitizeGeminiResponse(response: response.text ?? "")
            
            return(results.sanitizedText)
            
        }
        catch {
            print("Error: \(error)")
             return("Error: \(error)")
        }
        
    }
    
    func savePhishData(payload: GCPPayload) async throws {
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

}

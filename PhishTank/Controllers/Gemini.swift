//
//  Gemini.swift
//  PhishTank
//
//  Created by Amey Sunu on 23/10/2024.
//

import Foundation
import GoogleGenerativeAI

class GeminiController {
    
    func sendPhishingRequest(prompt: String) async -> String {
        
        let API_KEY = getValueFromSecrets(forKey: "GEMINI_API")
        
        let safetySetting = SafetySetting(harmCategory: .dangerousContent, threshold: .blockNone)
        let model = GenerativeModel(name: "gemini-1.5-flash", apiKey: API_KEY!, safetySettings: [safetySetting])
        let modPrompt = "Tell me if this is a phishing email or text: \(prompt). At the end out of 10 tell me how dangerous does this seem to you. Return this as phishingFactor, just at the end. ex: phishingFactor: 10"
        
        do {
            let response = try await model.generateContent(modPrompt)
            print(response.text ?? "")
            return sanitizeGeminiResponse(response: response.text ?? "").sanitizedText
        }
        catch {
               print("Error: \(error)")
            return "Error: \(error)"
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
}

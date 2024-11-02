//
//  Widgets.swift
//  PhishTank
//
//  Created by Amey Sunu on 27/10/2024.
//

import Foundation

class WidgetController {
    
    func checkForEmailBreach(email: String) async -> ExposedBreaches? {
        guard let url = URL(string: "https://api.xposedornot.com/v1/breach-analytics?email=\(email)") else {
            print("Invalid URL.")
            return nil
        }
        
        do {
            let (responseData, _) = try await URLSession.shared.data(from: url)
            
            let decodedData = try JSONDecoder().decode([String: ExposedBreaches].self, from: responseData)
            
            if let exposedBreaches = decodedData["ExposedBreaches"] {
                return exposedBreaches
            } else {
                print("ExposedBreaches not found in JSON.")
                return nil
            }
            
        } catch {
            print("Request failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    struct ExposedBreaches: Codable {
        let breachesDetails: [BreachDetail]
        
        enum CodingKeys: String, CodingKey {
            case breachesDetails = "breaches_details"
        }
    }

    struct BreachDetail: Codable {
        let breach: String
        let details: String
        let domain: String
        let industry: String
        let logo: String
        let passwordRisk: String
        let references: String
        let searchable: String
        let verified: String
        let xposedData: String
        let xposedDate: String
        let xposedRecords: Int
        
        enum CodingKeys: String, CodingKey {
            case breach, details, domain, industry, logo
            case passwordRisk = "password_risk"
            case references, searchable, verified
            case xposedData = "xposed_data"
            case xposedDate = "xposed_date"
            case xposedRecords = "xposed_records"
        }
    }
}

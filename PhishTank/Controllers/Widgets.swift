//
//  Widgets.swift
//  PhishTank
//
//  Created by Amey Sunu on 27/10/2024.
//

import Foundation

class WidgetController {
    
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
                
                return breaches
            } else {
                print("No exposed breaches found.")
                
                return nil
            }
        } catch {
            print("Failed to fetch data: \(error)")
            return nil
        }
    }


    
    
    struct BreachAnalyticsResponse: Codable {
        let exposedBreaches: ExposedBreaches?
        
        enum CodingKeys: String, CodingKey {
            case exposedBreaches = "ExposedBreaches"
        }
        
        struct ExposedBreaches: Codable {
            let breaches_details: [BreachDetail]?
            
            enum CodingKeys: String, CodingKey {
                case breaches_details = "breaches_details"
            }
            
            struct BreachDetail: Codable {
                let breach: String?
                let details: String?
                let domain: String?
                let industry: String?
                let logo: String?
                let password_risk: String?
                let references: String?
                let searchable: String?
                let verified: String?
                let xposed_data: String?
                let xposed_date: String?
                let xposed_records: Int?
                
                enum CodingKeys: String, CodingKey {
                    case breach, details, domain, industry, logo
                    case password_risk = "password_risk"
                    case references, searchable, verified
                    case xposed_data = "xposed_data"
                    case xposed_date = "xposed_date"
                    case xposed_records = "xposed_records"
                }
            }
        }
    }


}

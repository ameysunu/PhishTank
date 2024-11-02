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

}

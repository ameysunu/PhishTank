//
//  BreachModels.swift
//  PhishTank
//
//  Created by Amey Sunu on 02/11/2024.
//

import Foundation

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

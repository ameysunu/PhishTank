//
//  Authentication.swift
//  PhishTank
//
//  Created by Amey Sunu on 12/10/2024.
//

import FirebaseAuth

class Authentication {
    
    func signIn(email: String, password: String, completion: @escaping (String, Bool) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error as? NSError {
                completion(self.errorCodeSwitcher(error: error), false)
            } else {
                completion("Successfully signed in", true)
            }
        }
    }
    
    func errorCodeSwitcher(error: NSError) -> String {
        switch AuthErrorCode(rawValue: error.code){
        case .networkError:
            return "Network error"
        case .invalidEmail:
            return "Invalid email"
        case .wrongPassword:
            return "Incorrect password"
        case .userNotFound:
            return "User not found"
        default:
            return "Something went wrong. Please contact your administrator"
        }
    }
    
}

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
    
    func emailPasswordValidator(email: String, password: String) -> (String, Bool){
        if(email.isEmpty){
            return("Please fill out the email address", false)
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid = emailPredicate.evaluate(with: email)
        
        if(!isValid){
            return("Badly formatted email address", false)
        }
        
        if(password.count < 6){
            return("Password length is minimum 6 characters", false)
        }
        
        return("Success", true)
    }
    
}

//
//  AuthManager.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 14.04.2023.
//

import Foundation
import FirebaseAuth /* 43 */

final class AuthManager { /* 44 */
    static let shared = AuthManager() /* 45 */
    
    private let auth = Auth.auth() /* 46 */
    
    private init() {} /* 47 */
    
    public var isSignedIn: Bool { /* 53 */
        return auth.currentUser != nil /* 54 */
    }
    
    public func signUp(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) { /* 55 */
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else { /* 64 */
            return /* 65 */
        }
        
        auth.createUser(withEmail: email, password: password) { result, error in /* 74 */
            guard result != nil, error == nil else { /* 75 */
                completion(false) /* 76 */
                return /* 77 */
            }
            
            //Account Created
            completion(true) /* 78 */
        }
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Bool) -> Void
    ) { /* 56 */
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else { /* 66 */
            return /* 67 */
        }
        
        auth.signIn(withEmail: email, password: password) { result, error in /* 69 */
            guard result != nil, error == nil else { /* 70 */
                completion(false) /* 71 */
                return /* 72 */
            }
            
            completion(true) /* 73 */
        } /* 68 */
    }
    
    public func signOut(
        completion: (Bool) -> Void
    ) { /* 57 */
        do { /* 58 */
            try auth.signOut() /* 59 */
            completion(true) /* 60 */
        }
        catch { /* 61 */
            print(error) /* 62 */
            completion(false) /* 63 */
        }
    }
}

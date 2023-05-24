//
//  FirebaseAuthService.swift
//  Ios Books
//
//  Created by Long on 5/22/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class FirebaseAuthService {
    private var userUid: String!
    
    func getUserUid() -> String {
        return self.userUid ?? ""
    }
    
    func checkLogin(onCompletion:  @escaping (_ status: Bool)->Void) {
        Auth.auth().addStateDidChangeListener() { auth, user in
            if user != nil {
                if let user = user {
                    // The user's ID, unique to the Firebase project.
                    // Do NOT use this value to authenticate with your backend server,
                    // if you have one. Use getTokenWithCompletion:completion: instead.
                    let uid = user.uid
                    //                  let email = user.email
                    self.userUid = uid
                    print("uid: \(uid)")
                }
                
                print("Da dang nhap")
                onCompletion(true)
            }
            else {
                print("Chua dang nhap")
                onCompletion(false)
            }
        }
    }
    
    func register(email: String, password: String, onCompletion: @escaping (_ status: Bool)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print(error)
            }
            else {
                print(authResult)
            }
        }
    }
    
}

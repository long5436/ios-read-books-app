//
//  FirebaseAuthService.swift
//  Ios Books
//
//  Created by Long on 5/22/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

class FirebaseAuthService {
    private var userUid: String!
    private var userEmail: String!
    
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
                    let email = user.email ?? ""
                    self.userEmail = email
                    self.userUid = uid
                    
                    print("uid: \(uid), email: \(email)")
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
            if let _ = error {
                print("Loi dang ky user")
                onCompletion(false)
            }
            else {
                print("Dang ky thanh cong")
                // goi dang xuat sau khi dang nhap thanh cong vi chua biet cach ngan chan dang nhap tu dong sau khi dang ky
                self.logout { status in }
                onCompletion(true)
            }
        }
    }
    
    func removeStateListenerAuth() {
        let _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            // Xử lý sự thay đổi trạng thái đăng nhập tại đây
            self.userUid = ""
        }
    }
    
    func logout(onCompletion: @escaping (_ status: Bool)->Void) {
        do {
          try Auth.auth().signOut()
            print("Da dang xuat")
            onCompletion(true)
        } catch {
            print("Dang xuat loi")
            onCompletion(false)
        }
    }
    
    func login(email: String, password: String, onCompletion: @escaping (_ status: Bool)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if (authResult != nil) {
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        }
    }
    
    func resetPass(password: String, onCompletion: @escaping (_ status: Bool)->Void) {
        
        let user = Auth.auth().currentUser
        var credential: AuthCredential

        // Prompt the user to re-provide their sign-in credentials

        user?.reauthenticate(with: credential) { error in
          if let error = error {
            // An error happened.
          } else {
            // User re-authenticated.
          }
        }
        
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            if error != nil {
                print("doi pass thanh cong")
                onCompletion(true)
            } else {
                print("Doi pass that bai")
                onCompletion(false)
            }
        }
    }
}

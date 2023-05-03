//
//  ViewController.swift
//  Ios Books
//
//  Created by Long on 4/27/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let db = Firestore.firestore()
        let booksRef = db.collection("books")
        
        booksRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }


}


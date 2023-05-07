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
    
    var arrBook = [Book]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        getBooks()
        
    }
    
    // Lay du lieu cac cuon sach tu firebase
    func getBooks(){
        let db = Firestore.firestore()
        let booksRef = db.collection("books")
        //
        booksRef.order(by: "created", descending: true).limit(to: 10).getDocuments() { (querySnapshot, error) in
            
            
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    guard
                        let categoryId = data["cate_id"] as? String,
                        let name = data["name"] as? String,
                        let photo = data["photo"] as? String,
                        let about = data["about"] as? String
                        else {
                            continue
                    }
                    
                    //                    let storageRef = Storage.storage().reference(forURL: photo)
                    //                    storageRef.downloadURL { (url, error) in
                    //                        if let error = error {
                    //                            print("Error downloading image URL: \(error.localizedDescription)")
                    //                        } else {
                    //                           let ok = url?.absoluteString ?? ""
                    //                            print("OK \(ok)")
                    //                        }
                    //
                    //                    }
                    //
                    let newBook = Book(bookId: document.documentID , categoryId: categoryId, name: name, photo: photo, about: about)
                    if let newBook = newBook {
                        
                        self.arrBook.append(newBook)
                    }
                }
                
                print("Mang book \(self.arrBook.count)")
            }
        }
    }
    
    
}


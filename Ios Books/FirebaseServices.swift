//
//  FirebaseServices.swift
//  Ios Books
//
//  Created by Long on 5/15/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class FireBaseServices {
    // MARK: Properties
    private let bookPageRef = Firestore.firestore().collection("book_contents")
    
    func getBookPage(bookId: String, page: Int, onCompletion: @escaping (_ content: String) -> Void) -> Void {
        
        let query = self.bookPageRef
            .whereField("book_id", isEqualTo: bookId)
            .whereField("page", isEqualTo: page)
            .limit(to: 1)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            var content = ""
            // lay du lieu
            for document in snapshot.documents {
                let data = document.data()
                content = data["content"] as? String ?? ""
            }
            
            onCompletion(content)
        }
    }
}

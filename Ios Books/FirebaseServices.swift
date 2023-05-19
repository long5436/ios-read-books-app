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
    private let categoryBook = Firestore.firestore().collection("books")
    
    
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
    
    func getDataQueryBooksFromCategoryId(query: Query, onCompletion: @escaping (_ books: [Book], _ documentLast: DocumentSnapshot?) -> Void) {
        query.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents: \(error!)")
                return}
            
            
            var books = [Book]()
            //layas du lieu
            let currentDocumentLast = snapshot.documents.last
            for document in snapshot.documents{
                let data = document.data()
                
                guard
                    let categoryId = data["cate_id"] as? String,
                    let name = data["name"] as? String,
                    let photo = data["photo"] as? String,
                    let about = data["about"] as? String
                    else {
                        continue
                }
                
                let newBook = Book(bookId: document.documentID , categoryId: categoryId, name: name, photo: photo, about: about)
                if let newBook = newBook {
                    // them du lieu vao mang sach
                    books.append(newBook)
                }
                
            }
            onCompletion(books, currentDocumentLast ?? nil)
//            print("books: \(books.count)")
        }
    }
    
    
    func getBooksFromCategory(cateId: String, documentLast: DocumentSnapshot?, onCompletion: @escaping (_ books: [Book], _ documentLast: DocumentSnapshot?) -> Void) -> Void {
        
        if let last = documentLast {
            let query = self.categoryBook
            .start(afterDocument: last)
            .whereField("cate_id", isEqualTo: cateId)
            .limit(to: 12)
            
            self.getDataQueryBooksFromCategoryId(query: query, onCompletion: onCompletion)
        }
        else {
            let query = self.categoryBook
            .whereField("cate_id", isEqualTo: cateId)
            .limit(to: 12)
            
             self.getDataQueryBooksFromCategoryId(query: query, onCompletion: onCompletion)
        }
    }
}

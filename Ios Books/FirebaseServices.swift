//
//  FirebaseServices.swift
//  Ios Books
//
//  Created by Long on 5/15/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class FireBaseServices {
    // MARK: Properties
    private let bookPageRef = Firestore.firestore().collection("book_contents")
    private let bookRef = Firestore.firestore().collection("books")
    private let categoryRef = Firestore.firestore().collection("categories")
    private let historyRef = Firestore.firestore().collection("histories")
    private let limitBookQuery = 12
    
    
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
    
    func getBookDataFromQuery(query: Query, onCompletion: @escaping (_ books: [Book], _ documentLast: DocumentSnapshot?) -> Void) {
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
            //                        print("books: \(books.count)")
        }
    }
    
    
    func getBooksFromCategory(cateId: String, documentLast: DocumentSnapshot?, onCompletion: @escaping (_ books: [Book], _ documentLast: DocumentSnapshot?) -> Void) -> Void {
        
        if let last = documentLast {
            let query = self.bookRef
                .start(afterDocument: last)
                .whereField("cate_id", isEqualTo: cateId)
                .limit(to: self.limitBookQuery)
            
            self.getBookDataFromQuery(query: query, onCompletion: onCompletion)
        }
        else {
            let query = self.bookRef
                .whereField("cate_id", isEqualTo: cateId)
                .limit(to: self.limitBookQuery)
            
            self.getBookDataFromQuery(query: query, onCompletion: onCompletion)
        }
    }
    
    func loadDataFromFirebaseToCategories (onCompletion: @escaping (_ categories: [Category]) -> Void) -> Void {
        let query = self.categoryRef
            .order(by: "created", descending: true)
        
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            // print("da lieu la \(String(describing: snapshot.documents.last?.data()["name"]))")
            
            var dataCategories = [Category]()
            
            // lay du lieu sach ra
            for document in snapshot.documents {
                let data = document.data()
                
                guard
                    let name = data["name"] as? String,
                    let photo = data["photo"] as? String
                        
                else {
                    continue
                }
                
                let newCategory = Category(
                    categoryId: document.documentID,
                    name: name,
                    photo: photo)
                
                
                if let newCategory = newCategory {
                    // them du lieu vao mang sach
                    dataCategories.append(newCategory)
                }
                
                //                print("Da vo day")
            }
            
            return onCompletion(dataCategories)
        }
    }
    
    func searchBooks(searchText: String, onCompletion: @escaping (_ categories: [Book], _ ducumentLast: DocumentSnapshot?) -> Void) {
        
        let query = self.bookRef
            .order(by: "created", descending: true)
            .whereField("search_key", arrayContains: searchText)
            .limit(to: self.limitBookQuery)
        
        self.getBookDataFromQuery(query: query, onCompletion: onCompletion)
        
    }
    
    func getDataBooks(documentLast: DocumentSnapshot!, onCompletion: @escaping (_ categories: [Book], _ ducumentLast: DocumentSnapshot?) -> Void) {
        if let last = documentLast {
            //            print("goi ham next page")
            let query = self.bookRef
                .order(by: "created", descending: true)
                .start(afterDocument: last)
                .limit(to: self.limitBookQuery)
            self.getBookDataFromQuery(query: query, onCompletion: onCompletion)
        } else {
            let query = self.bookRef
                .order(by: "created", descending: true)
                .limit(to: self.limitBookQuery)
            self.getBookDataFromQuery(query: query, onCompletion: onCompletion)
        }
    }
    
    func getBook(bookId: String, onCompletion: @escaping (_ book: Book) -> Void) -> Void {
        
        self.bookRef.document(bookId).getDocument { (document, error) in
            if let error = error {
                print("Lỗi khi truy vấn dữ liệu: \(error.localizedDescription)")
            } else {
                if let document = document, document.exists {
                    let data = document.data()
                    
                    
                    let categoryId = data?["cate_id"] as? String ?? ""
                    let name = data?["name"] as? String ?? ""
                    let photo = data?["photo"] as? String ?? ""
                    let about = data?["about"] as? String ?? ""
                    
                    
                    let book = Book(bookId: document.documentID, categoryId: categoryId, name: name, photo: photo, about: about)
                    
                    if let book = book {
                        onCompletion(book)
                    }
                    
                }
            }
        }    
    }
    
    func getHistory(userUid: String, onCompletion: @escaping (_ bookId: String?, _ page: Int?) -> Void) -> Void {
        
        let query = self.historyRef
            .whereField("uid", isEqualTo: userUid)
            .limit(to: 1)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            if snapshot.documents.count == 0 {
                onCompletion(nil, nil)
            }
            
            // lay du lieu sach ra
            for document in snapshot.documents {
                let data = document.data()
                
                guard
                    let bookId = data["book_id"] as? String,
                    let page = data["page"] as? Int
                        
                else {
                    continue
                }
                
                onCompletion(bookId, Int(page))
            }
        }
    }
    
    func updateHistory(userUid: String, bookId: String, page: Int) {
        
        let data: [String: Any] = [
            "uid": userUid,
            "book_id": bookId,
            "page": page
        ]
        
        self.getHistory(userUid: userUid) { bookId, page in
            if bookId == nil {
                
                self.historyRef.addDocument(data: data) { (error) in
                    if let error = error {
                        print("Lỗi khi thêm dữ liệu: \(error.localizedDescription)")
                    } else {
                        print("Dữ liệu đã được thêm thành công vào collection 'histories'")
                    }
                }
                
            }
            else {
                self.historyRef.whereField("uid", isEqualTo: userUid).getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Lỗi khi truy vấn dữ liệu: \(error.localizedDescription)")
                    } else {
                        if let snapshot = snapshot, !snapshot.isEmpty {
                            // Tìm thấy tài liệu, cập nhật trường "page"
                            let document = snapshot.documents[0]
                            document.reference.updateData(data) { (error) in
                                if let error = error {
                                    print("Lỗi khi cập nhật dữ liệu: \(error.localizedDescription)")
                                } else {
                                    print("Dữ liệu đã được cập nhật thành công trong collection 'histories'")
                                }
                            }
                        } else {
                            // Không tìm thấy tài liệu
                            print("Không tìm thấy tài liệu có uid là \(userUid)")
                        }
                    }
                }
            }
        }
    }
}

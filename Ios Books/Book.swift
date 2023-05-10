//
//  Book.swift
//  Ios Books
//
//  Created by Long on 5/8/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class Book {
    //MARK: Properties
    private var bookId: String
    private var categoryId: String
    private var name: String
    private var photo: String
    private var about: String
    
    //MARK: Contructors
    init?(bookId: String, categoryId: String, name: String, photo: String, about: String) {
        // Kiem tra dieu kien tao doi tuong Book
        if name.isEmpty {
            return nil
        }
        
        // Khoi gan gia cho cac bien thanh phan
        self.bookId = bookId
        self.categoryId = categoryId
        self.name = name
        self.photo = photo
        self.about = about
    }
    
    // Getter and Setter
    public func getBookId()->String {
        return bookId
    }
    
    public func getCategoryId()->String {
        return categoryId
    }
    
    public func getName()->String {
        return name
    }
    
    public func getPhoto()->String {
        return photo
    }
    
    public func getAbout()->String {
        return about
    }
}

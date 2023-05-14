//
//  Category.swift
//  Ios Books
//
//  Created by hieu on 5/10/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class Category {
    //MARK: Properties
    private var categoryId: String
    private var name: String
    private var photo: String
    
    //MARK: Contructors
    init?(categoryId: String, name: String, photo: String) {
        //Kiem tra dieu kien tao doi tuong category
        if name.isEmpty{
            return nil
        }
        
         // Khoi gan gia tri cho cac bien thanh phan
        self.categoryId = categoryId
        self.name = name
        self.photo = photo
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
}

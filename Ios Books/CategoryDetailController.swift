//
//  DetailController.swift
//  Ios Books
//
//  Created by hieu on 5/15/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoryDetailController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var CategoryDetail: UICollectionView!
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = category {
            navigationItem.title = category.getName()
        }
    }
    
}


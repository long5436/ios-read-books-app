//
//  CategoryViewController.swift
//  Ios Books
//
//  Created by hieu on 5/11/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    
    
    let categorysRef = Firestore.firestore().collection("categories")
    
    private var categoryBook = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //        if let category = Category(categoryId: "fddfs", name: "sddsddddd", photo: "sesgr "){
        //            categoryBook += [category]
        //
        //        }
        //        if let category1 = Category(categoryId: "fddfs", name: "sddsddddd", photo: "sesgr "){
        //            categoryBook += [category1]
        //
        //        }
        //        if let category2 = Category(categoryId: "fddfs", name: "sddsddddd", photo: "sesgr "){
        //            categoryBook += [category2]
        //
        //        }
        
        getCategorys()
    }
    
    
    //
    func getCategorys(){
        let query = self.categorysRef
            .order(by: "created", descending: true)
        loadDataFromFirebaseToCategories(query: query)
    }
    
    
    func loadDataFromFirebaseToCategories (query: Query) {
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            //            print("da lieu la \(String(describing: snapshot.documents.last?.data()["name"]))")
            
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
                    self.categoryBook.append(newCategory)
                    // load lai view khi co du lieu
                    self.tableView.reloadData()
                    
                }
                
                print("Da vo day")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categoryBook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "Tableviewcell"
        if  let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? TableViewCell{

            //lay du lieu category

            let cate = categoryBook[indexPath.row]
            cell.lblCategory.text = cate.getName()
            cell.setData(category: cate)

            return cell
        }
        fatalError("ko the cell")
    
    }
    
  
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    func getLinkImageFromFirebase(path: String, completion: @escaping (String?) -> Void) {
    //        let storageRef = Storage.storage().reference()
    //        storageRef.downloadURL { (url, error) in
    //            guard url != nil else {
    //                // Nếu có lỗi, in ra thông báo lỗi
    //                if let error = error {
    //                    print("Error downloading image: \(error.localizedDescription)")
    //                }
    //                return
    //            }
    //
    //        }
    //    }
    
}

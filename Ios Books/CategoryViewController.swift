//
//  CategoryViewController.swift
//  Ios Books
//
//  Created by hieu on 5/11/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    
    //MARK: Properties
    @IBOutlet weak var tableView: UITableView!
    
    private var categoryBook = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let category = Category(categoryId: "fddfs", name: "sddsddddd", photo: "sesgr "){
            categoryBook += [category]
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryBook.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseCell = "Tableviewcell"
        if  let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? TableViewCell{
            
            //lay du lieu meal
            let cate = categoryBook[indexPath.row]
            cell.lblCategory.text = cate.getName()
//                        cell.imgCategory.image = book.getPhoto()
            
            return cell
        }
        fatalError("ko the cell")
    }
    
    
    //     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //           // #warning Incomplete implementation, return the number of rows
    //           return categoryBook.count
    //       }
    //
    //
    //       override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //           let reuseCell = "TableViewCell"
    //           if  let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? TableViewCell{
    //
    //               //lay du lieu meal
    //               let book = categoryBook[indexPath.row]
    //               cell.lblCategory.text = book.getName()
    //               //            cell.imgCategory.image = book.getPhoto()
    //
    //               return cell
    //           }
    //           fatalError("ko the cell")
    //       }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  CategoryTableViewController.swift
//  Ios Books
//
//  Created by hieu on 5/10/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    
    @IBOutlet weak var CategoryTableViewController: UITableView!
    
    private var categoryBook = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let category = Category(categoryId: "fddfs", name: "sddsddddd", photo: "sesgr "){
            categoryBook += [category]
            
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryBook.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseCell = "TableViewCell"
        if  let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath) as? TableViewCell{
            
            //lay du lieu meal
            let book = categoryBook[indexPath.row]
            cell.lblCategory.text = book.getName()
            //            cell.imgCategory.image = book.getPhoto()
            
            return cell
        }
        fatalError("ko the cell")
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
//
//        @IBAction func unWindFormMealtableController( segue: UIStoryboardSegue){
//            //print("quay ve man hinh ")
//            if let source = segue.source as? MealDetailController{
//                //lấy du lieu mới từ. màn hình truyệnf sang
//                if let category = source.category{
//                    // print("du lieu ms tao tu man hinh   \(category.getName())")
//                    let newIndexPath = IndexPath(row: categoryBook.count, section: 0)
//                    categoryBook.append(category)
//                    tableView.insertRows(at: [newIndexPath], with: .none)
//                }
//            }
//
//        }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //     if let destination = segue.destination as?DetailController{
        //              if let segueName = segue.identifier{
        //                  if segueName == "NewMeal"{
        //                      //print("Tao mới")
        //                      destination.navigationType = .NewMeal
        //                  }
        //                  else{
        //                      //print("edit")
        //                      destination.navigationType = .editMeal
        //                  }
        //              }
        //          }
    }
    
    
}

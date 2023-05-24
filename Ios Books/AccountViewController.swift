//
//  AccountViewController.swift
//  Ios Books
//
//  Created by hieu on 5/21/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // lam title chu bu
        navigationController?.navigationBar.prefersLargeTitles = true
        //
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Dang xuat";
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            print("Dang xuat")
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //        let btnlogout = UITableViewCell()
        
    }
    
    
}

//
//  AccountViewController.swift
//  Ios Books
//
//  Created by hieu on 5/21/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate {
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackview: UIStackView!
    
    var button: UIButton!
    let authService = FirebaseAuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // lam title chu bu
        navigationController?.navigationBar.prefersLargeTitles = true
        //
        tableView.delegate = self
        tableView.dataSource = self
        tabBarController?.delegate = self
        
        stackview.isHidden = true
        
        // kiem tra dang nhap
        authService.checkLogin { status in
            if status {
                // lay du lieu
                self.userEmail.text = self.authService.getUserEmail()
                self.stackview.isHidden = false
            }
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //print(tabBarController.selectedIndex)
        
        if tabBarController.selectedIndex == 2 {
            // kiem trang dang nhap
            authService.checkLogin { status in
                if status {
                    // lay du lieu
                    self.userEmail.text = self.authService.getUserEmail()
                    self.stackview.isHidden = false
                } else {
                    self.stackview.isHidden = true
                }
            }
        }
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
            self.showAlert()
        }
        
    }
    
    // Tao pupop hien thi khi sach khong co noi dung
    func showAlert() {
        
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn đăng xuất không?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Huỷ bỏ", style: .default) { (ok: UIAlertAction) in
            //alert.dismiss(animated: true, completion: nil)
        }
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (ok: UIAlertAction) in
            //alert.dismiss(animated: true, completion: nil)
            
            self.authService.logout { status in
                self.stackview.isHidden = true
            }
        }
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
    
        self.present(alert, animated: true)
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //        let btnlogout = UITableViewCell()
        
        
        
    }
    
    
}

//
//  ChangePasswordViewController.swift
//  Ios Books
//
//  Created by hieu on 5/27/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class ChangePasswordViewController: UIViewController {
    
    
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    let firebaseAuthServices = FirebaseAuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changePasswordButtonTap(_ sender: UIButton) {
//        let auth = Auth.auth()
        let newPassword = newPasswordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""
        if newPassword.isEmpty || confirmPassword.isEmpty {
            showAlert(pass: "Vui lòng nhập đầy đủ thông tin.")
            return
        }
        if newPassword != confirmPassword {
            showAlert(pass: "Mật khẩu mới và xác nhận mật khẩu không khớp.")
            return
        }
        
        //print("da vo day")
        self.firebaseAuthServices.resetPass(password: newPassword) { (status) in
            print(status)
        }
       //  self.showAlert(pass: "change")
        
        
        
        
    }
    
    
    //hien thi thong bao neu load ko co du lieu
    func showAlert(pass: String) {
        let alert = UIAlertController(title: "Pass khong chinh xac", message: pass, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Gọi phương thức present trên view controller chính để hiển thị cảnh báo
        //print("Da lay ma")
        self.present(alert, animated: true, completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

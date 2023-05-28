//
//  SendCodeViewController.swift
//  Ios Books
//
//  Created by hieu on 5/26/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import FirebaseAuth
import  FirebaseCore

class SendCodeViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    var code: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func verifyCodeButtonTapped(_ sender: UIButton) {
       
        
        let code = codeTextField.text ??  ""
        if !code.isEmpty {
            // code xu ly db ko viet trong controller
//            auth.confirmPasswordReset(withCode: code, newPassword: "changePassWord") { error in
//                if let error = error {
//                    print("Error: \(error.localizedDescription)")
//                } else {
//                    print("Mã code đã đdược xác nhận và cập nhật mật khẩu mới")
//                    self.navigateToChangePassScreen()
//                }
//            }
            if (Int(code) == self.code) {
                 print("code dung")
                 self.navigateToChangePassScreen()
            } else {
                self.showAlert(code: "Code nhập vào không đúng")
            }
        }
        else {
            self.showAlert(code: "Chưa nhập code")
        }
    }
    
    
    
    //hien thi thong bao neu load ko co du lieu
    func showAlert(code: String) {
        let alert = UIAlertController(title: "Thông báo", message: code, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Gọi phương thức present trên view controller chính để hiển thị cảnh báo
        print("Da lay ma")
        self.present(alert, animated: true, completion: nil)
        self.navigateToChangePassScreen()
    }
    
    
    //Chuyen sang màn hình thay đỏi mật khẩu
    
    func navigateToChangePassScreen() {
        performSegue(withIdentifier: "changePassWord", sender: self)
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


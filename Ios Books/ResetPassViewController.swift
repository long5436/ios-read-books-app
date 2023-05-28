//
//  ResetPassViewController.swift
//  Ios Books
//
//  Created by hieu on 5/23/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth


class ResetPassViewController: UIViewController {
    
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var btnSendMail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //         Do any additional setup after loading the view.
        //                DispatchQueue.main.async {
        //                    self.showAlert(content: "Test")
        //                }
        
        // test
//        generateFakeVerificationCode()
        btnSendMail.layer.cornerRadius = 8
        
    }
    
    @IBAction func resetPassWordTap(_ sender: Any) {
        let auth = Auth.auth()
        let value = textFieldEmail.text ?? ""
        if !value.isEmpty {
           
            auth.sendPasswordReset(withEmail: value) { (error) in
                if let error = error {
                    print("Email: \(error.localizedDescription)")
                     self.showAlert(content: "Email đã nhập không tồn tại hoặc chưa chính xác")
                } else {
                    print("Password reset email sent successfully.")
//                    self.navigateToVerificationCodeScreen()
//                    self.generateFakeVerificationCode()
                    self.showAlert(content: "Kiểm tra email của bạn, một đường thay đổi mật khẩu sẽ được gửi đến email của bạn. Bấm OK để quay về trang đăng nhập", redirectToLogin: true)
                }
            }
        }
        else {
             self.showAlert(content: "Chưa nhập email")
        }
    }
    
    func generateFakeVerificationCode()->Int{

        // lam fake vi khong co be ok
        let verificationCode = Int(arc4random_uniform(900000)) + 100000
        print("Mã xác nhận giả: \(verificationCode)")
        return verificationCode
    }
    
    func navigateToVerificationCodeScreen() {
        performSegue(withIdentifier: "verifyCodeScreen", sender: self)
    }
    
    
    //hien thi thong bao neu load ko co du lieu
    func showAlert(content: String, redirectToLogin: Bool = false) {
        let alert = UIAlertController(title: "Thông báo", message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            if redirectToLogin {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        
        // Gọi phương thức present trên view controller chính để hiển thị cảnh báo
        print("vao day roi")
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     // Lay Destination
        if let destination = segue.destination as? SendCodeViewController {
            destination.code = self.generateFakeVerificationCode()
        }
     
     }
     
}

//
//  RegisterViewController.swift
//  Ios Books
//
//  Created by Long on 5/19/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var textRePassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    let firebaseAuthService = FirebaseAuthService()
    enum StatusAlert {
        case fail
        case error
        case success
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Tao do bo cong chu nut
        btnRegister.layer.cornerRadius = 8
    }
    

    @IBAction func btnRegisterTap(_ sender: Any) {
        let email = textEmail.text ?? ""
        let pass:String = textPassword.text ?? ""
        let rePass:String = textRePassword.text ?? ""
        
        if !email.isEmpty && !pass.isEmpty && pass.isEqual(rePass) {
            print("Dang ky")
            firebaseAuthService.register(email: email, password: pass) { (status) in
                if status {
                    self.showAlert(status: .success)
                }
                else {
                    self.showAlert(status: .fail)
                }
            }
        }
        else {
            print("Nhap chua chinh xac")
            self.showAlert(status: .error)
        }
    }
    
    // Tao pupop hien thi khi sach khong co noi dung
    func showAlert(status: StatusAlert) {
        var message: String
        
        switch status {
        case .fail:
            message = "Đăng ký thất bại"
        case .error:
            message = "Nhập chưa chính xác, vui lòng kiểm tra lại"
        case .success:
            message = "Đăng ký thành công, nhấn \"OK\" để quay về màn hình đăng nhập"
        }
        
        
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            alert.dismiss(animated: true, completion: nil)
            if status == StatusAlert.success {
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okButton)
        self.present(alert, animated: true)
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

//
//  LoginViewController.swift
//  Ios Books
//
//  Created by Long on 26/05/2023.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPass: UITextField!
    let firebaseAuthService = FirebaseAuthService()
    enum StatusAleart {
        case success
        case fail
        case error
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Tao do bo cong chu nut
        btnLogin.layer.cornerRadius = 8
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParent {
        //  print("da vo day")
            performSegue(withIdentifier: "unwindLoginToHistory", sender: self)
        }
    }

    
    @IBAction func loginTap(_ sender: Any) {
        let email = self.textEmail.text ?? ""
        let pass = self.textPass.text ?? ""
        
        if !email.isEmpty && !pass.isEmpty {
            firebaseAuthService.login(email: email, password: pass) { status in
                if status {
                    self.showAlert(status: .success)
                } else {
                    self.showAlert(status: .fail)
                }
            }
        }
        else {
            // hien thi thong bao
            self.showAlert(status: .error)
        }
    }
    
    // Tao pupop hien thi khi sach khong co noi dung
    func showAlert(status: StatusAleart) {
        
        var message: String
        switch status {
        case .success:
            message = "Đăng nhập thành công, nhấn \"OK\" để quay lại"
        case .fail:
            message = "Email hoặc mật khẩu chưa chính xác, vui lòng kiểm tra lại"
        case .error:
            message = "Vui lòng nhập đầy đủ mật khẩu và email"
        }
        
        let alert = UIAlertController(title: "Thông báo", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
            alert.dismiss(animated: true, completion: nil)
            if status == StatusAleart.success {
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

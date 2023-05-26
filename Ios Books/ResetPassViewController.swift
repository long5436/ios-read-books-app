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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          navigationController?.navigationBar.prefersLargeTitles = true
        
        //         Do any additional setup after loading the view.
        //                DispatchQueue.main.async {
        //                    self.showAlert(content: "Test")
        //                }
        
        
    }
    
    @IBAction func resetPassWordTap(_ sender: Any) {
        let auth = Auth.auth()
        let value = textFieldEmail.text ?? ""
        if !value.isEmpty {
            self.showAlert(content: "Email")
            auth.sendPasswordReset(withEmail: value) { (error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    print("Password reset email sent successfully.")
                     self.navigateToVerificationCodeScreen()
                }
            }
        }
    }
    
    func navigateToVerificationCodeScreen() {
         performSegue(withIdentifier: "verifyCodeScreen", sender: self)
    }
    
    
    //hien thi thong bao neu load ko co du lieu
    func showAlert(content: String) {
        let alert = UIAlertController(title: "Error", message: content, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Gọi phương thức present trên view controller chính để hiển thị cảnh báo
        print("vao day roi")
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     //        let backItem = UIBarButtonItem()
     //        backItem.title = "Trở về"
     //        navigationItem.backBarButtonItem = backItem
     //
     //        func sendPassReset(_ sender: UIButton) {
     //            performSegue(withIdentifier: "SendCodeViewController", sender: self)
     //        }
     
     }
     */
}

//
//  ResetPassViewController.swift
//  Ios Books
//
//  Created by hieu on 5/23/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth

class ResetPassViewController: UIViewController {
    
    
    @IBOutlet weak var textFieldEmail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
        
    @IBAction func resetPassButton(_ sender: Any) {
//        let auth = Auth.auth()
//        auth.sendPasswordReset(withEmail: textFieldEmail.text!) { (error) in
//            if let error = error{
//                let alert = Service.createAlertController(title: "Error", message: error.localizedDescription)
//                self.present(alert, animation: true, completion: nil)
//                return
//            }
//
//            let alert = Service.createAlertController(title: "OK", message: "E mail đặt lại mật khẩu đã được gửi")
//            self.present(alert, animation: true, completion: nil)
//
//
//        }
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


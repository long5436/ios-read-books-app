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
                
            }
        }
        else {
            print("Nhap chua chinh xac")
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

}

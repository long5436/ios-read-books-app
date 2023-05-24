//
//  HistoryViewController.swift
//  Ios Books
//
//  Created by Long on 5/19/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, UITabBarControllerDelegate {
    //MARK: Propperties
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookPage: UILabel!
    @IBOutlet weak var btnReadBookContinue: UIButton!
    let firebaseAuthService = FirebaseAuthService()
    let firebaseService = FireBaseServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view
        self.tabBarController?.delegate = self
        // bo cong nut
        btnReadBookContinue.layer.cornerRadius = 8
        bookImage.layer.cornerRadius = 4
        view.isHidden = true
        
        // lam title chu bu
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // kiem trang dang nhap
        firebaseAuthService.checkLogin { (status) in
            //historyToLogin
            if !status {
                
                self.showAlert()
                //                self.performSegue(withIdentifier: "historyToLogin", sender: nil)
            } else {
//                self.firebaseService.updateHistory(userUid: self.firebaseAuthService.getUserUid())
//                self.getBook(userUid: <#T##String#>, bookId: <#T##String#>)
                self.firebaseService.getHistory(userUid: self.firebaseAuthService.getUserUid()) { (bookId, page) in
                    print("bookid: \(bookId), page: \(page)")
                }
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("Da chon tab")
        // kiem trang dang nhap
        firebaseAuthService.checkLogin { (status) in
            //historyToLogin
            if !status {
                
                self.showAlert()
                //                self.performSegue(withIdentifier: "historyToLogin", sender: nil)
            }
            else {
//                self.firebaseService.updateHistory(userUid: self.firebaseAuthService.getUserUid())
//                self.getBook(userUid: <#T##String#>, bookId: <#T##String#>)
                self.firebaseService.getHistory(userUid: self.firebaseAuthService.getUserUid()) { (bookId, page) in
                    print("bookid: \(bookId), page: \(page)")
                }
            }
        }
    }
    
    func getBook(userUid: String, bookId: String) {
//        firebaseService.getBook(userUid: userUid, bookId: bookId) { (arr: [Book], _ DocumentSnapshot?) in
//            print(arr[0])
//        }
    }
    
    // Tao pupop hien thi khi sach khong co noi dung
    func showAlert() {
        
        //        print("da vo day")
        
        if let presentedViewController = self.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "Thông báo", message: "Bạn phải đăng nhập để có thể xem lịch sử", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Huỷ bỏ", style: .default) { (ok: UIAlertAction) in
            self.tabBarController?.selectedIndex = 0
        }
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (ok: UIAlertAction) in
            self.performSegue(withIdentifier: "historyToLogin", sender: nil)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        DispatchQueue.main.async {
            //            print("da goi")
            self.present(alert, animated: true)
        }
        //        self.present(alert, animated: true)
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

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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noHistoryLabel: UILabel!
    let firebaseAuthService = FirebaseAuthService()
    let firebaseService = FireBaseServices()
    var userUid: String?
    var book: Book?
    var page: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.isHidden = true
        btnReadBookContinue.isHidden = true
        
        // test
//        firebaseAuthService.logout { status in
//            if status {
//                
//            }
//        }
        
        // kiem tra dang nhap
        firebaseAuthService.checkLogin { status in
            if status {
                // lay du lieu
                self.getBook(userUid: self.firebaseAuthService.getUserUid())
                self.userUid = self.firebaseAuthService.getUserUid()
            } else {
                self.showAlert()
            }
        }
        
        // bo cong nut
        btnReadBookContinue.layer.cornerRadius = 8
        bookImage.layer.cornerRadius = 4
        
        // lam title chu bu
        navigationController?.navigationBar.prefersLargeTitles = true
        tabBarController?.delegate = self
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        //print(tabBarController.selectedIndex)
        
        if tabBarController.selectedIndex == 2 {
            // kiem trang dang nhap
            let uid = self.firebaseAuthService.getUserUid()
            if !uid.isEmpty {
                self.getBook(userUid: uid)
            }
            else {
                self.stackView.isHidden = true
                self.btnReadBookContinue.isHidden = true
                self.noHistoryLabel.isHidden = false
                self.showAlert()
            }
        }
    }
    
    func getBook(userUid: String, loadBook: Bool = true) {
        self.firebaseService.getHistory(userUid: userUid) { bookId, page in
            if let page = page {
                self.bookPage.text = "Trang \(page)"
                self.page = page
                
                if !loadBook {
                    // hien thi lai view
                    self.stackView.isHidden = false
                    self.btnReadBookContinue.isHidden = false
                    self.noHistoryLabel.isHidden = true
                }
            }
            
            if loadBook {
                if let bookId = bookId {
                    self.firebaseService.getBook(bookId: bookId) { book in
                        self.bookName.text = book.getName()
                        self.bookImage.loadImage(pathName: book.getPhoto())
                        self.book = book
                        // hien thi lai view
                        self.stackView.isHidden = false
                        self.btnReadBookContinue.isHidden = false
                        self.noHistoryLabel.isHidden = true
                    }
                }
            }
        }
    }
    
    // Tao pupop hien thi khi sach khong co noi dung
    func showAlert() {
        
        let alert = UIAlertController(title: "Thông báo", message: "Bạn phải đăng nhập để có thể xem lịch sử", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Huỷ bỏ", style: .default) { (ok: UIAlertAction) in
            self.tabBarController?.selectedIndex = 0
            alert.dismiss(animated: true, completion: nil)
        }
        
        let okButton = UIAlertAction(title: "OK", style: .default) { (ok: UIAlertAction) in
            self.performSegue(withIdentifier: "historyToLogin", sender: nil)
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelButton)
        alert.addAction(okButton)
        
        //        DispatchQueue.main.async {
        // print("da goi")
        self.present(alert, animated: true)
        //        }
        // self.present(alert, animated: true)
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindFromReadBook(segue: UIStoryboardSegue) {
        
        // print("da quay lai man hinh")
        // kiem trang dang nhap
        let uid = self.firebaseAuthService.getUserUid()
        if !uid.isEmpty {
            self.getBook(userUid: uid, loadBook: false)
        }
    }
    
    @IBAction func unwindFromLogin(segue: UIStoryboardSegue) {
        // print("da quay lai man hinh")
        // kiem trang dang nhap
        let uid = self.firebaseAuthService.getUserUid()
        if !uid.isEmpty {
            self.getBook(userUid: uid, loadBook: false)
            
        } else {
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // Thay doi noi dung nut back o man hinh tiep theo
    override func prepare(for segue: UIStoryboardSegue,  sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Lịch sử"
        navigationItem.backBarButtonItem = backItem
        
        // Lay Destination
        if let destination = segue.destination as? ReadBookViewController {
            destination.book = self.book
            destination.page = self.page!
            destination.fromHistory = true
        }
    }
}

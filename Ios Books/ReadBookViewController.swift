//
//  ReadBookViewController.swift
//  Ios Books
//
//  Created by Long on 5/14/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class ReadBookViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var bookContentTextView: UITextView!
    @IBOutlet weak var btnPrev: UIBarButtonItem!
    @IBOutlet weak var btnNext: UIBarButtonItem!
    @IBOutlet weak var btnDecreaseFontSize: UIBarButtonItem!
    @IBOutlet weak var btnEncreaseFontSize: UIBarButtonItem!
    
    var book: Book!
    var fontSize: CGFloat = 17
    var page: Int = 1
    var lastPage = 0
    let firebaseService = FireBaseServices()
    var dataPageContent: [Int: String] = [:]
    var isCallApi: Bool = false
    enum StatusPage {
        case next
        case prev
        case current
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // showAlert()
        
        // Dung de dat trang dau tien se duoc tai
        // page = 3
        
        // Gan gia tri trang cuoi mac dinh, ham load du lieu duoc goi lan dau 2 lan nen -2
        lastPage = page - 2
        
        setPageTitle()
        bookContentTextView.font = UIFont(name: "NotoSerif", size: fontSize)
        bookContentTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 100, right: 20)
        
        // goi ham lay du lieu
        loadDataBookPage(page: page, statusPage: .current)
        loadDataBookPage(page: page + 1, statusPage: .next)
        
        // tat nut chuyen ve trang truoc neu trang hien tai bang 1
        if page == 1 {
            btnPrev.isEnabled = false
        }
    }
    
    
    // Dat trang tren tieu de
    func setPageTitle() {
        self.navigationItem.title = "Trang \(page)"
    }
    
    // Tat bat nut next trang
    func setStatusPageBtn() {
        //  print("current page: \(self.page), last page: \(self.lastPage)")
        
        self.btnNext.isEnabled = (self.page < self.lastPage)
        self.btnPrev.isEnabled = self.page > 1
    }
    
    // Cuon trang len dau khi chuyen trang
    func scrollViewToTop() {
        // Cuộn view lên đầu màn hình
        let topRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        self.bookContentTextView.scrollRectToVisible(topRect, animated: false)
    }
    
    // Load du lieu trang sach
    func loadDataBookPage(page: Int, statusPage: StatusPage) {
        if let book = self.book {
            // set trang thai dang call api
            self.isCallApi = true
            firebaseService.getBookPage(bookId: book.getBookId(), page: page, onCompletion: { (content: String) in
                if !content.isEmpty {
                    
                    // them du lieu trang vao dataPageContent
                    self.dataPageContent[page] = content
                    
                    switch statusPage {
                    case .next:
                        // Tang so trang cuoi cung
                        // Chi tang so trang cuoi khi truong hop la "current" va "next"
                        self.lastPage = self.lastPage + 1
                        // chay tiep de case tiep theo ma khong break
                        fallthrough
                    case .prev:
                        // dat trang thai tat bat nut next trang
                        // print("ok")
                        self.setStatusPageBtn()
                        self.isCallApi = false
                    case .current:
                        // set noi dung cho textView
                        self.bookContentTextView.text = content
                        // gan lai so trang hien tai
                        self.page = page
                        // gan lai title la trang hien tai
                        self.setPageTitle()
                        // goi tai truoc du lieu
                        self.loadDataBookPage(page: self.page + 1, statusPage: .next)
                        // Chi tang so trang cuoi khi truong hop la "current" va "next"
                        self.lastPage = self.lastPage + 1
                    }
                }
                else {
                    // dat trang thai tat bat nut next trang
                    self.setStatusPageBtn()
                    self.isCallApi = false
                    
                    // goi khi sach khong co noi dung
                    if page == 1 {
                        self.showAlert()
                    }
                }
            })
        }
    }
    
    // Chuyen ve trang truoc
    @IBAction func nextPage(_ sender: UIBarButtonItem) {
        
        if !self.isCallApi{
            self.scrollViewToTop()
            
            if let content = self.dataPageContent[self.page + 1] {
                self.bookContentTextView.text = content
                self.page = self.page + 1
                self.setPageTitle()
                
                if let _ = self.dataPageContent[self.page + 1] {
                    // dat trang thai tat bat nut next trang
                    self.setStatusPageBtn()
                }
                else {
                    loadDataBookPage(page: self.page + 1, statusPage: .next)
                }
                
            }
            else {
                loadDataBookPage(page: self.page + 1, statusPage: .next)
            }
            
        }
    }
    
    // Chuyen den trang tiep theo
    @IBAction func prevPage(_ sender: UIBarButtonItem) {
        if !self.isCallApi{
            self.scrollViewToTop()
            
            if let content = self.dataPageContent[self.page - 1] {
                self.bookContentTextView.text = content
                self.page = self.page - 1
                self.setPageTitle()
                
                if page > 1 {
                    if let _ = self.dataPageContent[self.page - 1] {
                        self.setStatusPageBtn()
                    }
                    else {
                        loadDataBookPage(page: self.page - 1, statusPage: .prev)
                    }
                }
                else {
                    self.btnPrev.isEnabled = false
                }
            }
            else {
                loadDataBookPage(page: self.page - 1, statusPage: .current)
            }
        }
    }
    
    // Kiem tra tat bat nut tang, giam kich thuoc font chu
    func checkBtnFontSize() {
        if fontSize >= 30 {
            btnEncreaseFontSize.isEnabled = false
        }
        else if fontSize <= 10 {
            btnDecreaseFontSize.isEnabled = false
        }
        else {
            btnDecreaseFontSize.isEnabled = true
            btnEncreaseFontSize.isEnabled = true
        }
    }
    
    // Giam kich thuoc font chu
    @IBAction func decreaseFontSize(_ sender: UIBarButtonItem) {
        
        fontSize = fontSize - 5
        bookContentTextView.font = UIFont(name: "NotoSerif", size: fontSize)
        checkBtnFontSize()
        
    }
    
    // Tang kich thuoc font chu
    @IBAction func encreaseFontSize(_ sender: UIBarButtonItem) {
        fontSize = fontSize + 5
        bookContentTextView.font = UIFont(name: "NotoSerif", size: fontSize)
        checkBtnFontSize()
    }
    
    // init alert
    func initAlert() {
        
    }
    
    // Tao pupop hien thi khi sach khong co noi dung
    func showAlert() {
        
        //        print("da vo day")
        
        if let presentedViewController = self.presentedViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
        
        let alert = UIAlertController(title: "Thông báo", message: "Sách không có nội dung", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (ok: UIAlertAction) in
            // Lay doi tuong navigation controller
            if let navigationController = self.navigationController {
                self.dismiss(animated: true, completion: nil)
                navigationController.popViewController(animated: true)
            }
        }
        
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

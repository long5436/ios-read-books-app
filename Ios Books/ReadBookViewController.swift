//
//  ReadBookViewController.swift
//  Ios Books
//
//  Created by Long on 5/14/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

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
    var lastPage: Int = 1
    let bookPageRef = Firestore.firestore().collection("book_contents")
    var nextPageContent: String = ""
    let firebaseService = FireBaseServices()
    enum StatusPage {
        case next
        case prev
        case current
    }
    let arrPageContent = [String]()
//    test code moi
    var dataPageContent: [Int: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setPageTitle()
        bookContentTextView.font = UIFont(name: "NotoSerif", size: fontSize)
        
        // goi ham lay du lieu
        //        loadDataBookPage(page: page, status: .current, loadDataNextPage: false)
        // lay truoc du lieu trang tiep theo
        //        loadDataNextPage(page: nil, status: nil, loadDataNextPage: true)
        
        loadDataBookPage(page: page, isNextPage: false)
        loadDataBookPage(page: 2, isNextPage: false)
        loadDataBookPage(page: 3, isNextPage: false)
        
        // tat nut chuyen ve trang truoc neu trang hien tai bang 1
        if page == 1 {
            btnPrev.isEnabled = false
        }
    }
    
    // Dat trang tren tieu de
    func setPageTitle() {
        self.navigationItem.title = "Trang \(page)"
    }
    
    // Load du lieu trang sach
    // , status: StatusPage, loadDataNextPage: Bool
    func loadDataBookPage(page: Int, isNextPage: Bool) {
        if let book = self.book {
            firebaseService.getBookPage(bookId: book.getBookId(), page: page, onCompletion: { (content: String) in
                if !content.isEmpty {
//                  them du lieu trang vao dataPageContent
                    self.dataPageContent[page] = content
                }
            })
        }
    }
    
    // Chuyen ve trang truoc
    @IBAction func prevPage(_ sender: UIBarButtonItem) {
        
    }
    
    // Chuyen den trang tiep theo
    @IBAction func nextPage(_ sender: UIBarButtonItem) {
//        print("Count is: \(self.dataPageContent.count)")
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//
//  ViewController.swift
//  Ios Books
//
//  Created by Long on 4/27/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    //MARK: Properties
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    // du lieu gia
    //    let arrayData: [String] = ["sdd", "DSDSD", "sdd", "DSDSD", "sdd", "DSDSD", "sdd", "DSDSD"]
    //
    let arrayData: [String] = ["DSDSD"]
    
    var limitBookQuery: Int = 12
    var arrBook = [Book]()
    var arrBookBackup = [Book]()
    var cellMarginSize: Float = 5.0
    var isCallApi: Bool = false
    var documentLast: DocumentSnapshot!
    let booksRef = Firestore.firestore().collection("books")
    var searching: Bool = false
    let bookCellReuseIdentifier: String = "BookCell"
    let segueAboutViewIdentifier: String = "HomeToAbout"
    var bookSelected: Book!
    let firebaseService = FireBaseServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Thiết lập data source cho UICollectionView
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        searchbar.delegate = self
        
        //        let nib =  UINib(nibName: "BookCollectionViewCell", bundle: nil)
        //        bookCollectionView.register(nib, forCellWithReuseIdentifier: "BookCell")
        
        // Dang ky layout grid view
        self.setGridView()
        
        
        // Load du lieu sach
        getBooks()
        
    }
    
    
    //MARK: Hien thuc ham uy quyen cho searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        print("tapped")
        
        // an ban phim
        searchbar.resignFirstResponder()
        searchBooks()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            if searching {
                // tat trang thai dang tim kiem
                searching = false
                // lay lai mang sach ban dau
                arrBook = Array(arrBookBackup)
                // load lai du lieu collection
                self.bookCollectionView.reloadData()
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setGridView()
        DispatchQueue.main.async {
            self.bookCollectionView.reloadData()
        }
    }
    
    
    func setGridView() {
        let flow = bookCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrBook.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bookCellReuseIdentifier, for: indexPath) as! BookCollectionViewCell
        cell.setData(book: arrBook[indexPath.row])
        
        //        print("M book la: \(self.arrBook.count)")
        return cell
    }
    
    // goi khi chon 1 cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("index mang la: \(indexPath[1])")
        // gan du lieu sach vua chon de chuyen sang man hinh about
        self.bookSelected = arrBook[indexPath[1]]
        // chuyen man hinh sang man hinh about
        performSegue(withIdentifier: segueAboutViewIdentifier, sender: indexPath)
        
    }
    
    // MARK: An thanh dieu huong o man hinh dau tien
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    //     Lay du lieu cac cuon sach tu firebase theo tu khoa tim kiem
    
    func searchBooks() {
        // gan trang thai dang tim kiem
        
        if let searchText = searchbar.text {
            print("Tu khoa la: \(searchText)")
            
            // luu lai mang sach
            if !searching {
                arrBookBackup = Array(arrBook)
                searching = true
            }
            
            self.firebaseService.searchBooks(searchText: searchText) { (data: [Book], documentLast :DocumentSnapshot?) in
                self.arrBook = Array(data)
                self.bookCollectionView.reloadData()
            }
            
        }
    }
    
    
    //     Lay du lieu cac cuon sach tu firebase
    func getBooks(){
        
        // lay documentLast hien tai
        let last = self.documentLast ?? nil
        
        firebaseService.getDataBooks(documentLast: last) { (data: [Book], documentLast: DocumentSnapshot?) in
            // luu lai documentLast
            if let currentDocumentLast = documentLast {
                self.documentLast = currentDocumentLast
            }
            // them du lieu vao mang sach
            if last != nil {
                self.arrBook = self.arrBook + data
            } else {
                self.arrBook = data
            }
            // load lai view khi co du lieu
            self.bookCollectionView.reloadData()
            // dat lai trang thai goi api
            self.isCallApi = false
        }
    }
    
    //     Lay du lieu cac cuon sach tu firebase trang tiep theo
    //    func getBooksNextPage(){
    //        if let last = self.documentLast {
    //            // set trang thai dang goi api
    //            self.isCallApi = true
    //            firebaseService.getDataBooks(documentLast: last) { (data: [Book], documentLast: DocumentSnapshot?) in
    //                // luu lai documentLast
    //                if let currentDocumentLast = documentLast {
    //                    self.documentLast = currentDocumentLast
    //                }
    //                // them du lieu vao mang sach
    //                self.arrBook = self.arrBook + data
    //                // load lai view khi co du lieu
    //                self.bookCollectionView.reloadData()
    //                // dat lai trang thai goi api
    //                self.isCallApi = false
    //            }
    //        }
    //    }
    
    // Load them du lieu khi keo xuong cuoi
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY + 20 > contentHeight - scrollView.frame.height {
            
            if !isCallApi {
                // dat trang thai dang goi api bang true
                isCallApi = true
                // goi api lay them du lieu
                //                getBooksNextPage()
                getBooks()
            }
            
            // an ban phim
            searchbar.resignFirstResponder()
            
        }
    }
    
    
    // Thay doi noi dung nut back o man hinh tiep theo
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Trở về"
        navigationItem.backBarButtonItem = backItem
        
        // Lay Destination
        if let destination = segue.destination as? AboutViewController {
            destination.book = bookSelected
        }
    }
}

extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = (collectionView.frame.width / numberOfItemsPerRow) - 8.0
        
        //        print("Kich thuoc la:\(bookCollectionView.frame.width) : \(numberOfItemsPerRow) : \(collectionView.frame.width): \(itemWidth)")
        
        return CGSize(width: itemWidth, height: (itemWidth * 2) - (itemWidth / 3))
    }
}

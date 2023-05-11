//
//  ViewController.swift
//  Ios Books
//
//  Created by Long on 4/27/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    //MARK: Properties
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    // du lieu gia
    //    let arrayData: [String] = ["sdd", "DSDSD", "sdd", "DSDSD", "sdd", "DSDSD", "sdd", "DSDSD"]
    //
    let arrayData: [String] = ["DSDSD"]
    
    var limitBookQuery: Int = 9
    var arrBook = [Book]()
    var arrBookBackup = [Book]()
    var cellMarginSize: Float = 5.0
    var isCallApi: Bool = false
    var documentLast: Any?
    let booksRef = Firestore.firestore().collection("books")
    var searching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Thiết lập data source cho UICollectionView
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        searchbar.delegate = self
        
        let nib =  UINib(nibName: "BookCollectionViewCell", bundle: nil)
        bookCollectionView.register(nib, forCellWithReuseIdentifier: "BookCell")
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCollectionViewCell
        cell.setData(book: arrBook[indexPath.row])
        
        //        print("M book la: \(self.arrBook.count)")
        return cell
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
            
            
            let query = self.booksRef
                .order(by: "created", descending: true)
                .whereField("search_key", arrayContains: searchText)
                .limit(to: limitBookQuery)
            
            var resultBooks = [Book]()
            
            query.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching documents: \(error.localizedDescription)")
                    self.arrBook = Array(resultBooks)
                    self.bookCollectionView.reloadData()
                    return
                }
                
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    print("No books found matching the search criteria")
                    self.arrBook = Array(resultBooks)
                    self.bookCollectionView.reloadData()
                    return
                }
                
                
                
                for document in snapshot.documents {
                    let data = document.data()
                    
                    guard
                        let categoryId = data["cate_id"] as? String,
                        let name = data["name"] as? String,
                        let photo = data["photo"] as? String,
                        let about = data["about"] as? String
                        else {
                            continue
                    }
                    
                    let newBook = Book(
                        bookId: document.documentID,
                        categoryId: categoryId,
                        name: name,
                        photo: photo,
                        about: about
                    )
                    
                    if let newBook = newBook {
                        resultBooks.append(newBook)
                    }
                }
                
                print("Total number of books found: \(resultBooks.count)")
                self.arrBook = Array(resultBooks)
                self.bookCollectionView.reloadData()
               
                
            }
            
           
        }
    }
    
    
    //     Lay du lieu cac cuon sach tu firebase
    func getBooks(){
        let query = self.booksRef
            .order(by: "created", descending: true)
            .limit(to: limitBookQuery)
        
        loadDataFromFirebaseToBooks(query: query)
    }
    
    //     Lay du lieu cac cuon sach tu firebase trang tiep theo
    func getBooksNextPage(){
        if let last = self.documentLast {
            let query = self.booksRef
                .order(by: "created", descending: true)
                .start(afterDocument: last as! DocumentSnapshot)
                .limit(to: self.limitBookQuery)
            
            loadDataFromFirebaseToBooks(query: query)
        }
    }
    
    // xu ly du lieu luu vao books
    func loadDataFromFirebaseToBooks (query: Query) {
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching documents: \(error!)")
                return
            }
            
            // Cap nhat document cuoi
            self.documentLast = snapshot.documents.last
            
            //            print("da lieu la \(String(describing: snapshot.documents.last?.data()["name"]))")
            
            // lay du lieu sach ra
            for document in snapshot.documents {
                let data = document.data()
                
                guard
                    let categoryId = data["cate_id"] as? String,
                    let name = data["name"] as? String,
                    let photo = data["photo"] as? String,
                    let about = data["about"] as? String
                    else {
                        continue
                }
                
                let newBook = Book(bookId: document.documentID , categoryId: categoryId, name: name, photo: photo, about: about)
                if let newBook = newBook {
                    // them du lieu vao mang sach
                    self.arrBook.append(newBook)
                    // load lai view khi co du lieu
                    self.bookCollectionView.reloadData()
                    // dat lai trang thai goi api
                    self.isCallApi = false
                }
            }
        }
    }
    
    
    // Load them du lieu khi keo xuong cuoi
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            
            if !isCallApi {
                // dat trang thai dang goi api bang true
                isCallApi = true
                // goi api lay them du lieu
                getBooksNextPage()
            }
            
            // an ban phim
            searchbar.resignFirstResponder()
            
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

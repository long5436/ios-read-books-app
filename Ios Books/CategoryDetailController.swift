//
//  DetailController.swift
//  Ios Books
//
//  Created by hieu on 5/15/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoryDetailController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //MARK: Properties
    @IBOutlet weak var collection: UICollectionView!
    var isCallApi: Bool = false
    var documentLast: DocumentSnapshot!
    var data = [Book]()
    let service = FireBaseServices()
    var category: Category!
    let bookCellReuseIdentifier: String = "BookCell"
    private let categoryBook = Firestore.firestore().collection("books")
    var cellMarginSize: Float = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
        if let category = category {
            navigationItem.title = category.getName()
        }
        self.setGridView()
        DispatchQueue.main.async {
            self.collection.reloadData()
        }
        
        getBookData(nextPage: false)
    }
    
    func setGridView() {
        let flow = collection.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize * 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bookCellReuseIdentifier, for: indexPath) as! BookCollectionViewCell
        cell.setData(book: self.data[indexPath.row])
        
        //        print("M book la: \(self.arrBook.count)")
        return cell
    }
    
    //     Lay du lieu cac cuon sach tu firebase trang tiep theo
    //    func getBooksNextPage(){
    //        if let last = self.documentLast {
    //            let query = self.categoryBook
    //                .order(by: "cate_id", descending: true)
    //                .start(afterDocument: last as! DocumentSnapshot)
    //                .limit(to: 5)
    //
    //            loadDataFromFirebaseToBooks(query: query)
    //        }
    //    }
    
    
    //Xu ly du lieu luu vao sach
    //    func loadDataFromFirebaseToBooks(query: Query) {
    //        query.getDocuments{ (snapshot, error) in
    //            guard let snapshot = snapshot else {
    //                print("Error fetching documents: \(error!)")
    //                return}
    //
    //
    //            var books = [Book]()
    //            //layas du lieu
    //            for document in snapshot.documents{
    //                let data = document.data()
    //
    //                guard
    //                    let categoryId = data["cate_id"] as? String,
    //                    let name = data["name"] as? String,
    //                    let photo = data["photo"] as? String,
    //                    let about = data["about"] as? String
    //                    else {
    //                        continue
    //                }
    //
    //                let newBook = Book(bookId: document.documentID , categoryId: categoryId, name: name, photo: photo, about: about)
    //                if let newBook = newBook {
    //                    // them du lieu vao mang sach
    //                    books.append(newBook)
    //                    //load khi co du lieu
    //                    self.collection.reloadData()
    //
    //                    self.isCallApi = false
    //                }
    //            }
    //        }
    //    }
    
    //Load du lieu khi keo xuong
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        //        print("\(offsetY) , \(contentHeight - scrollView.frame.height)")
        
        if offsetY + 20 > contentHeight - scrollView.frame.height {
            
            if !isCallApi {
                //trang thai api
                isCallApi = true
                //api  them du lieu
                getBookData(nextPage: true)
                
            }
        }
    }
    
    //hien thi thong bao neu load ko co du lieu
    func showAlert() {
        let alert = UIAlertController(title: "Thông Báo", message: "Không có dữ liệu", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: {(show: UIAlertAction) in
            //            print("Show alert")
            if let navigationController = self.navigationController {
                navigationController.popViewController(animated: true)
            }
        }))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //     Lay du lieu cac cuon sach tu firebase
    func getBookData(nextPage: Bool) {
        
        if nextPage {
            //            print(self.documentLast)
            if let last = self.documentLast {
                //                  print("vi daty")
                service.getBooksFromCategory(cateId: self.category.getCategoryId(), documentLast: last) { (books: [Book], documentLast: DocumentSnapshot!) in
                    
                    self.data = self.data + books
                    
                    self.collection.reloadData()
                    self.documentLast = documentLast
                    self.isCallApi = false
                }
            }
        }
        else{
            if let category = self.category {
                service.getBooksFromCategory(cateId: category.getCategoryId(), documentLast: nil) { (books: [Book], documentLast: DocumentSnapshot!) in
                    
                    if books.count == 0 {
                        self.showAlert()
                    }
                    else{
                        self.data = books
                        
                        self.collection.reloadData()
                        self.documentLast = documentLast
                        self.isCallApi = false
                    }
                    
                }
            }
        }
    }
}

extension CategoryDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = (collectionView.frame.width / numberOfItemsPerRow) - 8.0
        
        return CGSize(width: itemWidth, height: (itemWidth * 2) - (itemWidth / 3))
    }
}


//
//  ViewController.swift
//  Ios Books
//
//  Created by Long on 4/27/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
//import Firebase

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    //MARK: Properties
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    let arrayData: [String] = ["sdd", "DSDSD", "sdd", "DSDSD", "sdd", "DSDSD", "sdd", "DSDSD"]
    
    var arrBook = [Book]()
    var estimateWidth = 320.0
    var cellMarginSize = 5.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Thiết lập data source cho UICollectionView
        bookCollectionView.delegate = self
        bookCollectionView.dataSource = self
        
        
        //        let customLayout = BookUICollectionViewLayout()
        // khởi tạo một instance của class tùy chỉnh layout
        
        //        bookCollectionView.setCollectionViewLayout(customLayout, animated: true)
        // gán layout tùy chỉnh cho UICollectionView đã có
        
        let nib =  UINib(nibName: "BookCollectionViewCell", bundle: nil)
        bookCollectionView.register(nib, forCellWithReuseIdentifier: "BookCell")
        //        bookCollectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        
        
        // Dang ky layout grid view
        self.setGridView()
        
        
        
        //        getBooks()
        
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
        return self.arrayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCollectionViewCell
        
        return cell
    }
    

    
    
    
    // Lay du lieu cac cuon sach tu firebase
    //    func getBooks(){
    //        let db = Firestore.firestore()
    //        let booksRef = db.collection("books")
    //        //
    //        booksRef.order(by: "created", descending: true).limit(to: 10).getDocuments() { (querySnapshot, error) in
    //
    //
    //            if let error = error {
    //                print("Error getting documents: \(error)")
    //            } else {
    //                for document in querySnapshot!.documents {
    //                    let data = document.data()
    //
    //                    guard
    //                        let categoryId = data["cate_id"] as? String,
    //                        let name = data["name"] as? String,
    //                        let photo = data["photo"] as? String,
    //                        let about = data["about"] as? String
    //                        else {
    //                            continue
    //                    }
    //
    //
    //                    let newBook = Book(bookId: document.documentID , categoryId: categoryId, name: name, photo: photo, about: about)
    //                    if let newBook = newBook {
    //
    //                        self.arrBook.append(newBook)
    //                    }
    //                }
    //
    //                print("Mang book \(self.arrBook.count)")
    //            }
    //        }
    //    }
    
    
}




extension HomeController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = calculateWith()
//              print("Kich thuoc la: \(width)")
//        return CGSize(width: width, height: width)
//    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = (collectionView.frame.width / numberOfItemsPerRow) - 8.0

        print("Kich thuoc la:\(bookCollectionView.frame.width) : \(numberOfItemsPerRow) : \(collectionView.frame.width): \(itemWidth)")

        return CGSize(width: itemWidth, height: itemWidth)
    }
//
//    func calculateWith() -> CGFloat {
//        let estimatedWidth = CGFloat(self.estimateWidth)
//        let cellCount = floor(CGFloat(self.view.frame.size.width) / estimatedWidth)
//
//        let margin = CGFloat(cellMarginSize * 2)
//        let width = self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin / cellCount
//
//        return width
//    }
}

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
    var bookSelected: Book!
    let segueAboutViewIdentifier: String = "bookDetail"
    
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
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize * 2 + 10)
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
    
    // goi khi chon 1 cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        print("index mang la: \(indexPath[1])")
        // gan du lieu sach vua chon de chuyen sang man hinh about
        self.bookSelected = data[indexPath[1]]
        // chuyen man hinh sang man hinh about
        performSegue(withIdentifier: segueAboutViewIdentifier, sender: indexPath)
        
    }
    
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

extension CategoryDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let itemWidth = (collectionView.frame.width / numberOfItemsPerRow) - 8.0
        
        return CGSize(width: itemWidth, height: (itemWidth * 2) + 2 - (itemWidth / 3))
    }
}


//
//  AboutViewController.swift
//  Ios Books
//
//  Created by Long on 5/13/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    //MARK: Properties
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookLabel: UILabel!
    @IBOutlet weak var bookAbout: UITextView!
    @IBOutlet weak var btnReadBook: UIButton!
    var book: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // load du lieu sach len man hinh
        if let book = book {
//            print("ten sach la: \(book.getName())")
            bookImage.getImageFromCach(imageName: book.getPhoto(), uiImage: bookImage)
            bookLabel.text = book.getName()
            bookAbout.text = book.getAbout()
        }
        
        btnReadBook.layer.cornerRadius = 8
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        let source = segue.source
//
//        print("da vao day \(source)")
//    }
    

}

//
//  BookCollectionViewCell.swift
//  Ios Books
//
//  Created by Long on 5/9/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    //MARK: Properties
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    var bookImageUrl: String?
    var book: Book?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bookImage.layer.cornerRadius = 4
    }
    
    // khoi tao du lieu cho cell sach
    func setData(book: Book) {
        
        self.book = book
        
        if let label = bookName {
            label.text = book.getName()
        }
        
        if let image = bookImage {
            image.getImageFromCach(imageName: book.getPhoto(), uiImage: image)
            
        }
    }
}

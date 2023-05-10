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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // khoi tao du lieu cho cell sach
    func setData(book: Book) {
        if let label = bookName {
            label.text = book.getName()
        }
        
        if let image = bookImage {
            image.getLinkImageFromFirebase(path: book.getPhoto()) { (url) in
                if let url = url {
                    //                    print("url la:  \(url)")
                    //                    self.bookImageUrl = url
                    
                    if let url = URL(string: url) {
                        self.downloadImage(from: url)
                    }
                }
            }
        }
        
//        print("da vo day")
    }
    
    func downloadImage(from url: URL) {
        // Create a Data object to hold the downloaded image data.
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Check for errors when downloading the image.
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            // Check that there is image data.
            guard let data = data else {
//                print("No image data received.")
                return
            }
            
            // Create an image object from the downloaded data.
            guard let image = UIImage(data: data) else {
//                print("Could not create image from data.")
                return
            }
            
            // Display the image on the image view on the main thread.
            DispatchQueue.main.async {
                //                print(image)
                if let bookImage = self.bookImage {
                    bookImage.image = image
                }
            }
        }.resume()
    }
    
}

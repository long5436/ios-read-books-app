//
//  BookCollectionViewCell.swift
//  Ios Books
//
//  Created by Long on 5/9/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var textLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(text: String) {
        if let label = textLabel {
            label.text = text
        }
    }

}

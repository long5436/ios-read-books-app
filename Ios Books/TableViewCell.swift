//
//  TableViewCell.swift
//  Ios Books
//
//  Created by hieu on 5/10/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!


    
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    // khoi tao du lieu cho cell danh muc
    func setData(category: Category) {
        if let label = lblCategory {
            label.text = category.getName()
        }
        
        if let image = imgCategory {
            image.getImageFromCach(imageName: category.getPhoto(), uiImage: image)
            
        }
    }
}

//
//  AccountTableViewCell.swift
//  Ios Books
//
//  Created by hieu on 5/22/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {
    
    
    var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        button = UIButton(type: .system)
        button.setTitle("Button Title", for: .normal)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

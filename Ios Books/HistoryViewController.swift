//
//  HistoryViewController.swift
//  Ios Books
//
//  Created by Long on 5/19/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    //MARK: Propperties
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookPage: UILabel!
    @IBOutlet weak var btnReadBookContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // bo cong nut
        btnReadBookContinue.layer.cornerRadius = 8
        bookImage.layer.cornerRadius = 4
        
        // lam title chu bu
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

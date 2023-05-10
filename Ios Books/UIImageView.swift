//
//  UIImageView.swift
//  Ios Books
//
//  Created by Long on 5/10/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import Firebase

extension UIImageView {
    func getLinkImageFromFirebase(path: String, completion: @escaping (String?) -> Void) {
        // Tạo một đối tượng storage reference
        let storageRef = Storage.storage().reference()

        // Tham chiếu đến ảnh và tải về
        storageRef.child(path).downloadURL { (url, error) in
            if let error = error {
                // Xử lý lỗi
//                print(error.localizedDescription)
                completion(nil)
            } else {
                // Sử dụng url để hiển thị hình ảnh
//                print(url?.absoluteString ?? "")
                completion(url?.absoluteString)
            }
        }
    }
}

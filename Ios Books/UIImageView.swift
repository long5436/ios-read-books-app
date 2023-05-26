//
//  UIImageView.swift
//  Ios Books
//
//  Created by Long on 5/10/23.
//  Copyright © 2023 Long. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import Kingfisher

extension UIImageView {
    
    func loadImage(pathName: String) {
        self.getLinkImageFromFirebase(path: pathName) { url in
            if let value = url {
                let url = URL(string: value)
                self.kf.setImage(with: url)
            }
        }
    }
    
    func getLinkImageFromFirebase(path: String, completion: @escaping (String?) -> Void) {
        // Tạo một đối tượng storage reference
        let storageRef = Storage.storage().reference()
        
        // Tham chiếu đến ảnh và tải về
        storageRef.child(path).downloadURL { (url, error) in
            if error != nil {
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
    
    
    func getImageFromCache(imageName: String) {
    
        // Đường dẫn đến thư mục cache
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        
        // xoa cac ky tu '/' trong ten
        let name = imageName.replacingOccurrences(of: "/", with: "")
        
        // Tạo đường dẫn đến tệp hình ảnh trong thư mục cache
        let imagePath:URL = cacheDirectory.appendingPathComponent(name)
        
        // Kiểm tra xem tệp hình ảnh đã tồn tại trong cache chưa
        if FileManager.default.fileExists(atPath: imagePath.path) {
            // Nếu tệp đã tồn tại, ta sử dụng hình ảnh trong cache
            let image = UIImage(contentsOfFile: imagePath.path)
            
            // print("co anh, da vo day")
            // return image!
            
            self.image = image
            
        }
        else {
            // print("da vao day")
            
            self.getLinkImageFromFirebase(path: imageName as String, completion: { (url) in
                if let url = url {
                    //                    print("url la: \(url)")
                    
                    if let url = URL(string: url) {
                        self.downloadImage(from: url, imagePath: imagePath)
                    }
                }
            })
            
        }
    }
    
    func downloadImage(from url: URL, imagePath: URL) {
        // Create a Data object to hold the downloaded image data.
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Check for errors when downloading the image.
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            // Check that there is image data.
            guard let data = data else {
                // print("No image data received.")
                return
            }
            
            // Create an image object from the downloaded data.
            guard let image = UIImage(data: data) else {
                // print("Could not create image from data.")
                return
            }
            
            // Display the image on the image view on the main thread.
            DispatchQueue.main.async {
                // print(image)
                self.image = image
                if let imageData = image.pngData() {
                    do {
                        // Lưu dữ liệu xuống tệp mới
                        try imageData.write(to: imagePath)
                        // print("Image  saved to cache with new name")
                    } catch {
                        // print("Error saving image to cache: \(error.localizedDescription)")
                    }
                }
            }
        }.resume()
    }
    
}

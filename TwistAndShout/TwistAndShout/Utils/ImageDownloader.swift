//
//  ImageDownloader.swift
//  TwistAndShout
//
//  Created by Ramiro Diaz on 30/11/2022.
//

import Foundation
import UIKit

// Singleton class used to download a simple image from a given URL.
// This was not asked in the assignment as we were only required to display the title,
// but the album image gives the app a nicer look :)

class ImageDownloader {
    
    static let shared = ImageDownloader()

    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            completion(UIImage(data:data))
        }
    }
}

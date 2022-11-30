//
//  NetworkManager.swift
//  TwistAndShout
//
//  Created by Ramiro Diaz on 30/11/2022.
//

import Foundation
import Alamofire

// Singleton class I created to make the API call to get the beatles albums!

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    fileprivate let baseUrl = "https://itunes.apple.com/search?term=thebeatles&media=music&entity=album&attribute=artistTerm"
    
    private override init() { }
    
    func getBeatlesAlbum(completion: @escaping ([Album]?) -> Void) {
        AF.request(self.baseUrl , method: .get, parameters: nil,
            encoding: URLEncoding.default, headers: nil,
            interceptor: nil).response { (responseData) in
                guard let data = responseData.data else {
                    completion(nil)
                    return
                }
                do {
                    let albums = try JSONDecoder().decode(AllAlbums.self, from: data)
                    completion(albums.albums)
                } catch {
                    print("Error decoding album == \(error)")
                    completion(nil)
                }
        }
    }
}

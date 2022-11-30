//
//  AlbumDataSource.swift
//  TwistAndShout
//
//  Created by Ramiro Diaz on 30/11/2022.
//

import Foundation
import UIKit

// This protocol is used to update the View controller via delegation pattern
protocol DataSourceObserver : NSObject {
    func dataSourceUpdated()
    func dataSourceFailed()
}

class AlbumDataSource : NSObject {
    
    weak var observer: DataSourceObserver?
    var albums: [Album]
    
    init(observer: DataSourceObserver){
        self.observer = observer
        self.albums = []
                
        super.init()
        
        loadAlbums()
    }
    
    func loadAlbums() {
        // Using the singleton class we created to fetch the album data
        NetworkManager.shared.getBeatlesAlbum() { (albums) in
            guard let safeAlbums = albums, !safeAlbums.isEmpty else {
                self.observer?.dataSourceFailed()
                return
            }
            // Here we could sort the albums by title or release date, but it wasn't mentioned in the assignment.
            //let sorted = safeAlbums.sorted(by: { $0.title! < $1.title! })
            self.albums = safeAlbums
            self.observer?.dataSourceUpdated()
        }
    }
}

// As assigned in the view controller, this datasource is responsible for the datasourcing of the tableview, so here are the methods implemented
extension AlbumDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseIdentifier(), for: indexPath) as! AlbumTableViewCell
        let album = albums[indexPath.row]
        cell.configureWith(album: album)

        return cell
    }
}

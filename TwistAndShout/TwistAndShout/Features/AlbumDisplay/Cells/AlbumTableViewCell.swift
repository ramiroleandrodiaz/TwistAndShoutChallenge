//
//  AlbumTableViewCell.swift
//  TwistAndShout
//
//  Created by Ramiro Diaz on 30/11/2022.
//

import Foundation
import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumArtist: UILabel!
    @IBOutlet weak var albumReleaseDate: UILabel!
    
    // We use an activithy indicator for the album artwork
    fileprivate var activityIndicator = UIActivityIndicatorView()

    
    // Exposing the reuse identifier of the cell
    class func reuseIdentifier() -> String{
        return String(describing: AlbumTableViewCell.self)
    }
    
    override func awakeFromNib() {
        // Here we could make all the labels and artwork hidden as default, but still is not very relevant
    }
    
    func configureWith(album : Album){
        if let title = album.title, !title.isEmpty {
            self.albumTitle.isHidden = false
            self.albumTitle.text = title
        } else {
            self.albumTitle.isHidden = true
        }
        
        if let artist = album.artist, !artist.isEmpty {
            self.albumArtist.isHidden = false
            self.albumArtist.text = artist
        } else {
            self.albumArtist.isHidden = true
        }
        
        if let dateString = album.releaseDate, !dateString.isEmpty {
            // Here we use 2 date formatters, since we get the date in the first format and
            // Then we convert it to the second, more legible format.
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd/MM/yyyy"
            
            let date = dateFormatterGet.date(from: dateString)
            if let date = date {
                let text = dateFormatterPrint.string(from: date)
                if !text.isEmpty {
                    self.albumReleaseDate.isHidden = false
                    self.albumReleaseDate.text = "Released on \(text)"
                } else {
                    self.albumReleaseDate.isHidden = true
                }
            }
        } else {
            self.albumReleaseDate.isHidden = true
        }
        
        if let artworkUrl = album.artwork, !artworkUrl.isEmpty, let url = URL(string: artworkUrl) {
            // We create an activity indicator for the image if it takes long to load
            self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
            self.activityIndicator.hidesWhenStopped = true
            self.albumArt.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            // Then we use the method from the singleton class we created
            ImageDownloader.shared.downloadImage(from: url) { [weak self] (image) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.albumArt.isHidden = false
                    self.albumArt.image = image
                    self.activityIndicator.stopAnimating()  // Stopping the activity indicator
                }
            }
        } else {
            self.albumArt.isHidden = true
        }
    }
}

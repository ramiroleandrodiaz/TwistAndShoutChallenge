//
//  File.swift
//  TwistAndShout
//
//  Created by Ramiro Diaz on 30/11/2022.
//

// Model for the album so we can parse it from the JSON response.
// We implement Decodable for ease of use.

struct AllAlbums: Decodable {
    var albums: [Album]?
    
    enum CodingKeys: String, CodingKey {
        case albums = "results"
    }
}

struct Album: Decodable {
    var title: String?
    var artist: String?
    var artwork: String?
    var tracks: Int?
    var copyright: String?
    var releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "collectionName"
        case artist = "artistName"
        case artwork = "artworkUrl100"
        case tracks = "trackCount"
        case copyright = "copyright"
        case releaseDate = "releaseDate"
    }
    
}

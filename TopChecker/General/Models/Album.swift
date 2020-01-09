//
//  Album.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import Foundation
import Combine

enum FeedType: String, Codable {
    case itunes = "itunes-music"
    case appleMusic = "apple-music"
}

struct AlbumsResponse: Decodable {
    let feed: Feed
    
    enum CodingKeys: String, CodingKey {
        case feed = "feed"
    }
}

struct Feed: Codable, Hashable {
    let albums: [Album]?
    
    enum CodingKeys: String, CodingKey {
        case albums = "results"
    }
}

struct Album: Codable, Hashable {
    let albumId: String
    let artistName: String
    let releaseDate: String
    let name: String
    let copyright: String?
    let artistUrl: String
    let artworkUrl100: String
    let genres: [Genre]?
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case artistName = "artistName"
        case albumId = "id"
        case releaseDate = "releaseDate"
        case name = "name"
        case copyright = "copyright"
        case artistUrl = "artistUrl"
        case artworkUrl100 = "artworkUrl100"
        case genres = "genres"
        case url = "url"
    }
}

struct Genre: Codable, Hashable {
    let name: String?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
    }
}

extension Album {
    static let mock =
        Album(
            albumId: "1484742845",
            artistName: "Tame Impala",
            releaseDate: "2020-02-14",
            name: "The Slow Rush",
            copyright: "An Island Records Australia release; ℗ 2019 Modular Recordings Pty Ltd",
            artistUrl: "https://music.apple.com/us/artist/tame-impala/290242959?app=music",
            artworkUrl100: "https://is4-ssl.mzstatic.com/image/thumb/Music123/v4/a3/d2/fc/a3d2fc93-8911-6f99-854a-8b2a107450d6/19UMGIM96748.rgb.jpg/200x200bb.png",
            genres: [
                Genre(name: "Alternative", url: "https://itunes.apple.com/us/genre/id20"),
                Genre(name: "Music", url: "https://itunes.apple.com/us/genre/id34")
            ],
            url: "https://music.apple.com/us/album/the-slow-rush/1484742845?app=music"
    )
}



struct AlbumService {
    private enum Constants {
        static let count = 100
    }
    
    //https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/25/non-explicit.json
    func fetch(query: String, feedType: FeedType = .appleMusic, page: Int = 1) -> AnyPublisher<[Album], Error> {
        var components = URLComponents()

        //This is because the mapping between itunes and apple music isn't 1:1 even though the returns types are.
        var query = query
        if feedType == .itunes {
            if  query == "new-releases" {
                query = "recent-releases"
            }

            if query == "coming-soon" {
                query = "new-music"
            }
        }

        components.scheme = "https"
        components.host = "rss.itunes.apple.com"
        components.path = "/api/v1/us/\(feedType.rawValue)/\(query)/all/\(Constants.count)/non-explicit.json"
        
        print(components)
        
        guard let url = components.url else {
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: URLRequest(url: url))
            .map { $0.data }
            .decode(type: AlbumsResponse.self, decoder: Current.decoder)
            .compactMap { $0.feed.albums }
            .eraseToAnyPublisher()
    }
}

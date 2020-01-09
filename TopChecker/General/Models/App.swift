//
//  App.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//

struct AppState: Codable {
    var allAlbums: [String: Album] = [:]
    var albums: [String] = []
    var favorited: [String] = []
    var feedType: FeedType = .appleMusic
}

enum AppAction {
    case append(albums: [Album])
    case saveToFavorites(album: Album)
    case removeFromFavorites(album: Album)
    case setFeedType(FeedType)
    case resetState
}

let appReducer: Reducer<AppState, AppAction> = Reducer { state, action in
    switch action {
    case let .append(albums):
        albums.forEach { state.allAlbums[$0.albumId] = $0 }
        state.albums = albums.map { $0.albumId }
    
    case let .saveToFavorites(album):
        state.favorited.append(album.albumId)
   
    case let .removeFromFavorites(album):
        state.favorited.removeAll { $0 == album.albumId }
    
    case .resetState:
        state.albums.removeAll()
    
    case .setFeedType(let feed):
        state.feedType = feed
    }
}

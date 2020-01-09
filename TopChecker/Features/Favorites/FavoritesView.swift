//
//  FavoritesView.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>

    private var favorites: [Album] {
        store.state.favorited.compactMap {
            store.state.allAlbums[$0]
        }
    }

    var body: some View {
        AlbumsView(albums: favorites)
            .navigationBarTitle("Favorites")
    }
}

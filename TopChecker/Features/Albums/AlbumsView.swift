//
//  AlbumsView.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import KingfisherSwiftUI
import SwiftUI

struct AlbumsContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    let query: String

    private var albums: [Album] {
        store.state.albums.compactMap {
            store.state.allAlbums[$0]
        }
    }

    var body: some View {
        AlbumsView(albums: albums)
            .navigationBarTitle(Text(query.capitalized.replacingOccurrences(of: "-", with: " ")), displayMode: .large)
            .onAppear(perform: fetch)
    }

    private func fetch() {
        store.send(SideEffect.search(query: query, feedType: store.state.feedType))
    }
}

struct AlbumsView: View {
    let albums: [Album]

    private var list: some View {
        List {
            ForEach(albums, id: \.albumId) { album in
                NavigationLink(destination: AlbumDetailsContainerView(album: album)) {
                    ZStack(alignment: .bottomLeading, content: {
                        KFImage(URL(string: album.artworkUrl100))
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                        LinearGradient(gradient: .init(colors: [Color.clear, .gray]), startPoint: .center, endPoint: .bottom)
                        Text(album.name.uppercased())
                            .font(Font.custom("HelveticaNeue-Bold", size: 26.0))
                            .foregroundColor(.white)
                            .padding()
                        })
                        .cornerRadius(10)
                }
            }
        }
    }

    var body: some View {
        Group {
            if albums.isEmpty {
                ActivityView()
            } else {
                list
            }
        }
    }
}

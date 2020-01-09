//
//  AlbumDetailsView.swift
//  Top Checker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import KingfisherSwiftUI
import SwiftUI

//MARK:- Overview Container view
struct AlbumDetailsContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var shareShown = false
    @State private var itunesShown = false

    var album: Album = Album.mock

    private var isFavorited: Bool {
        store.state.favorited.contains(album.albumId)
    }

    var body: some View {
        AlbumDetailsView(album: album, openAlbum: {
            //Version 1 -- to show custom functions in swiftui
            self.openItunes(to: self.album)

            //Version 2 -- to show custom view controller in swiftUI
            //self.itunesShown = true
        })
            .navigationBarItems(
                trailing: HStack(spacing: 16) {
                    Button(action: {
                        if self.isFavorited {
                            self.store.send(.removeFromFavorites(album: self.album))
                        } else {
                            self.store.send(.saveToFavorites(album: self.album))
                        }
                    }, label: {
                        Image(systemName: isFavorited ? "heart.fill" : "heart").font(.headline)
                    })

                    
                    Button(action: {
                        self.shareShown = true
                    }) {
                        Image(systemName: "square.and.arrow.up").accessibility(label: Text("share"))
                    }.sheet(isPresented: $shareShown) {
                        ShareView(activityItems: [self.album.url])
                    }
                }
        ).sheet(isPresented: $itunesShown) {
            SafariView(url: URL(string: self.album.url.replacingOccurrences(of: "?app=music", with: ""))!)
                .navigationBarTitle(Text(self.album.name), displayMode: .inline)
                .accentColor(.orange)
        }

    }

    func openItunes(to album: Album) {
        //This is the standard url like: https://music.apple.com/us/album/the-kacey-musgraves-christmas-show/1488044511
        //But you could also switch https:// with itms:// and open it directly. They match schemes.
        let url = URL(string: album.url.replacingOccurrences(of: "?app=music", with: ""))
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
}
//MARK:- Main view

struct AlbumDetailsView: View {
    let album: Album
    let openAlbum: () -> Void
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM dd,yyyy"
        return df
    }()

    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                ZStack {
                    if geometry.frame(in: .global).minY <= 0 {
                        KFImage(URL(string: self.album.artworkUrl100))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(y: geometry.frame(in: .global).minY/9)
                            .clipped()
                    } else {
                        KFImage(URL(string: self.album.artworkUrl100))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height + geometry.frame(in: .global).minY)
                            .clipped()
                            .offset(y: -geometry.frame(in: .global).minY)
                    }
                }
            }
            .frame(height: 350)

            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading) {
                    Text(self.album.name)
                        .font(Font.custom("HelveticaNeue-Bold", size: 26.0))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()

                    Text("\(self.album.artistName)")
                        .font(Font.custom("HelveticaNeue", size: 22.0))
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()

                    Text("\(Date.getFormattedDate(self.album.releaseDate))")
                        .font(Font.custom("HelveticaNeue", size: 20.0))
                        .fixedSize(horizontal: false, vertical: true)
                }

                //To center the button horizontally we add spacers
                HStack(alignment: .center, spacing: 10) {
                    Spacer()
                    Button(action: self.openAlbum) {
                        Text("iTunes")
                    }.buttonStyle(StandardButtonStyle())
                    Spacer()
                }
            }.padding(.horizontal)

            Spacer()
            Spacer()
            Spacer()
            Text("\(album.copyright ?? "")")
                .font(Font.custom("HelveticaNeue", size: 12.0))
                .fixedSize(horizontal: false, vertical: true)
                .padding()
        }
    }
}

struct AlbumDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumDetailsView(
            album: .mock,
            openAlbum: {
                print("Open album")
        }
        )
    }
}
extension Date {
    static func getFormattedDate(_ stringDate: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"

        if let date = dateFormatterGet.date(from: stringDate) {
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
}

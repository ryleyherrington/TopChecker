//
//  HomeView.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import SwiftUI

//MARK:- Overview Container view
struct HomeContainerView: View {
    @EnvironmentObject var store: Store<AppState, AppAction>
    @State private var favoritesShown = false

    private var hasFavorites: Bool {
        !store.state.favorited.isEmpty
    }

    private var feed: Binding<FeedType> {
        store.binding(for: \.feedType) { .setFeedType($0) }
    }

    var body: some View {
        HomeView(feedType: feed)
            .onAppear { self.store.send(.resetState) }
            .navigationBarTitle("Albums")
            .navigationBarItems(
                trailing: hasFavorites ? Button(action: { self.favoritesShown = true }) {
                    Image(systemName: "heart.fill")
                        .font(.headline)
                        .accessibility(label: Text("favorites"))
                } : nil
        ).sheet(isPresented: $favoritesShown) {
                FavoritesView()
                    .environmentObject(self.store)
                    .embedInNavigation()
                    .accentColor(.orange)
        }
    }
}

//MARK:- Category View

struct CategoryView: View {
    let category: Category
    let gradientColors: (Color, Color)

    //Animation property
    @State private var dragAmount = CGSize.zero

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            ZStack(alignment: .bottomLeading) {
                LinearGradient(
                    gradient: Gradient(colors: [gradientColors.0, gradientColors.1]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                LinearGradient(
                    gradient: .init(colors: [Color.clear, .secondary]),
                    startPoint: .center,
                    endPoint: .bottom
                )
                
                Text(LocalizedStringKey(category.title))
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
            }
            .cornerRadius(10)
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { self.dragAmount = $0.translation }
                    .onEnded { _ in self.dragAmount = .zero }
            )
                .animation(.spring())

            Spacer()
        }
    }
}

//MARK:- Main view

struct HomeView: View {
    @Binding var feedType: FeedType

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Picker(selection: $feedType, label: Text("feed")) {
                    Text(LocalizedStringKey(FeedType.itunes.rawValue))
                        .tag(FeedType.itunes)
                    Text(LocalizedStringKey(FeedType.appleMusic.rawValue))
                        .tag(FeedType.appleMusic)
                }
                .labelsHidden()
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                ForEach(0..<Home.categories.count) { index in
                    NavigationLink(destination: AlbumsContainerView(query: Home.categories[index].query)) {
                        CategoryView(category: Home.categories[index], gradientColors: (Color(UIColor.random()), Color(UIColor.random())))
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(feedType: .init(get: { .itunes }, set: { _ in }))
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        //Gives bright random colors. It's just for random view background colors since we don't have images
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
}

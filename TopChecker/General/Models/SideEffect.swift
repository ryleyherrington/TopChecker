//
//  SideEffect.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import Combine

enum SideEffect: Effect {
    case search(query: String, feedType: FeedType, page: Int = 0)

    func mapToAction() -> AnyPublisher<AppAction, Never> {
        switch self {
        case let .search(query, feedType, page):
            return Current.fetch(query, feedType, page)
                .replaceError(with: [])
                .map { .append(albums: $0)}
                .eraseToAnyPublisher()
        }
    }
}

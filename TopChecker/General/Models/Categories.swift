//
//  Categories.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import Foundation

struct Home {
    static let categories = [
        Category(title: "Top Albums", query: "top-albums"),
        Category(title: "Coming Soon", query: "coming-soon"),
        Category(title: "New Releases", query: "new-releases"),
    ]
}

struct Category {
    let title: String
    let query: String
}

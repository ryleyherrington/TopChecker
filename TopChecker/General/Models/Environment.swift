
//
//  Environment.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/10/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import Foundation
import Combine

struct Environment {
    var decoder = JSONDecoder()
    var encoder = JSONEncoder()
    var fetch = AlbumService().fetch
    var files = FileManager.default
}

var Current = Environment()

//
//  SafariView.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/17/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {

       return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}

//
//  RootView.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/19/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        NavigationView {
            HomeContainerView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

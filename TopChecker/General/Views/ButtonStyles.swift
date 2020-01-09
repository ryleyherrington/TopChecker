//
//  ButtonStyles.swift
//  TopChecker
//
//  Created by Ryley Herrington on 11/17/19.
//  Copyright © 2019 Ryley Herrington. All rights reserved.
//
import SwiftUI

struct StandardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .multilineTextAlignment(.center)
            .fixedSize()
            .padding()
            .foregroundColor(configuration.isPressed ? .gray : .white)
            .background(Color.accentColor)
            .cornerRadius(10)
    }
}

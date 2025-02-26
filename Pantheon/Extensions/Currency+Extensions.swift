//
//  Currency+Extensions.swift
//  Pantheon
//
//  Created by Kjetil Haug Terjesen on 26/02/2025.
//

import Foundation

import SwiftUI

/// For accessibility
extension Double {
    func currencyText() -> Text {
        let formattedValue = NumberFormatter.currencyFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
        let normalText = "\(formattedValue) kr"
        let accessibleText = "\(formattedValue) kroner"

        return Text(normalText)
            .accessibilityLabel(accessibleText)
    }
}

extension NumberFormatter {
    static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

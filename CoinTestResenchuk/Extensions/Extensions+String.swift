//
//  Extensions+String.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/17/22.
//

import Foundation

extension String {
    func toUSCurrencyFormat() -> String {
        if let doubleValue = Double(self) {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "en_US")
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? ""
        }
        return ""
    }
    func toPercentFormat() -> String {
        if let doubleValue = Double(self) {
            let symbol = doubleValue > 0.0 ? "+" : ""
            let percentFormatter = NumberFormatter()
            percentFormatter.numberStyle = NumberFormatter.Style.percent
            percentFormatter.multiplier = 1
            percentFormatter.minimumFractionDigits = 1
            percentFormatter.maximumFractionDigits = 2
            return symbol + (percentFormatter.string(from: NSNumber(value: doubleValue)) ?? "")
        }
        return ""
    }
}

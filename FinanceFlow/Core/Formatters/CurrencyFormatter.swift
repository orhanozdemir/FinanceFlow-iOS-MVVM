//
//  CurrencyFormatter.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import Foundation

struct CurrencyFormatter {
    
    static func format(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₺"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: value)) ?? "₺0.00"
    }
}

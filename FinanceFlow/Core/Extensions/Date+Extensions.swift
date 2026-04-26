//
//  Date+Extensions.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

extension Date {
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }
}

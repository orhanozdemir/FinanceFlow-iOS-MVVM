//
//  DateRangeFilter.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Foundation

enum DateRangeFilter: Hashable {
    case all
    case thisMonth
    case last30Days
    case custom(start: Date, end: Date)
}

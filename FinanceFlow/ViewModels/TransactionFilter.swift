//
//  TransactionFilter.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

enum TransactionFilter: String, CaseIterable, Equatable {
    case all
    case income
    case expense
    
    var displayName: String {
        switch self {
        case .all:
            return "Tümü"
        case .income:
            return "Gelir"
        case .expense:
            return "Gider"
        }
    }
}

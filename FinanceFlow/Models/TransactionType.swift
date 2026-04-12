//
//  TransactionType.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import Foundation

enum TransactionType: String, Codable, CaseIterable, Equatable {
    case income
    case expense
    
    var displayName: String {
        switch self {
            case .income:
                return "Gelir"
            case .expense:
                return "Gider"
        }
    }
}

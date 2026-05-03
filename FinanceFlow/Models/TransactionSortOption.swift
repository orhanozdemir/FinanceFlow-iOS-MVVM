//
//  TransactionSortOption.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Foundation

enum TransactionSortOption: String, CaseIterable {
    case dateDescending
    case dateAscending
    case amountDescending
    case amountAscending
    
    var displayName: String {
        switch self {
        case .dateDescending:
            return "En Yeni"
        case .dateAscending:
            return "En Eski"
        case .amountDescending:
            return "Tutar (Büyük -> Küçük)"
        case .amountAscending:
            return "Tutar (Küçük -> Büyük)"
        }
    }
}

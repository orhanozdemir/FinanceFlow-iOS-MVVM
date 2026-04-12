//
//  TransactionCategory.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

enum TransactionCategory: String, Codable, CaseIterable, Equatable {
    case salary
    case freelance
    case gift
    
    case food
    case transportation
    case shopping
    case bills
    case health
    case entertainment
    
    case other
    
    var displayName: String {
        switch self {
            case .salary: return "Maaş"
            case .freelance: return "Serbest İş"
            case .gift: return "Hediye"
            case .food: return "Yiyecek"
            case .transportation: return "Ulaşım"
            case .shopping: return "Alışveriş"
            case .bills: return "Faturalar"
            case .health: return "Sağlık"
            case .entertainment: return "Eğlence"
            case .other: return "Diğer"
        }
    }
    
    var supportedType: TransactionType {
        switch self {
            case .salary, .freelance, .gift: return .income
            case .food, .transportation, .shopping, .bills, .health, .entertainment, .other: return .expense
        }
    }
    
    static func categories(for type: TransactionType) -> [TransactionCategory] {
        allCases.filter { $0.supportedType == type }
    }
    
}

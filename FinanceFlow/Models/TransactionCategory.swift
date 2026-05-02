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
    case companyPayment
    
    case food
    case transportation
    case shopping
    case groceries
    case education
    case bills
    case health
    case entertainment
    case household
    case credit
    case electronics
    case companyCost
    case investment
    
    case other
    
    var displayName: String {
        switch self {
            case .salary: return "Maaş"
            case .freelance: return "Serbest İş"
            case .companyPayment: return "Şirket Ödemesi"
            case .gift: return "Hediye"
            case .food: return "Yiyecek"
            case .transportation: return "Ulaşım"
            case .shopping: return "Alışveriş"
            case .groceries: return "Market"
            case .education: return "Eğitim"
            case .bills: return "Faturalar"
            case .health: return "Sağlık"
            case .entertainment: return "Eğlence"
            case .household: return "Konaklama"
            case .credit: return "Kredi"
            case .electronics: return "Elektronik"
            case .other: return "Diğer"
            case .companyCost: return "Şirket Masrafı"
            case .investment: return "Yatırım"
        }
    }
    
    var supportedType: TransactionType {
        switch self {
        case .salary, .freelance, .companyPayment: return .income
        case .food, .transportation, .shopping, .bills, .health, .entertainment, .household, .credit, .electronics, .companyCost, .investment, .gift, .groceries, .education, .other: return .expense
        }
    }
    
    static func categories(for type: TransactionType) -> [TransactionCategory] {
        allCases.filter { $0.supportedType == type }
    }
    
}

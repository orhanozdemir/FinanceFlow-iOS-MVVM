//
//  AddTransactionError.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import Foundation

enum AddTransactionError: LocalizedError {
    case emptyTitle
    case invalidAmount
    case invalidCategory
    
    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Başlık boş olamaz."
        case .invalidAmount:
            return "Geçerli bir tutar giriniz."
        case .invalidCategory:
            return "Seçilen kategori işlem türüyle uyumlu değil."
        }
    }
}

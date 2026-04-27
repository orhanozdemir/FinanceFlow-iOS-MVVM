//
//  AddBudgetError.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

enum AddBudgetError: LocalizedError, Equatable {
    case invalidLimit
    case duplicateBudget
    
    var errorDescription: String? {
        switch self {
        case .invalidLimit:
            return "Geçerli bir bütçe limiti giriniz."
        case .duplicateBudget:
            return "Bu kategori için seçilen ayda zaten bütçe tanımlanmış."
        }
    }
}

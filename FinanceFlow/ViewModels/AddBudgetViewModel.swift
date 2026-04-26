//
//  AddBudgetViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation
import Combine

final class AddBudgetViewModel: ObservableObject {
    @Published var category: TransactionCategory = .food
    @Published var limitText: String = ""
    @Published var monthDate: Date = .now
    
    var expenseCategories: [TransactionCategory] {
        TransactionCategory.allCases.filter { $0.supportedType == .expense }
    }
    
    var isFormValid: Bool {
        parsedLimit != nil && (parsedLimit ?? 0) > 0
    }
    
    private var parsedLimit: Double? {
        let normalized = limitText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        
        return Double(normalized)
    }
    
    func makeBudget() throws -> Budget {
        guard let limit = parsedLimit, limit > 0 else {
            throw AddBudgetError.invalidLimit
        }
        
        return Budget(
            category: category,
            monthlyLimit: limit,
            monthDate: monthDate.startOfMonth
        )
    }
}

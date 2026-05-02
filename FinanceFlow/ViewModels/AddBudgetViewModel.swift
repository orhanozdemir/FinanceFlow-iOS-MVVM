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
    @Published var hasAttemptedSubmit: Bool = false
    
    var expenseCategories: [TransactionCategory] {
        TransactionCategory.allCases.filter { $0.supportedType == .expense }
    }
    
    var isFormValid: Bool {
        parsedLimit != nil && (parsedLimit ?? 0) > 0
    }
    
    var limitValidationMessage: String? {
        if limitText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Limit alanı boş bırakılamaz."
        }
        
        guard let limit = parsedLimit else {
            return "Limit sayısal bir değer olmalıdır."
        }
        
        if limit <= 0 {
            return "Limit 0'dan büyük olmalıdır."
        }
        
        return nil
    }
    
    var firstValidationMessage: String? {
        guard hasAttemptedSubmit else { return nil }
        return limitValidationMessage
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
    
    func hasDuplicateBudget(in budgets: [Budget]) -> Bool {
        let calendar = Calendar.current
        
        return budgets.contains { budget in
            budget.category == category &&
            calendar.isDate(budget.monthDate, equalTo: monthDate.startOfMonth, toGranularity: .month)
        }
    }
}

//
//  EditBudgetViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import Foundation
import Combine

final class EditBudgetViewModel: ObservableObject {
    @Published var category: TransactionCategory
    @Published var limitText: String
    @Published var monthDate: Date
    
    private let originalBudget: Budget
    
    init(budget: Budget) {
        self.originalBudget = budget
        self.category = budget.category
        self.limitText = String(format: "%.2f", budget.monthlyLimit)
        self.monthDate = budget.monthDate
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
    
    func hasDuplicateBudget(in budgets: [Budget]) -> Bool {
        let calendar = Calendar.current
        let selectedMonth = monthDate.startOfMonth
        
        return budgets.contains { budget in
            budget.id != originalBudget.id &&
            budget.category == category &&
            calendar.isDate(budget.monthDate, equalTo: selectedMonth, toGranularity: .month)
        }
    }
    
    func updateBudget() throws {
        guard let limit = parsedLimit, limit > 0 else {
            throw AddBudgetError.invalidLimit
        }
        
        originalBudget.category = category
        originalBudget.monthlyLimit = limit
        originalBudget.monthDate = monthDate.startOfMonth
    }
}

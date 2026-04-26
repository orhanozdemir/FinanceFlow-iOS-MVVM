//
//  BudgetListViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

final class BudgetListViewModel {
    func currentMonthBudgets(from budgets: [Budget]) -> [Budget] {
        let calendar = Calendar.current
        
        return budgets.filter { budget in
            calendar.isDate(budget.monthDate, equalTo: Date(), toGranularity: .month)
        }
    }
    
    func spentAmount(for budget: Budget, transactions: [Transaction]) -> Double {
        let calendar = Calendar.current
        
        return transactions
            .filter { transaction in
                transaction.type == .expense &&
                transaction.category == budget.category &&
                calendar.isDate(transaction.date, equalTo: budget.monthDate, toGranularity: .month)
            }
            .reduce(0) {$0 + $1.amount}
    }
    
    func makeStatus(for budget: Budget, transactions: [Transaction]) -> BudgetStatus {
        let spent = spentAmount(for: budget, transactions: transactions)
        let remaining = budget.monthlyLimit - spent
        let progress = budget.monthlyLimit > 0 ? spent / budget.monthlyLimit : 0
        let exceeded = spent > budget.monthlyLimit
        
        return BudgetStatus(
            id: budget.id,
            budget: budget,
            spentAmount: spent,
            remainingAmount: remaining,
            progress: progress,
            isExceeded: exceeded
        )
    }
    
    func statuses(from budgets: [Budget], transactions: [Transaction]) -> [BudgetStatus] {
        currentMonthBudgets(from: budgets)
            .map { makeStatus(for: $0, transactions: transactions) }
            .sorted { $0.budget.category.displayName < $1.budget.category.displayName }
    }
}

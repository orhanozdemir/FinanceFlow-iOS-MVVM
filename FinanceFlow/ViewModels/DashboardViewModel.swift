//
//  DashboardViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

final class DashboardViewModel {
    func totalIncomeThisMonth(from transactions: [Transaction]) -> Double {
        let currentMonthTransactions = transactionsInCurrentMonth(from: transactions)
        
        return currentMonthTransactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    func totalExpenseThisMonth(from transactions: [Transaction]) -> Double {
        let currentMonthTransactions = transactionsInCurrentMonth(from: transactions)
        
        return currentMonthTransactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    func netBalanceThisMonth(from transactions: [Transaction]) -> Double {
        totalIncomeThisMonth(from: transactions) - totalExpenseThisMonth(from: transactions)
    }
    
    func recentTransactions(from transactions: [Transaction], limit: Int = 5) -> [Transaction] {
        Array(transactions.prefix(limit))
    }
    
    func categorySpendingSummaries(from transactions: [Transaction]) -> [CategorySpendingSummary] {
        let currentMontExpenseTransactions = transactionsInCurrentMonth(from: transactions)
            .filter { $0.type == .expense }
        
        let grouped = Dictionary(grouping: currentMontExpenseTransactions, by: {$0.category })
        
        return grouped.map { category, transactions in
            let total = transactions.reduce(0) { $0 + $1.amount }
            return CategorySpendingSummary(category: category, totalAmount: total)
        }
        .sorted { $0.totalAmount > $1.totalAmount }
    }
    
    private func transactionsInCurrentMonth(from transactions: [Transaction]) -> [Transaction] {
        let calendar = Calendar.current
        
        return transactions.filter { transaction in
            calendar.isDate(transaction.date, equalTo: Date(), toGranularity: .month)
        }
    }
    
    func exceededBudgets(
        budgets: [Budget],
        transactions: [Transaction]
    ) -> [BudgetStatus] {
        let budgetViewModel = BudgetListViewModel()
        
        return budgetViewModel
            .statuses(from: budgets, transactions: transactions)
            .filter { $0.isExceeded }
    }
}

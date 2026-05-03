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
    
    func totalIncomePreviousMonth(from transactions: [Transaction]) -> Double {
        transactionsInPreviousMonth(from: transactions)
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }
    
    func totalExpensePreviousMonth(from transactions: [Transaction]) -> Double {
        transactionsInPreviousMonth(from: transactions)
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
    
    func expenseChangePercentage(from transactions: [Transaction]) -> Double? {
        let current = totalExpenseThisMonth(from: transactions)
        let previous = totalExpensePreviousMonth(from: transactions)
        
        guard previous > 0 else { return nil }
        
        return ((current - previous) / previous) * 100
    }
    
    func averageExpenseThisMonth(from transactions: [Transaction]) -> Double {
        let expenses = transactionsInCurrentMonth(from: transactions)
            .filter { $0.type == .expense }
        
        guard !expenses.isEmpty else { return 0 }
        
        let total = expenses.reduce(0) { $0 + $1.amount }
        
        return total / Double(expenses.count)
    }
    
    func topSpendingCategory(from transactions: [Transaction]) -> CategorySpendingSummary? {
        categorySpendingSummaries(from: transactions).first
    }
    
    func dashboardInsights(from transactions: [Transaction]) -> [DashboardInsight] {
        var insights: [DashboardInsight] = []
        
        if let topCategory = topSpendingCategory(from: transactions) {
            insights.append(
                DashboardInsight(
                    title: "En Çok Harcanan Kategori",
                    value: topCategory.category.displayName,
                    description: "\(CurrencyFormatter.format(topCategory.totalAmount)) harcama yapıldı.",
                    type: .neutral
                )
            )
        }
        
        if let change = expenseChangePercentage(from: transactions) {
            let isIncrease = change > 0
            
            insights.append(
                DashboardInsight(
                    title: "Gider Değişimi",
                    value: "\(abs(change).formatted(.number.precision(.fractionLength(1))))%",
                    description: isIncrease
                    ? "Geçen aya göre giderlerin arttı."
                    : "Geçen aya göre giderlerin azaldı.",
                    type: isIncrease ? .negative : .positive
                )
            )
        }
        
        let averageExpense = averageExpenseThisMonth(from: transactions)
        
        if averageExpense > 0 {
            insights.append(
                DashboardInsight(
                    title: "Ortalama Gider",
                    value: CurrencyFormatter.format(averageExpense),
                    description: "Bu ayki gider işlemlerinin ortalama tutarı.",
                    type: .neutral
                )
            )
        }
        
        return insights
    }
    
    private func transactionsInPreviousMonth(from transactions: [Transaction]) -> [Transaction] {
        let calendar = Calendar.current
        
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: Date()) else {
            return [].self
        }
        
        return transactions.filter { transaction in
            calendar.isDate(transaction.date, equalTo: previousMonth, toGranularity: .month)
        }
    }
}

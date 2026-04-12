//
//  DashboardViewModelTests.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation
import Testing
@testable import FinanceFlow

struct DashboardViewModelTests {
    
    private let viewModel = DashboardViewModel()
    
    @Test
    func totalIncomeThisMonthReturnsOnlyCurrentMonthIncome() {
        let result = viewModel.totalIncomeThisMonth(from: sampleTransactions())
        
        #expect(result == 10000)
    }
    
    @Test
    func totalExpenseThisMonthReturnsOnlyCurrentMonthExpense() {
        let result = viewModel.totalExpenseThisMonth(from: sampleTransactions())
        
        #expect(result == 2000)
    }
    
    @Test
    func netBalanceThisMonthCalculatesCorrectly() {
        let result = viewModel.netBalanceThisMonth(from: sampleTransactions())
        
        #expect(result == 8000)
    }
    
    @Test
    func recentTransactionsReturnsLimitedNumberOfItems() {
        let result = viewModel.recentTransactions(from: sampleTransactions(), limit: 5)
        
        #expect(result.count == 5)
    }
    
    @Test
    func categorySpendingSummariesGroupsExpenseTransactionsByCategory() {
        let result = viewModel.categorySpendingSummaries(from: sampleTransactions())
        
        #expect(result.count == 3)
        
        let foodSummary = result.first { $0.category == .food }
        let transportationSummary = result.first { $0.category == .transportation }
        
        #expect(foodSummary?.totalAmount == 500)
        #expect(transportationSummary?.totalAmount == 800)
    }
    
    private func previousMonthDate() -> Date {
        Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    }
    
    private func sampleTransactions() -> [Transaction] {
        let transactions = [
            Transaction(
                title: "Maaş",
                amount: 10000,
                date: Date(),
                type: .income,
                category: .salary
            ),
            Transaction(
                title: "Freelance",
                amount: 2000,
                date: previousMonthDate(),
                type: .income,
                category: .freelance
            ),
            Transaction(
                title: "Market",
                amount: 500,
                date: Date(),
                type: .expense,
                category: .food
            ),
            Transaction(
                title: "Fatura",
                amount: 700,
                date: Date(),
                type: .expense,
                category: .bills
            ),
            Transaction(
                title: "Eski Gider",
                amount: 900,
                date: previousMonthDate(),
                type: .expense,
                category: .shopping
            ),
            Transaction(
                title: "Ulaşım",
                amount: 800,
                date: Date(),
                type: .expense,
                category: .transportation
            )
        ]
        
        return transactions
    }
}

//
//  BudgetListViewModelTests.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 28.04.2026.
//

import Testing
import Foundation
@testable import FinanceFlow

struct BudgetListViewModelTests {
    
    private let viewModel = BudgetListViewModel()
    
    @Test
    func spentAmountCalculatesOnlyMatchingExpenseCategoryAndMonth() {
        let budget = Budget (
            category: .food, monthlyLimit: 1000, monthDate: Date().startOfMonth
        )
        
        let transactions = [
            Transaction(title: "Market", amount: 300, date: Date(), type: .expense, category: .food),
            Transaction(title: "Restoran", amount: 200, date: Date(), type: .expense, category: .food),
            Transaction(title: "Ulaşım", amount: 100, date: Date(), type: .expense, category: .transportation),
            Transaction(title: "Maaş", amount: 5000, date: Date(), type: .income, category: .salary),
        ]
        
        let result = viewModel.spentAmount(for: budget, transactions: transactions)
        
        #expect(result == 500)
    }
    
    @Test
    func makeStatusMarksBudgetAsExceeded() {
        let budget = Budget (
            category: .food,
            monthlyLimit: 500,
            monthDate: Date().startOfMonth
        )
        
        let transactions = [
            Transaction(title: "Market", amount: 300, date: Date(), type: .expense, category: .food),
            Transaction(title: "Restoran", amount: 400, date: Date(), type: .expense, category: .food),
        ]
        
        let status = viewModel.makeStatus(for: budget, transactions: transactions)
        
        #expect(status.spentAmount == 700)
        #expect(status.remainingAmount == -200)
        #expect(status.isExceeded == true)
    }
    
    @Test
    func makeStatusCalculatesProgressCorrectly() {
        let budget = Budget (
            category: .food, monthlyLimit: 1000, monthDate: Date().startOfMonth
        )
        
        let transactions = [
            Transaction(title: "Market", amount: 250, date: Date(), type: .expense, category: .food)
        ]
        
        let status = viewModel.makeStatus(for: budget, transactions: transactions)
        
        #expect(status.progress == 0.25)
    }
    
}

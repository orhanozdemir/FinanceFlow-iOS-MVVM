//
//  TransactionListViewModelTests.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation
import Testing
@testable import FinanceFlow

struct TransactionListViewModelTests {
    
    private let viewModel = TransactionListViewModel()
    
    @Test
    func totalIncomeReturnsCorrectSum() {
        let transactions: [Transaction] = [
            Transaction(title: "Maaş", amount: 10000, type: .income, category: .salary),
            Transaction(title: "Freelance", amount: 3000, type: .income, category: .freelance),
            Transaction(title: "Market", amount: 500, type: .expense, category: .food)
        ]
        
        let total = viewModel.totalIncome(from: transactions)
        
        #expect(total == 13000)
    }
    
    @Test
    func totalExpenseReturnsCorrectSum() {
        let transactions = [
            Transaction(title: "Maaş", amount: 10000, type: .income, category: .salary),
            Transaction(title: "Market", amount: 500, type: .expense, category: .food),
            Transaction(title: "Fatura", amount: 700, type: .expense, category: .bills)
        ]
        
        let total = viewModel.totalExpense(from: transactions)
        
        #expect(total == 1200)
    }
    
    @Test
    func filteredTransactionsReturnsAllForAllFilter() {
        let transactions = sampleTransactions()
        
        let result = viewModel.filteredTransactions(from: transactions, filter: .all)
        
        #expect(result.count == 3)
    }
    
    @Test
    func filteredTransactionsReturnsOnlyExpenseForExpenseFilter() {
        let transactions = sampleTransactions()
        
        let result = viewModel.filteredTransactions(from: transactions, filter: .expense)
        
        #expect(result.count == 2)
    }
    
    private func sampleTransactions() -> [Transaction] {
        [
            Transaction(title: "Maaş", amount: 10000, type: .income, category: .salary),
            Transaction(title: "Market", amount: 500, type: .expense, category: .food),
            Transaction(title: "Ulaşım", amount: 200, type: .expense, category: .transportation)
        ]
    }
}

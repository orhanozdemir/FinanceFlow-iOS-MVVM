//
//  TransactionListViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

final class TransactionListViewModel {
    func totalIncome(from transactions: [Transaction]) -> Double {
        transactions
            .filter {$0.type == .income}
            .reduce(0) { $0 + $1.amount }
    }
    
    func totalExpense(from transactions: [Transaction]) -> Double {
        transactions
            .filter {$0.type == .expense}
            .reduce(0) { $0 + $1.amount }
    }
    
    func filteredTransactions(
        from transactions: [Transaction],
        filter: TransactionFilter
    ) -> [Transaction] {
        switch filter {
        case .all:
            return transactions
        case .income:
            return transactions.filter { $0.type == .income }
        case .expense:
            return transactions.filter { $0.type == .expense }
        }
    }
}

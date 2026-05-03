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
        filter: TransactionFilter,
        searchText: String,
        dateRange: DateRangeFilter,
        sort: TransactionSortOption
    ) -> [Transaction] {
        
        var result = transactions
        
        
//        1. Type filter
        result = result.filter { transaction in
            switch filter {
            case .all:
                return true
            case .income:
                return transaction.type == .income
            case .expense:
                return transaction.type == .expense
            }
        }
        
//        2. Search
        if !searchText.isEmpty {
            let lowercased = searchText.lowercased()
            
            result = result.filter {
                $0.title.lowercased().contains(lowercased) ||
                $0.category.displayName.lowercased().contains(lowercased)
            }
        }
        
//        3. Date filter
        result = result.filter { transaction in
            isInDateRange(transaction.date, range: dateRange)
        }
        
//        4. Sort
        result = sortTransactions(result, by: sort)
        
        return result
    }
    
    private func isInDateRange(_ date: Date, range: DateRangeFilter) -> Bool {
        let calendar = Calendar.current
        
        switch range {
        case .all:
            return true
        
        case .thisMonth:
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
            
        case .last30Days:
            guard let last30 = calendar.date(byAdding: .day, value: -30, to: Date()) else {
                return true
            }
            return date >= last30
            
        case let .custom(start, end):
            return date >= start && date <= end
        }
    }
    
    private func sortTransactions(
        _ transactions: [Transaction],
        by option: TransactionSortOption
    ) -> [Transaction] {
        switch option {
        case .dateDescending:
            return transactions.sorted { $0.date > $1.date }
            
        case .dateAscending:
            return transactions.sorted { $0.date < $1.date }
            
        case .amountDescending:
            return transactions.sorted { $0.amount > $1.amount }
            
        case .amountAscending:
            return transactions.sorted { $0.amount < $1.amount }
        }
    }
}

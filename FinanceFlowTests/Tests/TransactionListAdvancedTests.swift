//
//  TransactionListAdvancedTests.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Testing
@testable import FinanceFlow
import Foundation

struct TransactionListAdvancedTests {
    private let viewModel = TransactionListViewModel()
    
    @Test
    func searchTextFiltersByTitle() {
        let transactions = [
            Transaction(title: "Market alışverişi", amount: 500, date: Date(), type: .expense, category: .food),
            Transaction(title: "Otobüs", amount: 100, date: Date(), type: .expense, category: .transportation)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .all,
            searchText: "market",
            dateRange: .all,
            sort: .dateDescending
        )
        
        #expect(result.count == 1)
        #expect(result.first?.title == "Market alışverişi")
    }
    
    @Test
    func searchTextFiltersByCategoryName() {
        let transactions = [
            Transaction(title: "Öğle yemeği", amount: 250, date: Date(), type: .expense, category: .food),
            Transaction(title: "Metro", amount: 50, date: Date(), type: .expense, category: .transportation)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .all,
            searchText: "ulaşım",
            dateRange: .all,
            sort: .dateDescending
        )
        
        #expect(result.count == 1)
        #expect(result.first?.category == .transportation)
    }
    
    @Test
    func typeFilterReturnsOnlyExpenses() {
        let transactions = [
            Transaction(title: "Maaş", amount: 10000, date: Date(), type: .income, category: .salary),
            Transaction(title: "Market", amount: 500, date: Date(), type: .expense, category: .food),
            Transaction(title: "Fatura", amount: 800, date: Date(), type: .expense, category: .bills)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .expense,
            searchText: "",
            dateRange: .all,
            sort: .dateDescending
        )
        
        #expect(result.count == 2)
        #expect(result.allSatisfy { $0.type == .expense })
    }
    
    @Test
    func dateRangeThisMonthReturnsOnlyCurrentMonthTransactions() {
        let transactions = [
            Transaction(title: "Bu Ay", amount: 500, date: Date(), type: .expense, category: .food),
            Transaction(title: "Geçen Ay", amount: 700, date: previousMonthDate(), type: .expense, category: .food)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .all,
            searchText: "",
            dateRange: .thisMonth,
            sort: .dateDescending
        )
        
        #expect(result.count == 1)
        #expect(result.first?.title == "Bu Ay")
    }
    
    @Test
    func dateRangeLast30DaysReturnsRecentTransactions() {
        let transactions = [
            Transaction(title: "Bugün", amount: 100, date: Date(), type: .expense, category: .food),
            Transaction(title: "40 Gün Önce", amount: 200, date: daysAgo(40), type: .expense, category: .food)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .all,
            searchText: "",
            dateRange: .last30Days,
            sort: .dateDescending
        )
        
        #expect(result.count == 1)
        #expect(result.first?.title == "Bugün")
    }
    
    @Test
    func customDateRangeReturnsTransactionsInsideRange() {
        let start = daysAgo(10)
        let end = Date()
        
        let transactions = [
            Transaction(title: "Aralık İçinde", amount: 100, date: daysAgo(5), type: .expense, category: .food),
            Transaction(title: "Aralık Dışında", amount: 200, date: daysAgo(20), type: .expense, category: .food)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .all,
            searchText: "",
            dateRange: .custom(start: start, end: end),
            sort: .dateDescending
        )
        
        #expect(result.count == 1)
        #expect(result.first?.title == "Aralık İçinde")
    }
    
    @Test
    func sortByAmountDescendingReturnsHighestAmountFirst() {
        let transactions = [
            Transaction(title: "Düşük", amount: 100, date: Date(), type: .expense, category: .food),
            Transaction(title: "Yüksek", amount: 1000, date: Date(), type: .expense, category: .food)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .all,
            searchText: "",
            dateRange: .all,
            sort: .amountDescending
        )
        
        #expect(result.first?.title == "Yüksek")
    }
    
    @Test
    func sortByAmountAscendingReturnsLowestAmountFirst() {
        let transactions = [
            Transaction(title: "Yüksek", amount: 1000, date: Date(), type: .expense, category: .food),
            Transaction(title: "Düşük", amount: 100, date: Date(), type: .expense, category: .food)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .all,
            searchText: "",
            dateRange: .all,
            sort: .amountAscending
        )
        
        #expect(result.first?.title == "Düşük")
    }
    
    @Test
    func combinedFiltersWorkTogether() {
        let transactions = [
            Transaction(title: "Market", amount: 500, date: Date(), type: .expense, category: .food),
            Transaction(title: "Market Geliri", amount: 1000, date: Date(), type: .income, category: .salary),
            Transaction(title: "Eski Market", amount: 300, date: previousMonthDate(), type: .expense, category: .food),
            Transaction(title: "Ulaşım", amount: 200, date: Date(), type: .expense, category: .transportation)
        ]
        
        let result = viewModel.filteredTransactions(
            from: transactions,
            filter: .expense,
            searchText: "market",
            dateRange: .thisMonth,
            sort: .amountDescending
        )
        
        #expect(result.count == 1)
        #expect(result.first?.title == "Market")
    }
    
    private func previousMonthDate() -> Date {
        Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    }
    
    private func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
}

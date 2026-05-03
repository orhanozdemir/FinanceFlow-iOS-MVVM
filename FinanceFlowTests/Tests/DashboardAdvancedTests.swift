import Testing
@testable import FinanceFlow
import Foundation

struct DashboardAdvancedTests {
    private let viewModel = DashboardViewModel()
    
    @Test
    func totalIncomePreviousMonthReturnsOnlyPreviousMonthIncome() {
        let transactions = [
            Transaction(title: "Bu Ay Maaş", amount: 10000, date: Date(), type: .income, category: .salary),
            Transaction(title: "Geçen Ay Maaş", amount: 8000, date: previousMonthDate(), type: .income, category: .salary),
            Transaction(title: "Geçen Ay Market", amount: 500, date: previousMonthDate(), type: .expense, category: .food)
        ]
        
        let result = viewModel.totalIncomePreviousMonth(from: transactions)
        
        #expect(result == 8000)
    }
    
    @Test
    func totalExpensePreviousMonthReturnsOnlyPreviousMonthExpense() {
        let transactions = [
            Transaction(title: "Bu Ay Market", amount: 300, date: Date(), type: .expense, category: .food),
            Transaction(title: "Geçen Ay Market", amount: 500, date: previousMonthDate(), type: .expense, category: .food),
            Transaction(title: "Geçen Ay Ulaşım", amount: 200, date: previousMonthDate(), type: .expense, category: .transportation)
        ]
        
        let result = viewModel.totalExpensePreviousMonth(from: transactions)
        
        #expect(result == 700)
    }
    
    @Test
    func expenseChangePercentageReturnsIncrease() {
        let transactions = [
            Transaction(title: "Bu Ay Gider", amount: 1500, date: Date(), type: .expense, category: .food),
            Transaction(title: "Geçen Ay Gider", amount: 1000, date: previousMonthDate(), type: .expense, category: .food)
        ]
        
        let result = viewModel.expenseChangePercentage(from: transactions)
        
        #expect(result == 50)
    }
    
    @Test
    func expenseChangePercentageReturnsDecrease() {
        let transactions = [
            Transaction(title: "Bu Ay Gider", amount: 750, date: Date(), type: .expense, category: .food),
            Transaction(title: "Geçen Ay Gider", amount: 1000, date: previousMonthDate(), type: .expense, category: .food)
        ]
        
        let result = viewModel.expenseChangePercentage(from: transactions)
        
        #expect(result == -25)
    }
    
    @Test
    func expenseChangePercentageReturnsNilWhenPreviousMonthExpenseIsZero() {
        let transactions = [
            Transaction(title: "Bu Ay Gider", amount: 750, date: Date(), type: .expense, category: .food)
        ]
        
        let result = viewModel.expenseChangePercentage(from: transactions)
        
        #expect(result == nil)
    }
    
    @Test
    func averageExpenseThisMonthReturnsCorrectAverage() {
        let transactions = [
            Transaction(title: "Market", amount: 1000, date: Date(), type: .expense, category: .food),
            Transaction(title: "Ulaşım", amount: 300, date: Date(), type: .expense, category: .transportation),
            Transaction(title: "Maaş", amount: 10000, date: Date(), type: .income, category: .salary)
        ]
        
        let result = viewModel.averageExpenseThisMonth(from: transactions)
        
        #expect(result == 650)
    }
    
    @Test
    func topSpendingCategoryReturnsHighestExpenseCategory() {
        let transactions = [
            Transaction(title: "Market", amount: 1000, date: Date(), type: .expense, category: .food),
            Transaction(title: "Ulaşım", amount: 300, date: Date(), type: .expense, category: .transportation),
            Transaction(title: "Market 2", amount: 500, date: Date(), type: .expense, category: .food)
        ]
        
        let result = viewModel.topSpendingCategory(from: transactions)
        
        #expect(result?.category == .food)
        #expect(result?.totalAmount == 1500)
    }
    
    @Test
    func dashboardInsightsReturnsExpectedInsights() {
        let transactions = [
            Transaction(title: "Market", amount: 1000, date: Date(), type: .expense, category: .food),
            Transaction(title: "Ulaşım", amount: 300, date: Date(), type: .expense, category: .transportation),
            Transaction(title: "Geçen Ay", amount: 2000, date: previousMonthDate(), type: .expense, category: .shopping)
        ]
        
        let insights = viewModel.dashboardInsights(from: transactions)
        
        #expect(insights.contains { $0.title == "En Çok Harcanan Kategori" })
        #expect(insights.contains { $0.title == "Gider Değişimi" })
        #expect(insights.contains { $0.title == "Ortalama Gider" })
    }
    
    private func previousMonthDate() -> Date {
        Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    }
}

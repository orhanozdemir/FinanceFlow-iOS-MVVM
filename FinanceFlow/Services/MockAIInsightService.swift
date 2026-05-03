//
//  MockAIInsightService.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Foundation

final class MockAIInsightService: AIInsightService {
    private let dashboardViewModel = DashboardViewModel()
    private let budgetViewModel = BudgetListViewModel()
    
    func generateInsights(
        transactions: [Transaction],
        budgets: [Budget]
    ) async throws -> [AIInsight] {
        try await Task.sleep(nanoseconds: 600_000_000)
        
        var insights: [AIInsight] = []
        
        if let topCategory = dashboardViewModel.topSpendingCategory(from: transactions) {
            insights.append(
                AIInsight(
                    title: "En yoğun harcama alanı",
                    message: "\(topCategory.category.displayName) kategorisinde \(CurrencyFormatter.format(topCategory.totalAmount)) harcama yaptın. Bu kategori için bütçe takibi yapman faydalı olabilir.",
                    severity: .neutral
                )
            )
        }
        
        if let change = dashboardViewModel.expenseChangePercentage(from: transactions) {
            if change > 20 {
                insights.append(
                    AIInsight(
                        title: "Gider artışı dikkat çekiyor",
                        message: "Giderlerin geçen aya göre %\(abs(change).formatted(.number.precision(.fractionLength(1)))) artmış. Özellikle değişken harcamalarını gözden geçirebilirsin.",
                        severity: .warning
                    )
                )
            } else if change < -10 {
                insights.append(
                    AIInsight(
                        title: "Gider kontrolü iyi gidiyor",
                        message: "Giderlerin geçen aya göre %\(abs(change).formatted(.number.precision(.fractionLength(1)))) azalmış. Bu olumlu trendi koruyabilirsin.",
                        severity: .positive
                    )
                )
            }
        }
        
        let exceededBudgets = budgetViewModel
            .statuses(from: budgets, transactions: transactions)
            .filter { $0.isExceeded }
        
        if !exceededBudgets.isEmpty {
            let categories = exceededBudgets
                .map { $0.budget.category.displayName }
                .joined(separator: ", ")
            
            insights.append(
                AIInsight(
                    title: "Bütçe aşımı var",
                    message: "\(categories) kategorilerinde bütçe limitini aşmışsın. Önümüzdeki harcamalarda bu alanlara dikkat edebilirsin.",
                    severity: .warning
                )
            )
        }
        
        if insights.isEmpty {
            insights.append(
                AIInsight(
                    title: "Henüz yeterli veri yok",
                    message: "Daha anlamlı finansal yorumlar için birkaç gelir, gider ve bütçe kaydı ekleyebilirsin.",
                    severity: .neutral
                )
            )
        }
        
        return insights
    }
}

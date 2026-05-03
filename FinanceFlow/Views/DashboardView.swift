//
//  DashboardView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \Transaction.date, order: .reverse)
    private var transactions: [Transaction]
    
    @Query(sort: \Budget.monthDate, order: .reverse)
    private var budgets: [Budget]
    
    private var exceededBudgetStatuses: [BudgetStatus] {
        viewModel.exceededBudgets(budgets: budgets, transactions: transactions)
    }
    
    private let viewModel = DashboardViewModel()
    
    @StateObject private var aiViewModel = AIInsightsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    balanceSection
                    monthlySummarySection
                    aiInsightsSection
                    insightsSection
                    recentTransactionsSection
                    categorySpendingSection
                    budgetWarningSection
                }
                .padding(AppSpacing.lg)
            }
            .background(AppColors.pageBackground)
            .navigationTitle("Dashboard")
        }
    }
    
    private var netBalance: Double {
        viewModel.netBalanceThisMonth(from: transactions)
    }
    
    private var totalIncome: Double {
        viewModel.totalIncomeThisMonth(from: transactions)
    }
    
    private var totalExpense: Double {
        viewModel.totalExpenseThisMonth(from: transactions)
    }
    
    private var recentTransactions: [Transaction] {
        viewModel.recentTransactions(from: transactions)
    }
    
    private var categorySummaries: [CategorySpendingSummary] {
        viewModel.categorySpendingSummaries(from: transactions)
    }
    
    private var insights: [DashboardInsight] {
        viewModel.dashboardInsights(from: transactions)
    }
    
    private var balanceSection: some View {
        BalanceCardView(
            title: "Bu Ay Net Bakiye",
            amount: netBalance
        )
    }
    
    private var monthlySummarySection: some View {
        HStack(spacing: 12) {
            SummaryCardView(
                title: "Bu Ay Gelir",
                amount: totalIncome,
                color: .green
            )
            
            SummaryCardView(
                title: "Bu Ay Gider",
                amount: totalExpense,
                color: .red
            )
        }
    }
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Son İşlemler")
                .font(.headline)
            
            if recentTransactions.isEmpty {
                emptySectionText("Henüz işlem yok.")
            } else {
                ForEach(recentTransactions) { transaction in
                    TransactionRowView(transaction: transaction)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
    
    private var categorySpendingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bu Ay Kategori Bazlı Gider")
                .font(.headline)
            
            if categorySummaries.isEmpty {
                emptySectionText("Bu ay gider kaydı yok.")
            } else {
                ForEach(categorySummaries) { summary in
                    CategorySpedingRowView(summary: summary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
    
    private var budgetWarningSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bütçe Uyarıları")
                .font(.headline)
            
            if exceededBudgetStatuses.isEmpty {
                emptySectionText("Bu ay aşılmış bütçe yok.")
            } else {
                ForEach(exceededBudgetStatuses) { status in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(status.budget.category.displayName)
                            .font(.subheadline.bold())
                        
                        Text("Limit: ₺\(status.budget.monthlyLimit, specifier: "%.2f") • Harcanan: ₺\(status.spentAmount, specifier: "%.2f")")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
    
    private var insightsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text("Finansal İçgörüler")
                .font(.headline)
            
            if insights.isEmpty {
                emptySectionText("Henüz içgörü oluşturmak için yeterli veri yok.")
            } else {
                ForEach(insights) { insight in
                    DashboardInsightCardView(insight: insight)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var aiInsightsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text("AI Finans Yorumu")
                    .font(.headline)
                
                Spacer()
                
                Button {
                    Task {
                        await aiViewModel.generateInsights(
                            transactions: transactions,
                            budgets: budgets
                        )
                    }
                } label: {
                    if aiViewModel.isLoading {
                        ProgressView()
                    } else {
                        Image(systemName: "sparkles")
                    }
                }
                .disabled(aiViewModel.isLoading)
            }
            
            if aiViewModel.insights.isEmpty && !aiViewModel.isLoading {
                Text("Finansal verilerine göre yorum oluşturmak için sparkles butonuna bas.")
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryText)
            } else {
                ForEach(aiViewModel.insights) { insight in
                    AIInsightCardView(insight: insight)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeInOut(duration: 0.25), value: aiViewModel.insights.count)
        .errorAlert(
            title: "AI Yorumu Oluşturulamadı",
            message: $aiViewModel.errorMessage
        )
    }
    
    private func emptySectionText(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}


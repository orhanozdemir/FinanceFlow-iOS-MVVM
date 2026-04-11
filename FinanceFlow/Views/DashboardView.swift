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
    
    private let viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    balanceSection
                    monthlySummarySection
                    recentTransactionsSection
                    categorySpendingSection
                }
                .padding()
            }
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
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    private func emptySectionText(_ text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

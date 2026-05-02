//
//  BudgetListView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI
import SwiftData

struct BudgetListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Budget.monthDate, order: .reverse)
    private var budgets: [Budget]
    
    @Query(sort: \Transaction.date, order: .reverse)
    private var transactions: [Transaction]
    
    @State private var isPresentingAddSheet = false
    @State private var selectedBudget: Budget?
    
    private let viewModel = BudgetListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if budgetStatuses.isEmpty {
                    EmptyStateView(
                        title: "Bu ay için bütçe yok",
                        systemImage: "creditcard",
                        message: "Sağ üstteki artı butonuyla ilk bütçeni ekleyebilirsin"
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(budgetStatuses) { status in
                                BudgetRowView(status: status)
                                    .onTapGesture {
                                        selectedBudget = status.budget
                                    }
                                    .contextMenu {
                                        Button {
                                            selectedBudget = status.budget
                                        } label: {
                                            Label("Düzenle", systemImage: "pencil")
                                        }
                                        Button(role: .destructive) {
                                            delete(status.budget)
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Bütçeler")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddSheet) {
                AddBudgetView()
            }
            .sheet(item: $selectedBudget) { budget in
                EditBudgetView(budget: budget)
            }
        }
    }
    
    private var budgetStatuses: [BudgetStatus] {
        viewModel.statuses(from: budgets, transactions: transactions)
    }
    
    private func delete(_ budget: Budget) {
        modelContext.delete(budget)
        
        do {
            try modelContext.save()
        } catch {
            print("Bütçe silinirken hata oluştu: \(error)")
        }
    }
}

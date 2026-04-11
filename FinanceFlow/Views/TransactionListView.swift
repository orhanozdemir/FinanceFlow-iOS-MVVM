//
//  TransactionListView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import SwiftUI
import SwiftData

struct TransactionListView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Transaction.date, order: .reverse)
    private var transactions: [Transaction]
    
    @State private var isPresentingAddSheet = false
    @State private var selectedFilter: TransactionFilter = .all
    
    private let viewModel = TransactionListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    ContentUnavailableView(
                        "Henüz işlem yok",
                        systemImage: "tray",
                        description: Text("Sağ üstteki artı butonuyla ilk işlemini ekleyebilirsin.")
                    )
                } else {
                    VStack(spacing: 16) {
                        summarySection
                        filterSection
                        transactionList
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("İşlemler")
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
                AddTransactionView()
            }
        }
    }
    
    private var summarySection: some View {
        HStack(spacing: 12) {
            SummaryCardView(
                title: "Toplam Gelir",
                amount: totalIncome,
                color: .green
            )
            
            SummaryCardView(
                title: "Toplam Gider",
                amount: totalExpense,
                color: .red
            )
        }
    }
    
    var filterSection: some View {
        Picker("Filtre", selection: $selectedFilter) {
            ForEach(TransactionFilter.allCases, id: \.self) { filter in
                Text(filter.displayName).tag(filter)
            }
        }
        .pickerStyle(.segmented)
    }
    
    private var transactionList: some View {
        List {
            ForEach(filteredTransactions) { transaction in
                TransactionRowView(transaction: transaction)
                    .swipeActions {
                        Button(role: .destructive) {
                            delete(transaction)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
            }
            .onDelete(perform: deleteFromOffsets)
        }
        .listStyle(.plain)
    }
    
    private var filteredTransactions: [Transaction] {
        viewModel.filteredTransactions(from: transactions, filter: selectedFilter)
    }
    
    private var totalIncome: Double {
        viewModel.totalIncome(from: transactions)
    }
    
    private var totalExpense: Double {
        viewModel.totalExpense(from: transactions)
    }
    
    private func delete(_ transaction: Transaction) {
        modelContext.delete(transaction)
        
        do {
            try modelContext.save()
        } catch {
            print("Silme sırasında hata oluştu: \(error)")
        }
    }
    
    private func deleteFromOffsets(_ offsets: IndexSet) {
        for index in offsets {
            let transaction = filteredTransactions[index]
            modelContext.delete(transaction)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Toplu silme sırasında hata oluştu: \(error)")
        }
    }
}

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
    @State private var selectedTransaction: Transaction?
    @State private var selectedFilter: TransactionFilter = .all
    
    private let viewModel = TransactionListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if transactions.isEmpty {
                    EmptyStateView(
                        title: "Henüz işlem yok",
                        systemImage: "tray",
                        message: "Sağ üstteki artı butonuyla ilk işlemini ekleyebilirsin."
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.98)))
                } else {
                    VStack(spacing: 16) {
                        summarySection
                        filterSection
                        transactionList
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: transactions.isEmpty)
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
            .sheet(item: $selectedTransaction) { transaction in
                EditTransactionView(transaction: transaction)
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
                    .onTapGesture {
                        selectedTransaction = transaction
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            delete(transaction)
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }
                    .contextMenu {
                        Button {
                            selectedTransaction = transaction
                        } label: {
                            Label("Düzenle", systemImage: "pencil")
                        }
                        
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
        .animation(.easeInOut(duration: 0.2), value: selectedFilter)
        .animation(.easeInOut(duration: 0.2), value: filteredTransactions.count)
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
        withAnimation(.easeInOut(duration: 0.2)) {
            modelContext.delete(transaction)
            
            do {
                try modelContext.save()
                HapticService.success()
            } catch {
                HapticService.warning()
                print("Silme sırasında hata oluştu: \(error)")
            }
        }
    }
    
    private func deleteFromOffsets(_ offsets: IndexSet) {
        withAnimation(.easeInOut(duration: 0.2)) {
            for index in offsets {
                let transaction = filteredTransactions[index]
                modelContext.delete(transaction)
            }
            
            do {
                try modelContext.save()
                HapticService.success()
            } catch {
                HapticService.warning()
                print("Toplu silme sırasında hata oluştu: \(error)")
            }
        }
    }
}

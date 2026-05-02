//
//  EditTransactionView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import SwiftUI
import SwiftData

struct EditTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel: EditTransactionViewModel
    @State private var errorMessage: String?
    
    init(transaction: Transaction) {
        _viewModel = StateObject(wrappedValue: EditTransactionViewModel(transaction: transaction))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Başlık", text: $viewModel.title)
                        .textInputAutocapitalization(.words)
                    
                    AmountTextField(title: "Tutar", text: $viewModel.amountText)
                    
                    Picker("Tür", selection: $viewModel.type) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .onChange(of: viewModel.type) {
                        viewModel.updateCategoryIfNeeded()
                    }
                    
                    Picker("Kategori", selection: $viewModel.category) {
                        ForEach(viewModel.availableCategories, id: \.self) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    
                    DatePicker("Tarih", selection: $viewModel.date, displayedComponents: .date)
                } header: {
                    FormSectionHeaderView(
                        "İşlem Bilgileri",
                        subtitle: "Mevcut gelir/gider kaydını güncelle."
                    )
                }
            }
            .navigationTitle("İşlemi Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Güncelle") {
                        saveChanges()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .errorAlert(title: "İşlem Kaydedilemedi", message: $errorMessage)
        }
    }
    
    private func saveChanges() {
        do {
            try viewModel.updateTransaction()
            try modelContext.save()
            HapticService.success()
            dismiss()
        } catch {
            HapticService.warning()
            errorMessage = error.localizedDescription
        }
    }
}

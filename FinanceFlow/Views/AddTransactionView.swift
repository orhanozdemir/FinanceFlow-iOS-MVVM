//
//  AddTransactionView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var viewModel = AddTransactionViewModel()
    @State private var errorMessage: String?
    
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
                    
                    if let message = viewModel.firstValidationMessage {
                        ValidationMessageView(message: message)
                    }
                } header: {
                    FormSectionHeaderView(
                        "İşlem Bilgileri",
                        subtitle: "Gelir veya gider kaydını buradan oluştur."
                    )
                }
            }
            .navigationTitle("Yeni İşlem")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Ekle") {
                        saveTransaction()
                    }
//                    .disabled(!viewModel.isFormValid)
                }
            }
            .errorAlert(title: "İşlem Kaydedilemedi", message: $errorMessage)
        }
    }
    
    private func saveTransaction() {
        viewModel.hasAttemptedSubmit = true
        
        do {
            let transaction = try viewModel.makeTransaction()
            modelContext.insert(transaction)
            try modelContext.save()
            HapticService.success()
            dismiss()
        } catch {
            HapticService.warning()
            print("Kayıt sırasında hata oluştu: \(error)")
        }
    }
}

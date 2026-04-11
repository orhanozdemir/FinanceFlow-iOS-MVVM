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
                Section("İşlem Bilgileri") {
                    TextField("Başlık", text: $viewModel.title)
                    
                    TextField("Tutar", text: $viewModel.amountText)
                        .keyboardType(.decimalPad)
                    
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
                    Button("Kaydet") {
                        saveTransaction()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .alert("Hata", isPresented: Binding(
                get: { errorMessage != nil},
                set: { newValue in
                    if !newValue {
                        errorMessage = nil
                    }
                }
            )) {
                Button("Tamam", role: .cancel) {
                    errorMessage = nil
                }
            } message: {
                Text(errorMessage ?? "Bilinmeyen bir hata oluştu.")
            }
        }
    }
    
    private func saveTransaction() {
        do {
            let transaction = try viewModel.makeTransaction()
            modelContext.insert(transaction)
            try modelContext.save()
            dismiss()
        } catch {
            print("Kayıt sırasında hata oluştu: \(error)")
        }
    }
}

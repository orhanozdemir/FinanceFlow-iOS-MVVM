//
//  EditBudgetView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import SwiftUI
import SwiftData

struct EditBudgetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Budget.monthDate, order: .reverse)
    private var budgets: [Budget]
    
    @StateObject private var viewModel: EditBudgetViewModel
    @State private var errorMessage: String?

    init(budget: Budget) {
        _viewModel = StateObject(wrappedValue: EditBudgetViewModel(budget: budget))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Bütçe Bilgileri") {
                    Picker("Kategori", selection: $viewModel.category) {
                        ForEach(expenseCategories, id: \.self) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    
                    TextField("Limit", text: $viewModel.limitText)
                        .keyboardType(.decimalPad)
                    
                    DatePicker(
                        "Ay",
                        selection: $viewModel.monthDate,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Bütçeyi Düzenle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kaydet") {
                        saveChanges()
                    }
                    .disabled(!viewModel.isFormValid)
                }
            }
            .alert("Hata", isPresented: Binding(
                get: { errorMessage != nil },
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
    
    private var expenseCategories: [TransactionCategory] {
        TransactionCategory.allCases.filter { $0.supportedType == .expense }
    }
    
    private func saveChanges() {
        do {
            if viewModel.hasDuplicateBudget(in: budgets) {
                throw AddBudgetError.duplicateBudget
            }
            
            try viewModel.updateBudget()
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

}

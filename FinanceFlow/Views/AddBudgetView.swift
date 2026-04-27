//
//  AddBudgetView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI
import SwiftData

struct AddBudgetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \Budget.monthDate, order: .reverse)
    private var budgets: [Budget]
    
    @StateObject private var viewModel = AddBudgetViewModel()
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Bütçe Bilgileri") {
                    Picker("Kategori", selection: $viewModel.category) {
                        ForEach(viewModel.expenseCategories, id: \.self) { category in
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
            .navigationTitle("Yeni Bütçe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Kaydet") {
                        saveBudget()
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
    
    private func saveBudget() {
        do {
            if viewModel.hasDuplicateBudget(in: budgets) {
                throw AddBudgetError.duplicateBudget
            }
            let budget = try viewModel.makeBudget()
            modelContext.insert(budget)
            try modelContext.save()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

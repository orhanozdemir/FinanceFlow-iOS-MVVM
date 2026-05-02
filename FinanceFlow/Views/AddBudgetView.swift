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
                Section {
                    Picker("Kategori", selection: $viewModel.category) {
                        ForEach(viewModel.expenseCategories, id: \.self) { category in
                            Text(category.displayName).tag(category)
                        }
                    }
                    
                    AmountTextField(title: "Limit", text: $viewModel.limitText)
                    
                    DatePicker(
                        "Ay",
                        selection: $viewModel.monthDate,
                        displayedComponents: .date
                    )
                    
                    if let message = viewModel.firstValidationMessage {
                        ValidationMessageView(message: message)
                    }
                } header: {
                    FormSectionHeaderView(
                        "Bütçe Bilgileri",
                        subtitle: "Bir kategori için aylık harcama limiti belirle."
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
                    Button("Ekle") {
                        saveBudget()
                    }
//                    .disabled(!viewModel.isFormValid)
                }
            }
            .errorAlert(title: "Bütçe Kaydedilemedi", message: $errorMessage)
        }
    }
    
    private func saveBudget() {
        viewModel.hasAttemptedSubmit = true
        
        do {
            if viewModel.hasDuplicateBudget(in: budgets) {
                throw AddBudgetError.duplicateBudget
            }
            let budget = try viewModel.makeBudget()
            modelContext.insert(budget)
            try modelContext.save()
            HapticService.success()
            dismiss()
        } catch {
            HapticService.warning()
            errorMessage = error.localizedDescription
        }
    }
}

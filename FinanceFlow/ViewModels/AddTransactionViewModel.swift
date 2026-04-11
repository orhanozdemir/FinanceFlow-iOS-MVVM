//
//  AddTransactionViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import Foundation
import Combine

final class AddTransactionViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amountText: String = ""
    @Published var date: Date = .now
    @Published var type: TransactionType = .expense
    @Published var category: TransactionCategory = .food
    
    var availableCategories: [TransactionCategory] {
        TransactionCategory.categories(for: type)
    }
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        parsedAmount != nil &&
        parsedAmount ?? 0 > 0 &&
        category.supportedType == type
    }
    
    private var parsedAmount: Double? {
        let normalized = amountText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }
    
    func updateCategoryIfNeeded() {
        if !availableCategories.contains(category),
           let firstValidCategory = availableCategories.first {
            category = firstValidCategory
        }
    }
    
    func makeTransaction() throws -> Transaction {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedTitle.isEmpty else {
            throw AddTransactionError.emptyTitle
        }
        
        guard let amount = parsedAmount, amount > 0 else {
            throw AddTransactionError.invalidAmount
        }
        
        guard category.supportedType == type else {
            throw AddTransactionError.invalidCategory
        }
        
        return Transaction(
            title: trimmedTitle,
            amount: amount,
            date: date,
            type: type,
            category: category
        )
    }
}

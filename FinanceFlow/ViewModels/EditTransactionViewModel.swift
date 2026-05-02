//
//  EditTransactionViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import Foundation
import Combine

final class EditTransactionViewModel: ObservableObject {
    @Published var title: String
    @Published var amountText: String
    @Published var date: Date
    @Published var type: TransactionType
    @Published var category: TransactionCategory
    
    private let originalTransaction: Transaction
    
    init(transaction: Transaction) {
        self.originalTransaction = transaction
        self.title = transaction.title
        self.amountText = String(format: "%.2f", transaction.amount)
        self.date = transaction.date
        self.type = transaction.type
        self.category = transaction.category
    }
    
    var availableCategories: [TransactionCategory] {
        TransactionCategory.categories(for: type)
    }
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        parsedAmount != nil &&
        (parsedAmount ?? 0) > 0 &&
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
    
    func updateTransaction() throws {
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
        
        originalTransaction.title = trimmedTitle
        originalTransaction.amount = amount
        originalTransaction.date = date
        originalTransaction.type = type
        originalTransaction.category = category
    }
}

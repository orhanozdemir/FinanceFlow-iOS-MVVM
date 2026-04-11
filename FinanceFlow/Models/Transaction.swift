//
//  Transaction.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    var type: TransactionType
    var category: TransactionCategory
    
    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        date: Date = .now,
        type: TransactionType,
        category: TransactionCategory
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
    }
}

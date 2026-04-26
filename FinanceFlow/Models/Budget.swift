//
//  Budget.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation
import SwiftData

@Model
final class Budget {
    var id: UUID
    var category: TransactionCategory
    var monthlyLimit: Double
    var monthDate: Date
    
    init(
        id: UUID = UUID(),
        category: TransactionCategory,
        monthlyLimit: Double,
        monthDate: Date
    ) {
        self.id = id
        self.category = category
        self.monthlyLimit = monthlyLimit
        self.monthDate = monthDate
    }
}

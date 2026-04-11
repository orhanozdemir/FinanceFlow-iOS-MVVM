//
//  CategorySpendingSummary.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

struct CategorySpendingSummary: Identifiable {
    let id = UUID()
    let category: TransactionCategory
    let totalAmount: Double
}

//
//  BudgetStatus.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import Foundation

struct BudgetStatus: Identifiable {
    let id: UUID
    let budget: Budget
    let spentAmount: Double
    let remainingAmount: Double
    let progress: Double
    let isExceeded: Bool
}

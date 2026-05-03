//
//  AIInsightService.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Foundation

protocol AIInsightService {
    func generateInsights(
        transactions: [Transaction],
        budgets: [Budget]
    ) async throws -> [AIInsight]
}

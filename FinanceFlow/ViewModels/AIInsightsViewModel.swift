//
//  AIInsightViewModel.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Foundation
import Combine

@MainActor
final class AIInsightsViewModel: ObservableObject {
    @Published private(set) var insights: [AIInsight] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    private let service: AIInsightService
    
    init(service: AIInsightService = MockAIInsightService()) {
        self.service = service
    }
    
    func generateInsights(
        transactions: [Transaction],
        budgets: [Budget]
    ) async {
        isLoading = true
        errorMessage = nil
        
        do {
            insights = try await service.generateInsights(transactions: transactions, budgets: budgets)
            HapticService.success()
        } catch {
            errorMessage = error.localizedDescription
            HapticService.warning()
        }
        
        isLoading = false
    }
}

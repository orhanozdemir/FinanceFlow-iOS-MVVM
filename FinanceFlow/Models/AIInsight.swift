//
//  AIInsight.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Foundation

struct AIInsight: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
    let severity: AIInsightSeverity
}

enum AIInsightSeverity: Equatable {
    case positive
    case warning
    case neutral
}

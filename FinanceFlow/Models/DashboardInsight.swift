//
//  DashboardInsight.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import Foundation

struct DashboardInsight: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let description: String
    let type: InsightType
}

enum InsightType {
    case positive
    case negative
    case neutral
}

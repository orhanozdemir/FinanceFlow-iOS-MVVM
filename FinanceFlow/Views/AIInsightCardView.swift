//
//  AIInsightCardView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import SwiftUI

struct AIInsightCardView: View {
    let insight: AIInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack(spacing: AppSpacing.sm) {
                Image(systemName: iconName)
                    .foregroundStyle(color)
                
                Text(insight.title)
                    .font(.subheadline.bold())
            }
            
            Text(insight.message)
                .font(.caption)
                .foregroundStyle(AppColors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
    
    private var iconName: String {
        switch insight.severity {
        case .positive:
            return "checkmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .neutral:
            return "sparkles"
        }
    }
    
    private var color: Color {
        switch insight.severity {
        case .positive:
            return AppColors.income
        case .warning:
            return AppColors.expense
        case .neutral:
            return AppColors.primaryText
        }
    }
}

//
//  DashboardInsightCardView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 3.05.2026.
//

import SwiftUI

struct DashboardInsightCardView: View {
    let insight: DashboardInsight
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            HStack {
                Image(systemName: iconName)
                    .foregroundStyle(color)
                
                Text(insight.title)
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryText)
                
                Text(insight.value)
                    .font(.title3.bold())
                    .foregroundStyle(color)
                
                Text(insight.description)
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .appCard()
        }
    }
    
    private var iconName: String {
        switch insight.type {
        case .positive:
            return "arrow.down.right.circle.fill"
        case .negative:
            return "arrow.up.right.circle.fill"
        case .neutral:
            return "info.circle.fill"
        }
    }
    
    private var color: Color {
        switch insight.type {
        case .positive:
            return AppColors.income
        case .negative:
            return AppColors.expense
        case .neutral:
            return AppColors.primaryText
        }
    }
}

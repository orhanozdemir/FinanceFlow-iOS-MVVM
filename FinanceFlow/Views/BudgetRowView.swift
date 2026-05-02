//
//  BudgetRowView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI

struct BudgetRowView: View {
    let status: BudgetStatus
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(status.budget.category.displayName)
                        .font(.headline)
                    
                    Text(status.isExceeded ? "Limit aşıldı" : "Limit içinde")
                        .font(.caption)
                        .foregroundStyle(status.isExceeded ? AppColors.expense : AppColors.income)
                }
                
                Spacer()
                
                Text("\(Int(status.progress * 100))%")
                    .font(.caption.bold())
                    .foregroundStyle(status.isExceeded ? AppColors.expense : AppColors.income)
            }
            
            ProgressView(value: min(status.progress, 1.0))
                .tint(status.isExceeded ? AppColors.expense : AppColors.income)
            
            HStack {
                budgetInfo(title: "Harcanan", value: status.spentAmount)
                Spacer()
                budgetInfo(title: "Limit", value: status.budget.monthlyLimit)
                Spacer()
                budgetInfo(title: "Kalan", value: status.remainingAmount)
            }
        }
        .appCard()
    }
    
    private func budgetInfo(title: String, value: Double) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(.caption)
                .foregroundStyle(AppColors.secondaryText)
            
            Text(CurrencyFormatter.format(value))
                .font(.caption.bold())
                .foregroundStyle(value < 0 ? AppColors.expense : AppColors.income)
        }
    }
}

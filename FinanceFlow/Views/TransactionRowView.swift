//
//  TransactionRowView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: AppSpacing.md) {
            categoryIcon
            
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                Text(transaction.title)
                    .font(.subheadline.bold())
                    .foregroundStyle(AppColors.primaryText)
                
                HStack(spacing: AppSpacing.sm) {
                    Text(transaction.category.displayName)
                        .font(.caption)
                        .foregroundStyle(AppColors.secondaryText)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(AppColors.secondaryText)
                    
                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline.bold())
                        .foregroundStyle(AppColors.secondaryText)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                Text(transaction.type.displayName)
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryText)
                
                Text(formattedAmount)
                    .font(.caption)
                    .foregroundStyle(transaction.type == .income ? AppColors.income : AppColors.expense)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
    
    private var formattedAmount: String {
        let sign = transaction.type == .income ? "+" : ""
        return "\(sign)₺\(CurrencyFormatter.format(transaction.amount))"
    }
    
    private var categoryIcon: some View {
        Image(systemName: transaction.type == .income ? "arrow.down.circle.fill" : "arrow.up.circle.fill")
            .font(.title3)
            .foregroundStyle(transaction.type == .income ? AppColors.income : AppColors.expense)
    }
}

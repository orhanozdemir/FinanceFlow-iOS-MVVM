//
//  BalanceCardView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI

struct BalanceCardView: View {
    let title: String
    let amount: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(AppColors.secondaryText)
            
            Text(CurrencyFormatter.format(amount))
                .font(.largeTitle.bold())
                .foregroundStyle(amount >= 0 ? AppColors.income : AppColors.expense)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appCard()
    }
}

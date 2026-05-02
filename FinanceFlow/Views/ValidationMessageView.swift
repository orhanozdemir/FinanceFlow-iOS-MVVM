//
//  ValidationMessageView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import SwiftUI

struct ValidationMessageView: View {
    let message: String
    
    var body: some View {
        HStack(alignment: .top, spacing: AppSpacing.xs) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.caption)
            
            Text(message)
                .font(.caption)
        }
        .foregroundStyle(AppColors.expense)
        .padding(.top, AppSpacing.xs)
    }
}

//
//  FormSectionHeaderView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import SwiftUI

struct FormSectionHeaderView: View {
    let title: String
    let subtitle: String?
    
    init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            Text(title)
                .font(.headline)
            
            if let subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(AppColors.secondaryText)
            }
        }
        .textCase(nil)
    }
    
}

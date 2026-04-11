//
//  CategorySpedingRowView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI

struct CategorySpedingRowView: View {
    let summary: CategorySpendingSummary
    
    var body: some View {
        HStack {
            Text(summary.category.displayName)
                .font(.body)
            
            Spacer()
            
            Text("₺\(summary.totalAmount, default: "%.2f")")
                .font(.headline)
                .foregroundStyle(.red)
        }
        .padding(.vertical, 4)
    }
}

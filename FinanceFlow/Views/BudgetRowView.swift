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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(status.budget.category.displayName)
                    .font(.headline)
                
                Spacer()
                
                Text(status.isExceeded ? "Aşıldı" : "Uygun")
                    .font(.caption)
                    .foregroundStyle(status.isExceeded ? .red : .green)
            }
            
            ProgressView(value: min(status.progress, 1.0))
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Harcanan")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("₺\(status.spentAmount, default: "%.2f")")
                        .font(.subheadline.bold())
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Limit")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("₺\(status.budget.monthlyLimit, default: "%.2f")")
                        .font(.subheadline.bold())
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Kalan")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("₺\(status.remainingAmount, default: "%.2f")")
                        .font(.subheadline.bold())
                        .foregroundStyle(status.remainingAmount < 0 ? .red : .green)
                }
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

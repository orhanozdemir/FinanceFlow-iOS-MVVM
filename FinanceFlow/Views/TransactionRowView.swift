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
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                
                HStack(spacing: 8) {
                    Text(transaction.category.displayName)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.type.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(formattedAmount)
                    .font(.caption)
                    .foregroundStyle(transaction.type == .income ? .green : .red)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var formattedAmount: String {
        let sign = transaction.type == .income ? "+" : ""
        return "\(sign)₺\(transaction.amount, default:"%.2f")"
    }
}

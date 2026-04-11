//
//  SummaryCardView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI

struct SummaryCardView: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("₺\(amount, default: "%.2f")")
                .font(.title3.bold())
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

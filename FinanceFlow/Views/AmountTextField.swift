//
//  AmountTextField.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import SwiftUI

struct AmountTextField: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        HStack {
            Text("₺")
                .font(.headline)
                .foregroundStyle(AppColors.secondaryText)
            
            TextField(title, text: $text)
                .keyboardType(.decimalPad)
                .font(.body)
        }
    }
}

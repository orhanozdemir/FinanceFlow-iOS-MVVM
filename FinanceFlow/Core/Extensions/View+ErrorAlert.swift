//
//  View+ErrorAlert.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import SwiftUI

extension View {
    func errorAlert(
        title: String,
        message: Binding<String?>
    ) -> some View {
        self.alert(
            title,
            isPresented: Binding(
                get: { message.wrappedValue != nil },
                set: { isPresented in
                    if !isPresented {
                        message.wrappedValue = nil
                    }
                }
            )
        ) {
            Button("Tamam", role: .cancel) {
                message.wrappedValue = nil
            }
        } message: {
            Text(message.wrappedValue ?? "Bilinmeyen bir hata oluştu.")
        }
    }
}

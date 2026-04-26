//
//  FinanceFlowApp.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import SwiftUI
import SwiftData

@main
struct FinanceFlowApp: App {

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: [Transaction.self, Budget.self])
    }
}

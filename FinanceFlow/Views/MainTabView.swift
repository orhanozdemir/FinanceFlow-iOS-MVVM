//
//  MainTabView.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 12.04.2026.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
            TransactionListView()
                .tabItem {
                    Label("İşlemler", systemImage: "list.bullet")
                }
        }
    }
}

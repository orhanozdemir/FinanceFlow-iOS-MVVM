//
//  Item.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 11.04.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

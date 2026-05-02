//
//  HapticService.swift
//  FinanceFlow
//
//  Created by Orhan Özdemir on 2.05.2026.
//

import UIKit

enum HapticService {
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
}

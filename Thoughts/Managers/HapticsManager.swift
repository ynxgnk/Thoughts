//
//  HapticsManager.swift
//  Thoughts
//
//  Created by Nazar Kopeyka on 18.04.2023.
//

import Foundation
import UIKit /* 915 */

class HapticsManager { /* 916 */
    static let shared = HapticsManager() /* 917 */
    
    private init() {} /* 918 */
    
    func vibrateForSelection() { /* 919 */
        let generator = UISelectionFeedbackGenerator() /* 920 */
        generator.prepare() /* 921 */
        generator.selectionChanged() /* 922 */
    }
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) { /* 923 */
        let generator = UINotificationFeedbackGenerator() /* 924 */
        generator.prepare() /* 925 */
        generator.notificationOccurred(type) /* 926 */
    }
}

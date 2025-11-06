import UIKit

/// Manages haptic feedback throughout the app
class HapticManager {
    static let shared = HapticManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    
    private init() {
        // Prepare generators for better performance
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
    }
    
    /// Triggers light haptic feedback for quick action taps
    func lightImpact() {
        lightImpact.impactOccurred()
    }
    
    /// Triggers medium haptic feedback for important actions
    func mediumImpact() {
        mediumImpact.impactOccurred()
    }
    
    /// Triggers heavy haptic feedback for critical actions
    func heavyImpact() {
        heavyImpact.impactOccurred()
    }
    
    /// Triggers selection feedback for UI element selection
    func selectionChanged() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
    
    /// Triggers notification feedback for success/error states
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }
}


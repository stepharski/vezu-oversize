import Foundation

@Observable
final class AIConsentManager {
    var isPromptPresented = false
    private(set) var hasConsented: Bool

    private let defaults: UserDefaults
    private var pendingAction: (() -> Void)?

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        hasConsented = defaults.bool(forKey: Constants.consentKey)
    }

    func requestConsent(then action: @escaping () -> Void) {
        guard !hasConsented else {
            action()
            return
        }
        pendingAction = action
        isPromptPresented = true
    }

    func didTapAgree() {
        hasConsented = true
        defaults.set(true, forKey: Constants.consentKey)
        isPromptPresented = false
    }

    func didTapDecline() {
        pendingAction = nil
        isPromptPresented = false
    }

    func promptDismissed() {
        let action = hasConsented ? pendingAction : nil
        pendingAction = nil
        action?()
    }
}

private extension AIConsentManager {
    enum Constants {
        static let consentKey = "hasConsentedToAIReading"
    }
}

import Foundation
import UIKit

@Observable
final class InfoViewModel {
    let learnTopics: [InfoTopic] = [.add, .read, .drive]
    let safetyTopics: [InfoTopic] = [.safety, .privacy]
    var demoBrief: PermitBrief?
    var selectedTopic: InfoTopic?

    private let permitManager: PermitManager
    private let importManager: ImportManager

    init(permitManager: PermitManager, importManager: ImportManager) {
        self.permitManager = permitManager
        self.importManager = importManager
    }

    var languageName: String {
        let code = Bundle.main.languageCode
        let locale = Locale(identifier: code)
        return locale.localizedString(forLanguageCode: code)?.capitalized(with: locale) ?? code
    }

    var settingsURL: URL? {
        URL(string: UIApplication.openSettingsURLString)
    }

    var versionText: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        return AppText.Info.version(version)
    }

    func select(_ topic: InfoTopic) {
        selectedTopic = topic
    }

    func didTapTryDemo() {
        demoBrief = .demo
    }

    func briefViewModel(for brief: PermitBrief) -> PermitBriefViewModel {
        PermitBriefViewModel(brief: brief, permitManager: permitManager, importManager: importManager)
    }
}

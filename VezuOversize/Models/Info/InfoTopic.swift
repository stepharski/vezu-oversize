import Foundation

enum InfoTopic: Identifiable {
    case add
    case read
    case drive
    case safety
    case privacy

    var id: Self {
        self
    }

    var title: String {
        switch self {
        case .add:
            return AppText.Info.addTitle
        case .read:
            return AppText.Info.readTitle
        case .drive:
            return AppText.Info.driveTitle
        case .safety:
            return AppText.Info.safetyTitle
        case .privacy:
            return AppText.Info.privacyTitle
        }
    }

    var subtitle: String {
        switch self {
        case .add:
            return AppText.Info.addSubtitle
        case .read:
            return AppText.Info.readSubtitle
        case .drive:
            return AppText.Info.driveMessage
        case .safety:
            return AppText.Info.safetySubtitle
        case .privacy:
            return AppText.Info.privacySubtitle
        }
    }

    var systemImage: String {
        switch self {
        case .add:
            return "doc.badge.plus"
        case .read:
            return "doc.text.magnifyingglass"
        case .drive:
            return "map"
        case .safety:
            return "exclamationmark.triangle"
        case .privacy:
            return "lock.shield"
        }
    }

    var points: [InfoTopicPoint] {
        switch self {
        case .add:
            return [
                InfoTopicPoint(systemImage: "square.and.arrow.down", title: AppText.Info.importTitle, detail: AppText.Info.importMessage),
                InfoTopicPoint(systemImage: "square.and.arrow.up", title: AppText.Info.shareTitle, detail: AppText.Info.shareMessage),
                InfoTopicPoint(systemImage: "doc.on.doc", title: AppText.Info.attachmentsTitle, detail: AppText.Info.attachmentsMessage),
                InfoTopicPoint(systemImage: "hourglass", title: AppText.Info.waitTitle, detail: AppText.Info.waitMessage)
            ]
        case .read:
            return [
                InfoTopicPoint(systemImage: "list.bullet.rectangle", title: AppText.Info.restrictionsTitle, detail: AppText.Info.restrictionsMessage),
                InfoTopicPoint(systemImage: "exclamationmark.octagon", title: AppText.Info.alertsTitle, detail: AppText.Info.alertsMessage),
                InfoTopicPoint(systemImage: "shippingbox", title: AppText.Info.detailsTitle, detail: AppText.Info.detailsMessage),
                InfoTopicPoint(systemImage: "checkmark.seal", title: AppText.Info.doubleCheckTitle, detail: AppText.Info.doubleCheckMessage),
                InfoTopicPoint(systemImage: "doc.richtext", title: AppText.Info.originalTitle, detail: AppText.Info.originalMessage)
            ]
        case .drive:
            return [
                InfoTopicPoint(systemImage: "point.topleft.down.to.point.bottomright.curvepath", title: AppText.Info.routeTitle, detail: AppText.Info.routeMessage),
                InfoTopicPoint(systemImage: "square.and.arrow.up", title: AppText.Info.navigateTitle, detail: AppText.Info.navigateMessage),
                InfoTopicPoint(systemImage: "square.stack.3d.up", title: AppText.Info.partsTitle, detail: AppText.Info.partsMessage),
                InfoTopicPoint(systemImage: "exclamationmark.triangle", title: AppText.Info.navigationTitle, detail: AppText.Info.navigationMessage)
            ]
        case .safety:
            return [
                InfoTopicPoint(systemImage: "sparkles", title: AppText.Info.aiTitle, detail: AppText.Info.aiMessage),
                InfoTopicPoint(systemImage: "arrow.triangle.turn.up.right.diamond", title: AppText.Info.navigationTitle, detail: AppText.Info.navigationMessage),
                InfoTopicPoint(systemImage: "doc.text", title: AppText.Info.carryTitle, detail: AppText.Info.carryMessage)
            ]
        case .privacy:
            return [
                InfoTopicPoint(systemImage: "iphone", title: AppText.Info.onPhoneTitle, detail: AppText.Info.onPhoneMessage),
                InfoTopicPoint(systemImage: "eye.slash", title: AppText.Info.notKeptTitle, detail: AppText.Info.notKeptMessage),
                InfoTopicPoint(systemImage: "calendar.badge.clock", title: AppText.Info.cleanupTitle, detail: AppText.Info.cleanupMessage)
            ]
        }
    }
}

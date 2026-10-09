import Foundation

enum AppText {
    enum Tabs {
        static let permits = "Permits"
        static let info = "Info"
    }

    enum Permits {
        static let title = "Permits"
        static let subtitle = "Add · Read · Drive"
        static let importTitle = "Import"
    }

    enum PermitsEmptyState {
        static let title = "No permits yet"
        static let subtitle = "Import a permit PDF to turn it \ninto a clear driving brief."
        static let shareTitle = "Have a permit in another app?"
        static let shareMessage = "Open the PDF in Mail, Telegram, or Files, \nthen tap Share → VEZU."
        static let demoTitle = "Try a demo permit"
        static let demoMessage = "See how a permit brief works."
    }

    enum Filter {
        static let all = "All"
        static let active = "Active"
        static let expired = "Expired"
    }

    enum Common {
        static let delete = "Delete"
    }
}

import SwiftUI
import SwiftData

@main
struct VezuOversizeApp: App {
    private let container: ModelContainer
    @State private var permitManager: PermitManager
    @State private var importManager: ImportManager
    @State private var consentManager = AIConsentManager()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        container = Self.makeContainer()
        let permitManager = PermitManager(context: container.mainContext)
        _permitManager = State(initialValue: permitManager)
        _importManager = State(initialValue: ImportManager(permitManager: permitManager))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(
                permitManager: permitManager,
                importManager: importManager,
                consentManager: consentManager)
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                permitManager.deleteOldExpiredPermits()
            }
        }
    }
}

private extension VezuOversizeApp {
    static func makeContainer() -> ModelContainer {
        do {
            return try ModelContainer(for: PermitRecord.self)
        } catch {
            fatalError("Couldn't open the permits database: \(error)")
        }
    }
}

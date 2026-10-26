import SwiftData
import SwiftUI

@main
struct VezuOversizeApp: App {
    private let container: ModelContainer
    @State private var permitManager: PermitManager
    @State private var importManager: ImportManager
    @Environment(\.scenePhase) private var scenePhase

    init() {
        do {
            container = try ModelContainer(for: PermitRecord.self)
        } catch {
            fatalError("Couldn't open the permits database: \(error)")
        }

        let permitManager = PermitManager(context: container.mainContext)
        _permitManager = State(initialValue: permitManager)
        _importManager = State(initialValue: ImportManager(permitManager: permitManager))
    }

    var body: some Scene {
        WindowGroup {
            MainTabView(permitManager: permitManager, importManager: importManager)
        }
        .modelContainer(container)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                permitManager.deleteOldExpiredPermits()
            }
        }
    }
}

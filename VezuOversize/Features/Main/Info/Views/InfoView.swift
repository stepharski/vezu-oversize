import SwiftData
import SwiftUI

struct InfoView: View {
    @State var viewModel: InfoViewModel
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackgroundView()
                content
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $viewModel.demoBrief) { brief in
                PermitBriefView(viewModel: viewModel.makeBriefViewModel(for: brief))
            }
        }
        .sheet(item: $viewModel.selectedTopic) { topic in
            InfoTopicSheet(topic: topic)
        }
    }
}

private extension InfoView {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Design.cellSpacing) {
                title
                    .padding(.bottom, Design.titleBottomPadding)

                LanguageCell(languageName: viewModel.languageName, onTap: openLanguageSettings)

                InfoSection(title: AppText.Info.learn) {
                    topicRows(viewModel.learnTopics)
                }

                InfoSection(title: AppText.Info.tryIt) {
                    InfoActionRow(
                        systemImage: "play.fill",
                        title: AppText.PermitsEmptyState.demoTitle,
                        detail: AppText.PermitsEmptyState.demoMessage,
                        action: viewModel.tryDemoTapped)
                }

                InfoSection(title: AppText.Info.safetyAndPrivacy) {
                    topicRows(viewModel.safetyTopics)
                }

                AboutFooter(versionText: viewModel.versionText)
                    .padding(.top, Design.footerTopPadding)
            }
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.top, Design.topPadding)
            .padding(.bottom, Design.bottomPadding)
        }
        .scrollIndicators(.hidden)
    }

    var title: some View {
        Text(AppTab.info.title)
            .font(.largeTitle.bold())
            .foregroundStyle(Color.primaryWhite)
    }

    func topicRows(_ topics: [InfoTopic]) -> some View {
        ForEach(topics) { topic in
            if topic != topics.first {
                InfoSectionDivider()
            }

            InfoActionRow(
                systemImage: topic.systemImage,
                title: topic.title,
                detail: topic.subtitle) {
                    viewModel.select(topic)
                }
        }
    }

    func openLanguageSettings() {
        guard let url = viewModel.settingsURL else { return }
        openURL(url)
    }
}

private enum Design {
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 24
    static let titleBottomPadding: CGFloat = 10
    static let cellSpacing: CGFloat = 20
    static let footerTopPadding: CGFloat = 16
}

#Preview {
    let container = try! ModelContainer(
        for: PermitRecord.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let permitManager = PermitManager(context: container.mainContext)

    InfoView(
        viewModel: InfoViewModel(
            permitManager: permitManager,
            importManager: ImportManager(permitManager: permitManager)))
}

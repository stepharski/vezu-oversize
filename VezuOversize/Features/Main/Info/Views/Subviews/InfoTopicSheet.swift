import SwiftUI

struct InfoTopicSheet: View {
    let topic: InfoTopic
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.sheetGray
                    .ignoresSafeArea()
                content
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(AppText.Common.done) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationBackground(Color.sheetGray)
    }
}

private extension InfoTopicSheet {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Design.spacing) {
                header
                preview
                points
            }
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.bottom, Design.bottomPadding)
        }
        .scrollIndicators(.hidden)
    }

    var header: some View {
        HStack(spacing: Design.headerSpacing) {
            Image(systemName: topic.systemImage)
                .font(.title2)
                .foregroundStyle(Color.primaryYellow)
                .frame(width: Design.iconSize, height: Design.iconSize)
                .background(Color.darkAmber.opacity(0.35), in: .rect(cornerRadius: Design.iconCornerRadius))

            VStack(alignment: .leading, spacing: Design.textSpacing) {
                Text(topic.title)
                    .font(.title2.bold())
                    .foregroundStyle(Color.primaryWhite)

                Text(topic.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)
            }
        }
    }

    @ViewBuilder
    var preview: some View {
        switch topic {
        case .add:
            SharePreview()
        case .read:
            BriefPreview()
        case .drive:
            RoutePreview()
        case .safety, .privacy:
            EmptyView()
        }
    }

    var points: some View {
        VStack(alignment: .leading, spacing: Design.rowSpacing) {
            ForEach(topic.points, id: \.self) { point in
                BriefIconRow(systemImage: point.systemImage, title: point.title, detail: point.detail)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardStyle()
    }
}

private enum Design {
    static let spacing: CGFloat = 20
    static let horizontalPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 24
    static let headerSpacing: CGFloat = 14
    static let iconSize: CGFloat = 52
    static let iconCornerRadius: CGFloat = 14
    static let textSpacing: CGFloat = 4
    static let rowSpacing: CGFloat = 14
}

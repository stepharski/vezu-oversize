import SwiftUI

struct BriefPreview: View {
    private let brief = PermitBrief.demo

    var body: some View {
        InfoPreviewFrame {
            KeyRestrictionsCell(restrictions: brief.restrictions, escorts: brief.escorts, critical: brief.critical)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: Design.height, alignment: .top)
                .clipped()
                .mask { bottomFade }
        }
    }
}

private extension BriefPreview {
    var bottomFade: some View {
        LinearGradient(
            stops: [.init(color: .black, location: 0.7), .init(color: .clear, location: 1)],
            startPoint: .top,
            endPoint: .bottom)
    }
}

private extension BriefPreview {
    enum Design {
        static let height: CGFloat = 260
    }
}

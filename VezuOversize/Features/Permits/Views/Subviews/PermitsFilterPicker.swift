import SwiftUI

struct PermitsFilterPicker: View {
    @Binding var selection: PermitFilter
    @Namespace private var namespace

    let count: (PermitFilter) -> Int

    var body: some View {
        HStack(spacing: .zero) {
            ForEach(PermitFilter.allCases, id: \.self) { filter in
                segment(for: filter)
            }
        }
        .padding(Design.trackPadding)
        .background(Color.cardBlack.opacity(0.8), in: .capsule)
    }
}

private extension PermitsFilterPicker {
    func segment(for filter: PermitFilter) -> some View {
        let isSelected = selection == filter

        return Button {
            withAnimation(.snappy) {
                selection = filter
            }
        } label: {
            segmentLabel(for: filter, isSelected: isSelected)
                .frame(maxWidth: .infinity)
                .padding(.vertical, Design.segmentVerticalPadding)
                .background {
                    if isSelected {
                        selectionIndicator
                    }
                }
                .contentShape(.capsule)
        }
        .buttonStyle(.plain)
    }

    func segmentLabel(for filter: PermitFilter, isSelected: Bool) -> some View {
        HStack(spacing: Design.segmentSpacing) {
            Text(filter.title)
                .font(.body.weight(isSelected ? .semibold : .regular))

            Text("\(count(filter))")
                .font(.footnote.weight(.medium))
                .frame(width: Design.badgeSize, height: Design.badgeSize)
                .background(Color.white.opacity(isSelected ? 0.12 : 0.08), in: .circle)
        }
        .foregroundStyle(isSelected ? Color.primaryWhite : Color.secondaryGray)
    }

    var selectionIndicator: some View {
        Capsule()
            .fill(Color.darkAmber.opacity(0.25))
            .matchedGeometryEffect(id: "selection", in: namespace)
    }
}

private extension PermitsFilterPicker {
    enum Design {
        static let trackPadding: CGFloat = 4
        static let segmentSpacing: CGFloat = 10
        static let segmentVerticalPadding: CGFloat = 12
        static let badgeSize: CGFloat = 26
    }
}

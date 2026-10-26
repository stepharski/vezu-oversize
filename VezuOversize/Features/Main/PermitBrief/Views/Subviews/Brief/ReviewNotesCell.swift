import SwiftUI

struct ReviewNotesCell: View {
    let notes: [String]

    var body: some View {
        BriefSectionCell(
            title: AppText.PermitBrief.reviewNotes,
            systemImage: "exclamationmark.triangle"
        ) {
            VStack(alignment: .leading, spacing: Design.rowSpacing) {
                Text(AppText.PermitBrief.reviewNotesMessage)
                    .font(.subheadline)
                    .foregroundStyle(Color.secondaryGray)

                ForEach(notes, id: \.self) { note in
                    noteRow(note)
                }
            }
        }
        .overlay { highlightBorder }
    }
}

private extension ReviewNotesCell {
    func noteRow(_ note: String) -> some View {
        Label {
            Text(note)
                .font(.subheadline)
                .foregroundStyle(Color.primaryWhite)
        } icon: {
            Image(systemName: "circle.fill")
                .imageScale(.small)
                .foregroundStyle(Color.primaryYellow)
        }
    }

    var highlightBorder: some View {
        RoundedRectangle(cornerRadius: Design.cornerRadius)
            .stroke(Color.primaryYellow.opacity(0.5), lineWidth: 1)
    }
}

private enum Design {
    static let rowSpacing: CGFloat = 10
    static let cornerRadius: CGFloat = 20
}

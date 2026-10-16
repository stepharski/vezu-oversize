import SwiftUI

struct DocumentsCell: View {
    let documents: [PermitBrief.Item]

    var body: some View {
        BriefSectionCell(title: AppText.PermitBrief.documents) {
            VStack(alignment: .leading, spacing: Design.rowSpacing) {
                ForEach(documents) { document in
                    row(for: document)
                }
            }
        }
    }
}

// MARK: - Components
private extension DocumentsCell {
    func row(for document: PermitBrief.Item) -> some View {
        BriefIconRow(
            systemImage: "doc.text",
            title: document.title,
            detail: document.detail
        )
    }
}

// MARK: - Design
private enum Design {
    static let rowSpacing: CGFloat = 14
}

#Preview {
    DocumentsCell(documents: PermitBrief.demo.documents)
        .padding()
        .background(Color.nearBlack)
}

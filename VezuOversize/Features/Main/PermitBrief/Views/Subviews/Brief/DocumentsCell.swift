import SwiftUI

struct DocumentsCell: View {
    let documents: [PermitBriefItem]

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

private extension DocumentsCell {
    func row(for document: PermitBriefItem) -> some View {
        BriefIconRow(
            systemImage: "doc.text",
            title: document.title,
            detail: document.detail)
    }
}

private enum Design {
    static let rowSpacing: CGFloat = 14
}

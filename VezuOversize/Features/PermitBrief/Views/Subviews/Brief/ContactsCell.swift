import SwiftUI

struct ContactsCell: View {
    let contacts: [PermitContact]

    var body: some View {
        BriefSectionCell(
            title: AppText.PermitBrief.contacts,
            systemImage: "phone") {
                VStack(alignment: .leading, spacing: Design.rowSpacing) {
                    ForEach(contacts) { contact in
                        row(for: contact)
                    }
                }
            }
    }
}

private extension ContactsCell {
    func row(for contact: PermitContact) -> some View {
        HStack {
            nameLabel(for: contact)
            Spacer(minLength: Design.spacerSize)
            phoneLabel(for: contact)
        }
    }

    func nameLabel(for contact: PermitContact) -> some View {
        VStack(alignment: .leading, spacing: Design.textSpacing) {
            Text(contact.name)
                .font(.body.weight(.semibold))
                .foregroundStyle(Color.primaryWhite)

            Text(contact.role)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        }
    }

    @ViewBuilder
    func phoneLabel(for contact: PermitContact) -> some View {
        if let url = phoneURL(for: contact.phone) {
            Link(destination: url) {
                Label(contact.phone, systemImage: "phone.fill")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.primaryYellow)
            }
        } else {
            Text(contact.phone)
                .font(.subheadline)
                .foregroundStyle(Color.secondaryGray)
        }
    }

    func phoneURL(for phone: String) -> URL? {
        let digits = phone.filter(\.isNumber)
        return digits.isEmpty ? nil : URL(string: "tel:\(digits)")
    }
}

private extension ContactsCell {
    enum Design {
        static let rowSpacing: CGFloat = 14
        static let textSpacing: CGFloat = 2
        static let spacerSize: CGFloat = 8
    }
}

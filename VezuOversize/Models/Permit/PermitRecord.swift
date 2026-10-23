import Foundation
import SwiftData
import SwiftUIPocketKit

@Model
final class PermitRecord {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var pdfFileName: String
    var attachmentFileNames: [String] = []
    var briefData: Data

    init(id: UUID, pdfFileNames: [String], brief: PermitBrief) throws {
        self.id = id
        self.createdAt = .now
        self.pdfFileName = pdfFileNames.first ?? .empty
        self.attachmentFileNames = Array(pdfFileNames.dropFirst())
        self.briefData = try JSONEncoder().encode(brief)
    }

    var brief: PermitBrief? {
        try? JSONDecoder().decode(PermitBrief.self, from: briefData)
    }
}

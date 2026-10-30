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
    var translationData: Data?
    var detailedRouteData: Data?

    init(id: UUID, pdfFileNames: [String], brief: PermitBrief, translation: PermitBriefTranslation?) throws {
        self.id = id
        self.createdAt = .now
        self.pdfFileName = pdfFileNames.first ?? .empty
        self.attachmentFileNames = Array(pdfFileNames.dropFirst())
        self.briefData = try JSONEncoder().encode(brief)
        self.translationData = try translation.map { try JSONEncoder().encode($0) }
    }

    var brief: PermitBrief? {
        if let translation, translation.language == Bundle.main.languageCode {
            return translation.brief
        }
        return englishBrief
    }

    var englishBrief: PermitBrief? {
        try? JSONDecoder().decode(PermitBrief.self, from: briefData)
    }

    var translation: PermitBriefTranslation? {
        translationData.flatMap { try? JSONDecoder().decode(PermitBriefTranslation.self, from: $0) }
    }

    var detailedRoute: PermitDetailedRoute? {
        detailedRouteData.flatMap { try? JSONDecoder().decode(PermitDetailedRoute.self, from: $0) }
    }
}

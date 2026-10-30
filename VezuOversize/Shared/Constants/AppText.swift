import Foundation

enum AppText {
    enum AppTab {
        static let permits = String(localized: "Permits")
        static let info = String(localized: "Info")
    }

    enum Permits {
        static let title = String(localized: "Permits")
        static let subtitle = String(localized: "Add · Read · Drive")
        static let importTitle = String(localized: "Import")
        static let delete = String(localized: "Delete")
    }

    enum PermitsEmptyState {
        static let title = String(localized: "No permits yet")
        static let subtitle = String(localized: "Import a permit PDF to turn it \ninto a clear driving brief.")
        static let shareTitle = String(localized: "Have a permit in another app?")
        static let shareMessage = String(localized: "Open the PDF in Mail, Telegram, or Files, \nthen tap Share → VEZU.")
        static let demoTitle = String(localized: "Try a demo permit")
        static let demoMessage = String(localized: "See how a permit brief works.")
    }

    enum PermitImport {
        static let reading = String(localized: "Reading permit…")
        static let readingHint = String(localized: "Usually under a minute")
        static let failed = String(localized: "Couldn't read this permit")
        static let notAPermit = String(localized: "Not a permit")
        static let errorTitle = String(localized: "Couldn't open this file")
        static let reloadErrorTitle = String(localized: "Couldn't reload this permit")
        static let reloading = String(localized: "RELOADING…")
        static let retry = String(localized: "Try Again")
        static let remove = String(localized: "Remove")

        static let onePermit = String(localized: "One permit with attachments")
        static let permitFileName = "permit.pdf"

        static func attachmentFileName(_ index: Int) -> String {
            "attachment-\(index).pdf"
        }

        static let groupingMessage = String(localized: "Pick one permit if these are a permit and its condition sheets.")

        static func groupingTitle(_ count: Int) -> String {
            String(localized: "How should these \(count) files be read?")
        }

        static func separatePermits(_ count: Int) -> String {
            String(localized: "\(count) separate permits")
        }

        static func moreFiles(_ count: Int) -> String {
            String(localized: "+ \(count) files")
        }
    }

    enum Info {
        static let language = String(localized: "Language")
        static let learn = String(localized: "Learn")
        static let tryIt = String(localized: "Try It")
        static let safetyAndPrivacy = String(localized: "Safety & Privacy")

        static let addTitle = String(localized: "Add a permit")
        static let addSubtitle = String(localized: "Import a PDF or open it from Mail, Telegram, or Files.")
        static let importTitle = String(localized: "Tap Import")
        static let importMessage = String(localized: "On the Permits screen, tap Import and pick the PDF in Files.")
        static let shareTitle = String(localized: "Or share it to VEZU")
        static let shareMessage = String(localized: "Open the PDF in Mail, Telegram, or Files, tap Share, then tap VEZU.")
        static let attachmentsTitle = String(localized: "Permit with condition sheets")
        static let attachmentsMessage = String(localized: "Pick all its files at once and choose One permit with attachments. Up to 5 files, 10 MB in total.")
        static let waitTitle = String(localized: "Wait for the brief")
        static let waitMessage = String(localized: "Reading usually takes under a minute.")

        static let readTitle = String(localized: "Read the brief")
        static let readSubtitle = String(localized: "See key details, restrictions, and requirements.")
        static let restrictionsTitle = String(localized: "Key restrictions first")
        static let restrictionsMessage = String(localized: "Night travel, max speed, and escorts at the top, then travel times and weather rules.")
        static let alertsTitle = String(localized: "Alerts")
        static let alertsMessage = String(localized: "Warnings from the permit you shouldn't miss.")
        static let detailsTitle = String(localized: "Load, vehicle, and documents")
        static let detailsMessage = String(localized: "Dimensions, weights, required equipment, and what to carry.")
        static let doubleCheckTitle = String(localized: "Points to double-check")
        static let doubleCheckMessage = String(localized: "If a second reading doesn't match, VEZU lists those points so you can check the paper permit.")
        static let originalTitle = String(localized: "Original PDF")
        static let originalMessage = String(localized: "Open the original anytime from the ⋯ menu in the brief.")

        static let driveTitle = String(localized: "Drive the route")
        static let driveMessage = String(localized: "Send the permitted route to Google Maps, stop by stop.")
        static let routeTitle = String(localized: "Open the route")
        static let routeMessage = String(localized: "Tap Route in a brief to see every step and the roads you can't take.")
        static let navigateTitle = String(localized: "Tap Navigate")
        static let navigateMessage = String(localized: "VEZU places the stops on the map and opens them in Google Maps.")
        static let partsTitle = String(localized: "Long routes open in parts")
        static let partsMessage = String(localized: "Google Maps takes up to 9 stops per link. Open the next part when you reach the end of one.")

        static let safetyTitle = String(localized: "Drive safely")
        static let safetySubtitle = String(localized: "Briefs are written by AI. Always check the brief against your paper permit.")
        static let aiTitle = String(localized: "Briefs are written by AI")
        static let aiMessage = String(localized: "AI can make mistakes. Always check the brief against your paper permit.")
        static let navigationTitle = String(localized: "Not truck navigation")
        static let navigationMessage = String(localized: "Google Maps doesn't know your load size and may reroute off the permit. Always drive the permitted roads.")
        static let carryTitle = String(localized: "Carry the original permit")
        static let carryMessage = String(localized: "Keep the permit and its required documents with you on every trip.")

        static let privacyTitle = String(localized: "Your privacy")
        static let privacySubtitle = String(localized: "Permits are saved on this phone. The VEZU server doesn't keep them.")
        static let onPhoneTitle = String(localized: "Stored on this phone")
        static let onPhoneMessage = String(localized: "Your permits, their PDFs, and routes are saved only on this phone.")
        static let notKeptTitle = String(localized: "Read, not kept")
        static let notKeptMessage = String(localized: "PDFs are sent to the VEZU server and read by Claude, an AI by Anthropic. VEZU doesn't keep them. Anthropic deletes them within 30 days and doesn't train AI on them.")
        static let cleanupTitle = String(localized: "Expired permits are removed")
        static let cleanupMessage = String(localized: "They're deleted from this phone 30 days after they expire.")

        static let mapDataCredit = String(localized: "Road data © OpenStreetMap contributors")
        static let stateBordersCredit = String(localized: "State borders: US Census Bureau")
        static let copyright = "© 2026 Stepan Kukharskyi"
        static let privacyPolicy = String(localized: "Privacy Policy")

        static func version(_ version: String) -> String {
            "VEZU Oversize \(version)"
        }
    }

    enum AIConsent {
        static let title = String(localized: "Before VEZU reads your permit")
        static let subtitle = String(localized: "VEZU uses AI to turn your permit PDF into a brief and a route.")
        static let sentTitle = String(localized: "What is sent")
        static let sentMessage = String(localized: "The PDFs you add, with everything on them: names, phone numbers, vehicle details, and the route.")
        static let readerTitle = String(localized: "Who reads it")
        static let readerMessage = String(localized: "The VEZU server passes the PDFs to Claude, an AI by Anthropic, which writes the brief and the route.")
        static let keptTitle = String(localized: "How long it's kept")
        static let keptMessage = String(localized: "VEZU doesn't keep your PDFs on its server. Anthropic deletes them within 30 days and doesn't train AI on them.")
        static let privacyPolicy = String(localized: "Privacy Policy")
        static let agree = String(localized: "Agree and Continue")
        static let notNow = String(localized: "Not Now")
    }

    enum Common {
        static let ok = String(localized: "OK")
        static let cancel = String(localized: "Cancel")
        static let done = String(localized: "Done")
    }

    enum Filter {
        static let all = String(localized: "All")
        static let active = String(localized: "filter.active", defaultValue: "Active")
        static let upcoming = String(localized: "filter.upcoming", defaultValue: "Upcoming")
        static let expired = String(localized: "filter.expired", defaultValue: "Expired")
    }

    enum PermitStatus {
        static let active = String(localized: "status.active", defaultValue: "Active")
        static let upcoming = String(localized: "status.upcoming", defaultValue: "Upcoming")
        static let expired = String(localized: "status.expired", defaultValue: "Expired")
    }

    enum PermitBrief {
        static let nightTravel = String(localized: "Night travel")
        static let maxSpeed = String(localized: "Max speed")
        static let escorts = String(localized: "Escorts")
        static let notStated = String(localized: "Not stated")

        static func speed(_ mph: Int) -> String {
            Measurement(value: Double(mph), unit: UnitSpeed.milesPerHour)
                .formatted(.measurement(width: .abbreviated, usage: .asProvided))
        }

        static func title(for status: PermitCriticalAnswer.Status) -> String {
            switch status {
            case .allowed:
                return String(localized: "Allowed")
            case .prohibited:
                return String(localized: "Not allowed")
            case .conditional:
                return String(localized: "Only in some cases")
            case .stated:
                return String(localized: "Limited")
            case .required:
                return String(localized: "Required")
            case .notRequired:
                return String(localized: "Not required")
            case .notStated:
                return notStated
            }
        }

        static let reviewNotes = String(localized: "Check the Paper Permit")
        static let reviewNotesMessage = String(localized: "A second reading of your permit didn't match on these points:")
        static let unreadableDates = String(localized: "The permit dates couldn't be read.")

        static let viewOriginal = String(localized: "View Original PDF")
        static let reload = String(localized: "Reload Permit")
        static let deletePermit = String(localized: "Delete Permit")
        static let deleteTitle = String(localized: "Delete this permit?")
        static let deleteMessage = String(localized: "This removes the permit and its PDF from this phone.")
        static let delete = String(localized: "Delete")

        static let keyRestrictions = String(localized: "Key Restrictions")
        static let noRestrictions = String(localized: "No special restrictions")

        static let front = String(localized: "front")
        static let rear = String(localized: "rear")
        static let frontAndRear = String(localized: "front & rear")

        static func escortCars(_ count: Int) -> String {
            String(localized: "\(count) escort cars")
        }

        static let route = String(localized: "Route")
        static let alerts = String(localized: "Alerts")

        static let loadInfo = String(localized: "Load")
        static let height = String(localized: "Height")
        static let width = String(localized: "Width")
        static let length = String(localized: "Length")
        static let grossWeight = String(localized: "Gross weight")
        static let axles = String(localized: "Axles")

        static let vehicleInfo = String(localized: "Vehicle")
        static let unit = String(localized: "Unit")
        static let plate = String(localized: "Plate")
        static let vin = String(localized: "VIN")

        static let requiredEquipment = String(localized: "Required Equipment")
        static let documents = String(localized: "Documents to Carry")
        static let contacts = String(localized: "Contacts")
        static let permitFee = String(localized: "Permit Fee")
        static let aiDisclaimer = String(localized: "Summarized by AI. Always check the original permit.")

        static let start = String(localized: "Start")
        static let arrive = String(localized: "Arrive")
        static let totalDistance = String(localized: "Total distance")
        static let notAllowed = String(localized: "Not Allowed")
        static let directions = String(localized: "Directions")
        static let toll = String(localized: "Toll")

        static func steps(_ count: Int) -> String {
            String(localized: "\(count) steps")
        }

        static let preparingNavigation = String(localized: "Preparing navigation route…")
        static let retry = String(localized: "Try Again")
        static let navigate = String(localized: "Navigate")
        static let openInGoogleMaps = String(localized: "Open in Google Maps")

        static func openPart(_ part: Int, of total: Int) -> String {
            String(localized: "Open Part \(part) of \(total)")
        }

        static func mapsParts(_ count: Int) -> String {
            String(localized: "Google Maps takes up to 9 stops per link, so this route opens in \(count) parts. Open the next part when you reach the end of one.")
        }

        static let startsFromYourLocation = String(localized: "Starts from your location")

        static func driveToStartFirst(_ start: String) -> String {
            String(localized: "Drive to \(start) first")
        }
        static let navigationRiskTitle = String(localized: "Not truck navigation")
        static let navigationRiskMessage = String(localized: "Google Maps doesn't know your load size and may reroute off the permit. Always drive the permitted roads.")

        static func waypoints(_ count: Int) -> String {
            String(localized: "\(count) waypoints")
        }

        static func unresolvedWaypoints(_ count: Int) -> String {
            String(localized: "\(count) places couldn't be found on the map and are left out of the route.")
        }
    }
}

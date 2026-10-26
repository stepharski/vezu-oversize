import Foundation

enum AppText {
    enum AppTab {
        static let permits = "Permits"
        static let info = "Info"
    }

    enum Permits {
        static let title = "Permits"
        static let subtitle = "Add · Read · Drive"
        static let importTitle = "Import"
        static let delete = "Delete"
    }

    enum PermitsEmptyState {
        static let title = "No permits yet"
        static let subtitle = "Import a permit PDF to turn it \ninto a clear driving brief."
        static let shareTitle = "Have a permit in another app?"
        static let shareMessage = "Open the PDF in Mail, Telegram, or Files, \nthen tap Share → VEZU."
        static let demoTitle = "Try a demo permit"
        static let demoMessage = "See how a permit brief works."
    }

    enum PermitImport {
        static let reading = "Reading permit…"
        static let readingHint = "Usually under a minute"
        static let failed = "Couldn't read this permit"
        static let notAPermit = "Not a permit"
        static let errorTitle = "Couldn't open this file"
        static let reloadErrorTitle = "Couldn't reload this permit"
        static let reloading = "RELOADING…"
        static let retry = "Try Again"
        static let remove = "Remove"

        static let onePermit = "One permit with attachments"
        static let permitFileName = "permit.pdf"

        static func attachmentFileName(_ index: Int) -> String {
            "attachment-\(index).pdf"
        }

        static let groupingMessage = "Pick one permit if these are a permit and its condition sheets."

        static func groupingTitle(_ count: Int) -> String {
            "How should these \(count) files be read?"
        }

        static func separatePermits(_ count: Int) -> String {
            "\(count) separate permits"
        }

        static func moreFiles(_ count: Int) -> String {
            count == 1 ? "+ 1 file" : "+ \(count) files"
        }
    }

    enum Info {
        static let mapDataCredit = "Road data © OpenStreetMap contributors"
    }

    enum Common {
        static let ok = "OK"
        static let cancel = "Cancel"
    }

    enum Filter {
        static let all = "All"
        static let active = "Active"
        static let upcoming = "Upcoming"
        static let expired = "Expired"
    }

    enum PermitStatus {
        static let active = "Active"
        static let upcoming = "Upcoming"
        static let expired = "Expired"
    }

    enum PermitBrief {
        static let nightTravel = "Night travel"
        static let maxSpeed = "Max speed"
        static let escorts = "Escorts"
        static let notStated = "Not stated"

        static func speed(_ mph: Int) -> String {
            "\(mph) mph"
        }

        static func title(for status: PermitCriticalAnswer.Status) -> String {
            switch status {
            case .allowed:
                return "Allowed"
            case .prohibited:
                return "Not allowed"
            case .conditional:
                return "Only in some cases"
            case .stated:
                return "Limited"
            case .required:
                return "Required"
            case .notRequired:
                return "Not required"
            case .notStated:
                return notStated
            }
        }

        static let reviewNotes = "Check the Paper Permit"
        static let reviewNotesMessage = "A second reading of your permit didn't match on these points:"
        static let unreadableDates = "The permit dates couldn't be read."

        static let viewOriginal = "View Original PDF"
        static let reload = "Reload Permit"
        static let deletePermit = "Delete Permit"
        static let deleteTitle = "Delete this permit?"
        static let deleteMessage = "This removes the permit and its PDF from this phone."
        static let delete = "Delete"

        static let keyRestrictions = "Key Restrictions"
        static let noRestrictions = "No special restrictions"

        static let front = "front"
        static let rear = "rear"
        static let frontAndRear = "front & rear"

        static func escortCars(_ count: Int) -> String {
            count == 1 ? "1 escort car" : "\(count) escort cars"
        }

        static let route = "Route"
        static let alerts = "Alerts"

        static let loadInfo = "Load"
        static let height = "Height"
        static let width = "Width"
        static let length = "Length"
        static let grossWeight = "Gross weight"
        static let axles = "Axles"

        static let vehicleInfo = "Vehicle"
        static let unit = "Unit"
        static let plate = "Plate"
        static let vin = "VIN"

        static let requiredEquipment = "Required Equipment"
        static let documents = "Documents to Carry"
        static let contacts = "Contacts"
        static let permitFee = "Permit Fee"
        static let aiDisclaimer = "Summarized by AI. Always check the original permit."

        static let start = "Start"
        static let arrive = "Arrive"
        static let totalDistance = "Total distance"
        static let notAllowed = "Not Allowed"
        static let directions = "Directions"
        static let toll = "Toll"

        static func steps(_ count: Int) -> String {
            count == 1 ? "1 step" : "\(count) steps"
        }

        static let preparingNavigation = "Preparing navigation route…"
        static let retry = "Try Again"
        static let navigate = "Navigate"
        static let openInGoogleMaps = "Open in Google Maps"

        static func openPart(_ part: Int, of total: Int) -> String {
            "Open Part \(part) of \(total)"
        }

        static func mapsParts(_ count: Int) -> String {
            "Google Maps takes up to 9 stops per link, so this route opens in \(count) parts. Open the next part when you reach the end of one."
        }

        static let startsFromYourLocation = "Starts from your location"

        static func driveToStartFirst(_ start: String) -> String {
            "Drive to \(start) first"
        }
        static let navigationRiskTitle = "Not truck navigation"
        static let navigationRiskMessage = "Google Maps doesn't know your load size and may reroute off the permit. Always drive the permitted roads."

        static func waypoints(_ count: Int) -> String {
            count == 1 ? "1 waypoint" : "\(count) waypoints"
        }

        static func unresolvedWaypoints(_ count: Int) -> String {
            count == 1
                ? "1 place couldn't be found on the map and is left out of the route."
                : "\(count) places couldn't be found on the map and are left out of the route."
        }
    }
}

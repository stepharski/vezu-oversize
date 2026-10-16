import Foundation

enum AppText {
    enum Tabs {
        static let permits = "Permits"
        static let info = "Info"
    }

    enum Permits {
        static let title = "Permits"
        static let subtitle = "Add · Read · Drive"
        static let importTitle = "Import"
    }

    enum PermitsEmptyState {
        static let title = "No permits yet"
        static let subtitle = "Import a permit PDF to turn it \ninto a clear driving brief."
        static let shareTitle = "Have a permit in another app?"
        static let shareMessage = "Open the PDF in Mail, Telegram, or Files, \nthen tap Share → VEZU."
        static let demoTitle = "Try a demo permit"
        static let demoMessage = "See how a permit brief works."
    }

    enum Filter {
        static let all = "All"
        static let active = "Active"
        static let expired = "Expired"
    }

    enum PermitStatus {
        static let active = "Active"
        static let expired = "Expired"
    }

    enum PermitBrief {
        static let keyRestrictions = "Key Restrictions"
        static let noRestrictions = "No special restrictions"

        static let escortRequirements = "Escort Requirements"
        static let noEscortRequired = "No escort required"
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

        static let start = "Start"
        static let arrive = "Arrive"
        static let totalDistance = "Total distance"
        static let notAllowed = "Not Allowed"
        static let directions = "Directions"
        static let toll = "Toll"

        static func steps(_ count: Int) -> String {
            count == 1 ? "1 step" : "\(count) steps"
        }
    }
}

import SwiftUI

struct VehicleInfoCell: View {
    let vehicle: PermitVehicle

    var body: some View {
        BriefSectionCell(
            title: AppText.PermitBrief.vehicleInfo,
            systemImage: "truck.box") {
                if let title {
                    titleLabel(title)
                }

                details
            }
    }
}

private extension VehicleInfoCell {
    var title: String? {
        let parts = [vehicle.year, vehicle.make, vehicle.type].compactMap { $0 }
        return parts.isEmpty ? nil : parts.joined(separator: " ")
    }

    var plate: String? {
        guard let plate = vehicle.plate else { return nil }
        guard let state = vehicle.plateState else { return plate }
        return "\(plate) · \(state)"
    }

    func titleLabel(_ title: String) -> some View {
        Text(title)
            .font(.body.weight(.semibold))
            .foregroundStyle(Color.primaryWhite)
    }

    var details: some View {
        VStack(spacing: Design.rowSpacing) {
            if let unitNumber = vehicle.unitNumber {
                BriefInfoRow(title: AppText.PermitBrief.unit, value: unitNumber)
            }

            if let plate {
                BriefInfoRow(title: AppText.PermitBrief.plate, value: plate)
            }

            if let vin = vehicle.vin {
                BriefInfoRow(title: AppText.PermitBrief.vin, value: vin)
            }
        }
    }
}

private extension VehicleInfoCell {
    enum Design {
        static let rowSpacing: CGFloat = 10
    }
}

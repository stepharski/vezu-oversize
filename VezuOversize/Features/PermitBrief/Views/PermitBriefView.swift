import SwiftUI

struct PermitBriefView: View {
    @State private var viewModel: PermitBriefViewModel

    init(viewModel: PermitBriefViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ZStack {
            AppBackgroundView()
            content
        }
        .navigationTitle(brief.state)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $viewModel.showsRoute) {
            RouteDetailView(route: brief.route)
        }
    }
}

// MARK: - Components
private extension PermitBriefView {
    var brief: PermitBrief {
        viewModel.brief
    }

    var content: some View {
        ScrollView {
            LazyVStack(spacing: Design.cellSpacing) {
                summaryCell
                KeyRestrictionsCell(restrictions: brief.restrictions)
                EscortRequirementsCell(escorts: brief.escorts)
                RouteCell(route: brief.route, onTap: viewModel.routeTapped)

                if !brief.alerts.isEmpty {
                    AlertsCell(alerts: brief.alerts)
                }

                LoadInfoCell(load: brief.load)
                VehicleInfoCell(vehicle: brief.vehicle)

                if !brief.equipment.isEmpty {
                    RequiredEquipmentCell(equipment: brief.equipment)
                }

                if !brief.documents.isEmpty {
                    DocumentsCell(documents: brief.documents)
                }

                if !brief.contacts.isEmpty {
                    ContactsCell(contacts: brief.contacts)
                }

                PermitFeeCell(feeText: viewModel.feeText)
            }
            .padding(.horizontal, Design.xPadding)
            .padding(.vertical, Design.yPadding)
        }
        .scrollIndicators(.hidden)
    }

    var summaryCell: some View {
        PermitSummaryCell(
            permitType: brief.permitType,
            number: brief.number,
            dateRangeText: viewModel.dateRangeText,
            status: viewModel.status
        )
    }
}

// MARK: - Design
private enum Design {
    static let xPadding: CGFloat = 16
    static let yPadding: CGFloat = 8
    static let cellSpacing: CGFloat = 12
}

#Preview {
    NavigationStack {
        PermitBriefView(viewModel: PermitBriefViewModel(brief: .demo))
    }
}

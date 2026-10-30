import SwiftUI
import QuickLook

struct PermitBriefView: View {
    @State var viewModel: PermitBriefViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppBackgroundView()
            content
        }
        .navigationTitle(brief.state)
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(isPresented: $viewModel.isRoutePresented) {
            RouteDetailView(viewModel: viewModel.routeViewModel())
        }
        .toolbar {
            if viewModel.canDelete {
                ToolbarItem(placement: .topBarTrailing) {
                    moreMenu
                }
            }
        }
        .quickLookPreview($viewModel.previewURL, in: viewModel.pdfURLs)
        .alert(AppText.PermitBrief.deleteTitle, isPresented: $viewModel.isDeleteConfirmationPresented) {
            Button(AppText.PermitBrief.delete, role: .destructive) {
                if viewModel.didConfirmDelete() {
                    dismiss()
                }
            }
            Button(AppText.Common.cancel, role: .cancel) {}
        } message: {
            Text(AppText.PermitBrief.deleteMessage)
        }
    }
}

private extension PermitBriefView {
    var brief: PermitBrief {
        viewModel.brief
    }

    var moreMenu: some View {
        Menu {
            if viewModel.hasOriginal {
                Button(AppText.PermitBrief.viewOriginal, systemImage: "doc.text.magnifyingglass") {
                    viewModel.didTapViewOriginal()
                }

                Button(AppText.PermitBrief.reload, systemImage: "arrow.clockwise") {
                    Task { await viewModel.reload() }
                    dismiss()
                }
            }

            Button(AppText.PermitBrief.deletePermit, systemImage: "trash", role: .destructive) {
                viewModel.didTapDelete()
            }
            .tint(.red)
        } label: {
            Image(systemName: "ellipsis")
        }
    }

    var content: some View {
        ScrollView {
            LazyVStack(spacing: Design.cellSpacing) {
                summaryCell
                KeyRestrictionsCell(restrictions: brief.restrictions, escorts: brief.escorts, critical: brief.critical)

                if let reviewNotes = brief.reviewNotes, !reviewNotes.isEmpty {
                    ReviewNotesCell(notes: reviewNotes)
                }

                RouteCell(route: brief.route, onTap: viewModel.didTapRoute)

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

                disclaimer
                    .padding(.top, Design.disclaimerTopPadding)
            }
            .padding(.horizontal, Design.horizontalPadding)
            .padding(.vertical, Design.verticalPadding)
        }
        .scrollIndicators(.hidden)
    }

    var disclaimer: some View {
        Label(AppText.PermitBrief.aiDisclaimer, systemImage: "sparkles")
            .font(.footnote)
            .foregroundStyle(Color.secondaryGray)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }

    var summaryCell: some View {
        PermitSummaryCell(
            permitType: brief.permitType,
            number: brief.number,
            dateRangeText: viewModel.dateRangeText,
            status: viewModel.status)
    }
}

private extension PermitBriefView {
    enum Design {
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 8
        static let cellSpacing: CGFloat = 12
        static let disclaimerTopPadding: CGFloat = 8
    }
}

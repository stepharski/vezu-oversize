import Foundation

@Observable
final class PermitBriefViewModel {
    let brief: PermitBrief
    var showsRoute = false

    init(brief: PermitBrief) {
        self.brief = brief
    }

    var feeText: String {
        brief.fee.formatted(.currency(code: "USD"))
    }

    var dateRangeText: String {
        brief.validFrom.rangeText(to: brief.validTo, includesYear: true)
    }

    var status: PermitStatus {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let lastDay = calendar.startOfDay(for: brief.validTo)
        return today > lastDay ? .expired : .active
    }

    func routeTapped() {
        showsRoute = true
    }
}

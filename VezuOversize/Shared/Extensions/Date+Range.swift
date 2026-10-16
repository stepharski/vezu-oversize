import Foundation

extension Date {
    func rangeText(to end: Date, includesYear: Bool = false) -> String {
        let dayStyle = Date.FormatStyle.dateTime.month(.abbreviated).day()
        let endStyle = includesYear ? dayStyle.year() : dayStyle
        return "\(formatted(dayStyle)) – \(end.formatted(endStyle))"
    }
}

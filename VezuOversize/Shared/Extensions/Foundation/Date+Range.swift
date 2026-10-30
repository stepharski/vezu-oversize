import Foundation

extension Date {
    func rangeText(to end: Date, includesYear: Bool = false) -> String {
        let dayStyle = Date.FormatStyle.dateTime.month(.abbreviated).day()
        let endStyle = includesYear ? dayStyle.year() : dayStyle
        guard self <= end else {
            return "\(formatted(dayStyle)) – \(end.formatted(endStyle))"
        }

        let intervalStyle = Date.IntervalFormatStyle().month(.abbreviated).day()
        return (self..<end).formatted(includesYear ? intervalStyle.year() : intervalStyle)
    }
}

import Foundation

extension Double {
    var milesText: String {
        Measurement(value: self, unit: UnitLength.miles)
            .formatted(.measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.precision(.fractionLength(0...1))))
    }
}

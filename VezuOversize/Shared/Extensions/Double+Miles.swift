import Foundation

extension Double {
    var milesText: String {
        "\(formatted(.number.precision(.fractionLength(0...1)))) mi"
    }
}

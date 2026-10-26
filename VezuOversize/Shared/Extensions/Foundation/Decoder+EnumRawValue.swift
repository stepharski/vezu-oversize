import Foundation

nonisolated extension Decoder {
    func enumRawValue() throws -> String {
        if let value = try? singleValueContainer().decode(String.self) {
            return value
        }
        guard let key = try container(keyedBy: AnyCodingKey.self).allKeys.first else {
            throw DecodingError.dataCorrupted(.init(codingPath: codingPath, debugDescription: "Missing enum value"))
        }
        return key.stringValue
    }
}

private nonisolated struct AnyCodingKey: CodingKey {
    let stringValue: String
    let intValue: Int? = nil

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}

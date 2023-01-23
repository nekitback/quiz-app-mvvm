import Foundation
import FirebaseDatabase

extension DataSnapshot {
    var data: Data? {
        guard let value = value, !(value is NSNull) else { return nil }
        return try? JSONSerialization.data(withJSONObject: value)
    }
    var json: String? { data?.string }
}

extension Data {
    var string: String? { String(data: self, encoding: .utf8) }
}

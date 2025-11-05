import Foundation

/// A lightweight wrapper around `UUID` that normalizes string representation to lowercase
/// and enforces version 4 UUID spec
///
/// The primary purpose of `UUIDv4` is to ensure that encoding (via `Codable`) produces
/// a lowercased UUID string. Decoding accepts the standard `UUID` representation and
/// preserves value equality regardless of original letter casing.
///
/// This type represents a version 4 UUID RFC 4122 formatted as five groups of hexadecimal
/// characters separated by hyphens. The format is 8–4–4–4–12. According to the spec, a
/// UUID v4 should have certain fixed bits. The format is `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`
/// where x is any random hex digit and `y` is one of `8`, `9`, `A`, or `B`.
public struct UUIDv4 {
        
    /// The underlying `UUID` value.
    private let wrappedValue: UUID
    
    /// The UUID string in lowercase
    ///
    /// This mirrors the encoded representation to provide a consistent, case-insensitive
    /// canonical form
    public var uuidString: String {
        return wrappedValue.uuidString.lowercased()
    }
    
    /// Creates a new random UUIDv4
    public init() {
        self.init(uuid: UUID())
    }
    
    /// Creates a wrapper from a version 4 UUID string
    ///
    /// This constructor validates against version 4 UUID from RFC 4122. As such it accepts a
    /// formatted string, in the format 8–4–4–4–12. Fixed bits are also validated. If validation
    /// fails this will return `nil`
    ///
    /// - Parameter uuidString: A UUID string in any valid case. The internal representation is
    ///   stored as `UUID`, while the exposed `uuidString` and encoded value are lowercase.
    public init?(uuidString: String) {
        
        guard
            Self.isValid(uuidV4String: uuidString),
            let uuid = UUID(uuidString: uuidString)
        else { return nil }
        
        self.init(uuid: uuid)
        
    }
    
    /// Creates a `UUIDv4` instance from an existing `UUID`
    ///
    /// This initializer wraps the provided `UUID` and preserves its value.
    /// The public `uuidString` property and any encoded representation will
    /// be normalized to lowercase to ensure a consistent, canonical form.
    ///
    /// - Parameter uuid: The `UUID` to wrap.
    ///
    /// - Important: This init method does not valid against version 4. However
    ///   it is understood the Swift `UUID` constructor will return a version 4.
    public init(uuid: UUID) {
        wrappedValue = uuid
    }
    
}

extension UUIDv4 {
    
    /// Validates whether a given string conforms to the RFC 4122 version 4 UUID format and is
    /// case insensitive
    ///
    /// This method checks that the input string:
    /// - Matches the canonical UUID format of 8-4-4-4-12 case insensitive hexadecimal characters
    ///   separated by hyphens.
    /// - Has the correct fixed version bit (`4`) in the third group.
    /// - Has a valid variant in the fourth group (one of `8`, `9`, `A`, or `B`,
    ///   case-insensitive).
    ///
    /// Internally, validation is performed using a regular expression UUID v4.
    ///
    /// - Parameter uuidV4String: The UUID string to validate. Letter casing is ignored for validation,
    ///   but the format must strictly match the canonical hyphenated form.
    ///
    /// - Returns: `true` if the string is a valid RFC 4122 version 4 UUID; otherwise, `false`.
    static func isValid(uuidV4String: String) -> Bool {
        
        let pattern = "^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-4[a-fA-F0-9]{3}-[89abAB][a-fA-F0-9]{3}-[a-fA-F0-9]{12}$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(
            uuidV4String.startIndex..<uuidV4String.endIndex,
            in: uuidV4String
        )
        
        guard
            regex.firstMatch(in: uuidV4String, options: [], range: range) != nil
        else { return false }
        
        return true
        
    }
    
}

extension UUIDv4: Codable {
    
    /// Creates a `UUIDv4` by decoding from the given decoder
    ///
    /// This initializer decodes a single `UUID` value from the decoder’s
    /// single-value container. It accepts any valid UUID string representation
    /// (regardless of letter casing), ensuring case-insensitive value equivalence.
    /// The internal `wrappedValue` is stored as a `UUID`, while any subsequent
    /// encoding or string access (`uuidString`) will be normalized to lowercase
    ///
    /// - Parameter decoder: The decoder to read the `UUID` value from.
    ///
    /// - Throws: An error if the decoder does not contain a valid `UUID` in a
    ///   single-value container or if the data is otherwise corrupted.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(UUID.self)
    }
    
    /// Encodes the `UUIDv4` into the given encoder as a lowercase UUID string
    ///
    /// This method writes the underlying `UUID`'s string representation to a
    /// single-value container, normalizing it to lowercase to ensure a consistent,
    /// canonical form across all encoded representations
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: An error if the value cannot be encoded into the provided encoder.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue.uuidString.lowercased())
    }
    
}

extension UUIDv4: CustomStringConvertible {
    
    /// Conforms to `CustomStringConvertible` to present the UUID as a lowercase string,
    /// matching the `Codable` encoding behavior.
    public var description: String { uuidString }
    
}

extension UUIDv4: Equatable {}
extension UUIDv4: Hashable {}
extension UUIDv4: Sendable {}

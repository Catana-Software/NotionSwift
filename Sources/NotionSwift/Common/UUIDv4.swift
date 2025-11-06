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
    
    /// Builds a standardized DecodingError for invalid UUID v4 inputs
    ///
    /// - Parameter decoder: The decoder providing the current coding path.
    /// - Parameter invalid: The raw string that failed validation.
    ///
    /// - Returns: A `DecodingError.typeMismatch` with a detailed debug description.
    private static func invalidV4(
        decoder: any Decoder,
        invalid: String
    ) -> DecodingError {
        
        let detail = "Invalid version 4 UUID String: \"\(invalid)\""
        
        return .typeMismatch(
            UUIDv4.self,
            .init(
                codingPath: decoder.codingPath,
                debugDescription: detail
            )
        )
        
    }
    
    /// Decodes a `UUIDv4` from a single-value container with RFC 4122 v4 validation
    ///
    /// This initializer expects the decoder to contain a single string value representing a
    /// UUID in the canonical 8-4-4-4-12 hyphenated form. Decoding performs strict validation
    /// against RFC 4122 version 4 rules:
    /// - The third group must have the fixed version nibble `4` (i.e. `xxxxxxxx-xxxx-4xxx-...`).
    /// - The first nibble of the fourth group (the variant) must be one of `8`, `9`, `A`, or `B`
    ///   (case-insensitive).
    /// - All hexadecimal characters may be upper- or lowercase; casing is ignored during validation.
    ///
    /// On success, the underlying `UUID` value is stored and any subsequent access via
    /// `uuidString` or encoded output is normalized to lowercase to ensure a canonical form.
    ///
    /// Validation details
    /// - Input must match the canonical hyphenated pattern exactly (8–4–4–4–12).
    /// - Inputs that do not satisfy version/variant bits or the canonical format are rejected.
    /// - Examples of invalid inputs include: missing hyphens, non-hex characters, wrong version
    ///   or an incorrect variant nibble.
    ///
    /// Error behavior
    /// - If the decoder does not contain a string, or the string fails UUID v4 validation,
    ///   this initializer throws `DecodingError.typeMismatch` with a debug description containing
    ///   the invalid string.
    /// - For example, a payload like `{ "created_by": { "id": "not-a-uuid" } }` would
    ///   fail with `.typeMismatch` at the corresponding coding path (e.g., `created_by.id`).
    ///
    /// - Parameter decoder: The decoder to read the UUID string from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the value is not a valid RFC 4122 version 4 UUID.
    public init(from decoder: any Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let uuidString = try container.decode(String.self)
        
        guard
            Self.isValid(uuidV4String: uuidString),
            let uuid = UUID(uuidString: uuidString)
        else {
            throw Self
                .invalidV4(
                    decoder: decoder,
                    invalid: uuidString
                )
        }
        
        self.init(uuid: uuid)
        
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
        try container.encode(uuidString)
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

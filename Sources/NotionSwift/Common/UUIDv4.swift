import Foundation

/// A lightweight wrapper around `UUID` that normalizes string representation to lowercase
///
/// The primary purpose of `UUIDv4` is to ensure that encoding (via `Codable`) produces
/// a lowercased UUID string. Decoding accepts the standard `UUID` representation and
/// preserves value equality regardless of original letter casing
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
    
    /// Creates a wrapper from a UUID string
    ///
    /// - Parameter uuidString: A UUID string in any valid case. The internal representation is
    ///   stored as `UUID`, while the exposed `uuidString` and encoded value are lowercase.
    public init?(uuidString: String) {
        
        guard
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
    public init(uuid: UUID) {
        wrappedValue = uuid
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

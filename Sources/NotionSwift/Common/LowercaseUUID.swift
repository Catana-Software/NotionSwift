import Foundation

/// A lightweight, value-type wrapper around Foundation’s `UUID` that normalizes its
/// textual representation to lowercase
///
/// LowercaseUUID preserves the full semantics of a UUID while ensuring that:
/// - The `uuidString` property is always lowercased.
/// - Encoding via `Codable` produces a lowercase UUID string.
/// - Decoding via `Codable` accepts any valid UUID (regardless of case) and stores it internally.
///
/// This type is useful when you need canonical, case insensitive UUID string forms for
/// tasks like hashing, equality checks, persistence, or interoperability with systems
/// that expect lowercase UUIDs.
///
/// Usage:
/// - Initialize with a new random UUID using `init()`.
/// - Initialize from an existing UUID string using `init?(uuidString:)`; returns `nil` if invalid.
/// - Initialize from an existing `UUID` using `init(uuid:)`.
///
/// Thread Safety:
/// - The type is an immutable value type and is `Sendable`.
///
/// Note:
/// - The internal `UUID` is preserved as-is; only the string representation is normalized.
/// - Equality and hashing are based on the underlying UUID value, not on string case.
public struct LowercaseUUID {
        
    /// The underlying `UUID` value.
    private let wrappedValue: UUID
    
    /// A canonical, lowercase textual representation of the underlying UUID
    /// 
    /// - Returns: The `uuidString` of the wrapped `UUID`, normalized to all lowercase characters.
    public var uuidString: String {
        return wrappedValue.uuidString.lowercased()
    }
    
    /// Creates a new `LowercaseUUID` with a freshly generated random `UUID`
    ///
    /// The resulting instance preserves the full UUID semantics while ensuring that
    /// its string representation (`uuidString`) is normalized to lowercase
    ///
    /// - Note: The underlying `UUID` is generated using `UUID()` and stored as-is.
    ///   Only its textual representation is lowercased.
    public init() {
        self.init(uuid: UUID())
    }
    
    /// Initialises a `LowercaseUUID` from a UUID string
    ///
    /// This initializer attempts to create a `LowercaseUUID` by parsing the provided
    /// string using Foundation’s `UUID(uuidString:)`. The underlying `UUID` is stored
    /// exactly as parsed, but any textual representation exposed by this type (such as
    /// `uuidString` or `description`) is normalized to lowercase.
    ///
    /// - Parameter uuidString: A string representation of a UUID. The format must be a valid
    ///   UUID string as recognized by `UUID(uuidString:)`. Letter casing is ignored.
    ///
    /// - Returns: A `LowercaseUUID` if the string is a valid UUID; otherwise, `nil`.
    ///
    /// - Note: Decoding is case-insensitive; encoding always produces a lowercase string.
    public init?(uuidString: String) {
        
        guard
            let uuid = UUID(uuidString: uuidString)
        else { return nil }
        
        self.init(uuid: uuid)
        
    }
    
    /// Initialises a `LowercaseUUID` from an existing `UUID` value
    ///
    /// The provided `UUID` is stored unchanged as the internal representation.
    /// Any textual representation exposed by this type (such as `uuidString`,
    /// `description`, or `Codable` encoding) is normalized to lowercase.
    ///
    /// - Parameter uuid: The `UUID` to wrap.
    ///
    /// - Note: Equality and hashing are based on the underlying `UUID` value, not its string form.
    public init(uuid: UUID) {
        wrappedValue = uuid
    }
    
}

extension LowercaseUUID: Codable {
    
    /// Creates a `LowercaseUUID` by decoding from the given decoder
    ///
    /// This initializer decodes a single value from the provided `Decoder`.
    /// The decoded `UUID` is stored internally unchanged; any textual
    /// representation exposed by this type (such as `uuidString` or when
    /// encoded again) will be normalized to lowercase
    ///
    /// - Parameter decoder: The decoder to read the `LowercaseUUID` from.
    ///
    /// - Throws: An error if the decoder is unable to decode a single value
    ///   container or if the contained value cannot be decoded as a `UUID`.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let uuid = try container.decode(UUID.self)
        self.init(uuid: uuid)
    }
    
    /// Encodes this `LowercaseUUID` into the given encoder as a single lowercase UUID string
    ///
    /// This method writes the value using a single value container and encodes the
    /// canonical, lowercase textual representation (`uuidString`) of the underlying `UUID`.
    /// As a result, any consumer that decodes this value as a `String` will receive a
    /// lowercase UUID, ensuring consistent, case-normalized serialization.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: An error if the encoder is unable to create a single value container.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(uuidString)
    }
    
}

extension LowercaseUUID: CustomStringConvertible {
    
    /// Conforms to `CustomStringConvertible` to present the UUID as a lowercase string,
    /// matching the `Codable` encoding behavior.
    public var description: String { uuidString }
    
}

extension LowercaseUUID: Equatable {}
extension LowercaseUUID: Hashable {}
extension LowercaseUUID: Sendable {}

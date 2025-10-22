import Foundation

extension Comment {
    
    /// A discriminator that identifies the display name of a comment as part of a create
    /// comment API call
    ///
    /// The Comment Display Name object represents the author name that shows up for a
    /// comment. This overrides the default author name when specified.
    public enum DisplayNameRequest {
        
        /// Any custom name
        case custom(name: String)
        
        /// An integration authored the comment
        case integration
        
        /// A user authenticated the integration (only for Public Integrations)
        case user
        
    }
    
}

extension Comment.DisplayNameRequest: Codable {
    
    /// A private type for encoding/decoding the custom name object required
    /// by the call to the API endpoint for creating comments
    private struct CustomNameObject: Codable {
        let name: String
    }
    
    private enum TypeKey: String, Codable {
        case integration
        case user
        case custom
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case name
        case custom
    }
    
    public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(TypeKey.self, forKey: .type)
        
        switch type {
            
        case .integration:
            self = .integration
            
        case .user:
            self = .user
            
        case .custom:
            let customName = try container.decode(CustomNameObject.self, forKey: .custom)
            self = .custom(name: customName.name)
            
        }
        
    }
    
    public func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            
        case .integration:
            try container.encode(TypeKey.integration, forKey: .type)
            
        case .user:
            try container.encode(TypeKey.user, forKey: .type)
            
        case .custom(let name):
            try container.encode(TypeKey.custom, forKey: .type)
            let customName = CustomNameObject(name: name)
            try container.encode(customName, forKey: .custom)
            
        }
        
    }
    
}

extension Comment.DisplayNameRequest: Equatable {}
extension Comment.DisplayNameRequest: Sendable {}

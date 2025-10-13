import Foundation

extension Comment {
    
    /// A discriminator that identifies the display name of a comment
    ///
    /// The Comment Display Name object represents the author name that shows up for a comment.
    /// This overrides the default author name when specified
    public enum DisplayName {
        
        /// Any custom name
        case custom(resolvedName: String)
        
        /// The name of the integration
        case integration(resolvedName: String)
        
        /// The name of the user who authenticated the integration (only for Public Integrations)
        case user(resolvedName: String)
        
    }
    
}

extension Comment.DisplayName: Codable {
    
    private enum TypeKey: String, Codable {
        case integration
        case user
        case custom
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case resolvedName = "resolved_name"
    }
    
    public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(TypeKey.self, forKey: .type)
        let name = try container.decode(String.self, forKey: .resolvedName)
        
        switch type {
        case .integration:
            self = .integration(resolvedName: name)
            
        case .user:
            self = .user(resolvedName: name)
            
        case .custom:
            self = .custom(resolvedName: name)
            
        }
        
    }
    
    public func encode(to encoder: any Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
            
        case .integration(let resolvedName):
            try container.encode(TypeKey.integration, forKey: .type)
            try container.encode(resolvedName, forKey: .resolvedName)
            
        case .user(let resolvedName):
            try container.encode(TypeKey.user, forKey: .type)
            try container.encode(resolvedName, forKey: .resolvedName)
            
        case .custom(let resolvedName):
            try container.encode(TypeKey.custom, forKey: .type)
            try container.encode(resolvedName, forKey: .resolvedName)
            
        }
        
    }
    
}

extension Comment.DisplayName: Equatable {}
extension Comment.DisplayName: Sendable {}

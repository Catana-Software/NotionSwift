import Foundation

extension BlockType.CommentBlockValue {
    
    /// A discriminator that identifies the parent context of a comment.
    ///
    /// This value indicates where a comment belongs in the hierarchy of content.
    /// It mirrors the wire format used when encoding/decoding from the API by
    /// emitting a `type` key alongside the associated identifiers (when present).
    public enum Parent {
        
        /// The comment belongs to a database.
        ///
        /// - Parameter id: The identifier of the database that owns the comment.
        case database(UUIDv4)
        
        /// The comment belongs to a data source inside a specific database.
        ///
        /// - Parameter id: The identifier of the data source.
        /// - Parameter databaseId: The identifier of the database that contains the
        ///   data source.
        case dataSource(id: UUIDv4, databaseId: UUIDv4)
        
        /// The comment belongs to a page.
        ///
        /// - Parameter id: The identifier of the page that owns the comment.
        case page(UUIDv4)
        
        /// The comment belongs to the current workspace (no additional identifier required).
        case workspace
        
    }
    
}

extension BlockType.CommentBlockValue.Parent: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case type
        case databaseId = "database_id"
        case dataSourceId = "data_source_id"
        case pageId = "page_id"
        case workspace
    }

    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        switch type {
        case CodingKeys.databaseId.rawValue:
            let id = try container.decode(UUIDv4.self, forKey: .databaseId)
            self = .database(id)
            
        case CodingKeys.dataSourceId.rawValue:
            let ds = try container.decode(UUIDv4.self, forKey: .dataSourceId)
            let db = try container.decode(UUIDv4.self, forKey: .databaseId)
            self = .dataSource(id: ds, databaseId: db)
            
        case CodingKeys.pageId.rawValue:
            let id = try container.decode(UUIDv4.self, forKey: .pageId)
            self = .page(id)
            
        case CodingKeys.workspace.rawValue:
            self = .workspace
            
        default:
            let context = DecodingError
                .Context(
                    codingPath: container.codingPath + [CodingKeys.type],
                    debugDescription: "Unknown parent type: \(type)"
                )
            throw DecodingError
                .typeMismatch(BlockType.CommentBlockValue.Parent.self, context)
            
        }
        
    }

    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .database(let id):
            try container.encode(CodingKeys.databaseId.rawValue, forKey: .type)
            try container.encode(id, forKey: .databaseId)
        case .dataSource(let id, let databaseId):
            try container.encode(CodingKeys.dataSourceId.rawValue, forKey: .type)
            try container.encode(id, forKey: .dataSourceId)
            try container.encode(databaseId, forKey: .databaseId)
        case .page(let id):
            try container.encode(CodingKeys.pageId.rawValue, forKey: .type)
            try container.encode(id, forKey: .pageId)
        case .workspace:
            try container.encode(CodingKeys.workspace.rawValue, forKey: .type)
            try container.encode(true, forKey: .workspace)

        }
        
    }
    
}

extension BlockType.CommentBlockValue.Parent: Equatable {}
extension BlockType.CommentBlockValue.Parent: Sendable {}

//
//  Created by Wojciech Chojnacki on 03/06/2021.
//

import Foundation

public struct PageUpdateRequest: Sendable {
    public enum Key: Hashable, Equatable, Sendable  {
        case name(Page.PropertyName)
        case id(PageProperty.Identifier)
    }

    public let properties: [Key: WritePageProperty]?
    public let archived: Bool?
    public let icon: IconFile?
    public let cover: CoverFile?
    public let eraseContent: Bool?
    public let isLocked: Bool?

    public init(
        properties: [Key: WritePageProperty]? = nil,
        archived: Bool? = nil,
        icon: IconFile? = nil,
        cover: CoverFile? = nil,
        eraseContent: Bool? = nil,
        isLocked: Bool? = nil
    ) {
        self.properties = properties
        self.archived = archived
        self.icon = icon
        self.cover = cover
        self.eraseContent = eraseContent
        self.isLocked = isLocked
    }

}

extension PageUpdateRequest: Encodable {
    enum CodingKeys: String, CodingKey {
        case properties
        case archived
        case icon
        case cover
        case eraseContent = "erase_content"
        case isLocked = "is_locked"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let properties = self.properties {
            // default encoder wasn't happy with out properties type and was converting it to an array.
            let entries: [(String, WritePageProperty)] = properties.map { entry in
                let key: String
                switch entry.0 {
                case .name(let value):
                    key = value
                case .id(let value):
                    key = value.rawValue
                }
                return (key, entry.1)
            }
            
            let properties = Dictionary(uniqueKeysWithValues: entries)
            try container.encode(properties, forKey: .properties)
        }
        try container.encodeIfPresent(archived, forKey: .archived)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encodeIfPresent(cover, forKey: .cover)
        try container.encodeIfPresent(eraseContent, forKey: .eraseContent)
        try container.encodeIfPresent(isLocked, forKey: .isLocked)
    }
}

extension PageUpdateRequest.Key: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .name(let value):
            try container.encode(value)
        case .id(let value):
            try container.encode(value)
        }
    }
}

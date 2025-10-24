import Foundation
import NotionSwift
import Testing

struct ReadBlockTests {
    
    func endToEndCodable() throws {
        
        let partialUser = PartialUser(id: .init(UUID().uuidString))
        
        let base = ReadBlock(
            id: .init(UUID().uuidString),
            archived: .random(),
            type: .divider,
            createdTime: .distantPast,
            lastEditedTime: .now,
            hasChildren: false,
            createdBy: partialUser,
            lastEditedBy: partialUser
        )
        
        let encoded = try encodeToJson(base)
        let decoded: ReadBlock = try decodeFromJson(encoded)
        
        #expect(decoded == base)
        
    }
    
    @Test func updateChildrenSetsHasChildren() throws {
        
        let partialUser = PartialUser(id: .init(UUID().uuidString))
        let base = ReadBlock(
            id: .init(UUID().uuidString),
            archived: .random(),
            type: .divider,
            createdTime: .distantPast,
            lastEditedTime: .now,
            hasChildren: false,
            createdBy: partialUser,
            lastEditedBy: partialUser
        )
        
        let child = ReadBlock(
            id: .init(UUID().uuidString),
            archived: .random(),
            type: .divider,
            createdTime: .distantPast,
            lastEditedTime: .now,
            hasChildren: false,
            createdBy: partialUser,
            lastEditedBy: partialUser
        )
        
        try #require(base.hasChildren == false)
        try #require(base.children.isEmpty)
        try #require(child.hasChildren == false)
        try #require(child.children.isEmpty)
        
        let result = base.updateChildren([child])
        
        #expect(result.hasChildren)
        #expect(result.children == [child])
        
        let childResult = try #require(result.children.first)
        
        #expect(childResult.hasChildren == false)
        #expect(childResult.children.isEmpty)
        
    }
    
    @Test func descriptionSkipsChildrenCountWithZero() {
        
        let partialUser = PartialUser(id: .init(UUID().uuidString))
        let base = ReadBlock(
            id: .init(UUID().uuidString),
            archived: .random(),
            type: .divider,
            createdTime: .distantPast,
            lastEditedTime: .now,
            hasChildren: false,
            createdBy: partialUser,
            lastEditedBy: partialUser
        )
        
        let result = base.description
        
        #expect(result.contains("Children") == false)
        #expect(result.last != ",")
        
    }
    
    @Test func descriptionContainsChildrenCount() {
        
        let partialUser = PartialUser(id: .init(UUID().uuidString))
        let base = ReadBlock(
            id: .init(UUID().uuidString),
            archived: .random(),
            type: .divider,
            createdTime: .distantPast,
            lastEditedTime: .now,
            hasChildren: false,
            createdBy: partialUser,
            lastEditedBy: partialUser
        )
        
        let child = ReadBlock(
            id: .init(UUID().uuidString),
            archived: .random(),
            type: .divider,
            createdTime: .distantPast,
            lastEditedTime: .now,
            hasChildren: false,
            createdBy: partialUser,
            lastEditedBy: partialUser
        )
        
        let result = base
            .updateChildren([child])
            .description
        
        #expect(result.contains("Children:1"))
        #expect(result.last != ",")
        
    }
    
}

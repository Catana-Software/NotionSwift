import Foundation
import NotionSwift
import Testing

struct ReadBlockTests {
    
    @Test(.disabled("Disabled until coding conflict can be resolved"))
    func endToEndCodable() throws {
        
        let partialUser = PartialUser(id: .init(UUID().uuidString))
        
        // This `.divider` type will throw a decoding type mismatch error
        
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
        
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(base)
        let decoded = try JSONDecoder().decode(ReadBlock.self, from: encoded)
        
        #expect(decoded == base)
        
    }
    
}

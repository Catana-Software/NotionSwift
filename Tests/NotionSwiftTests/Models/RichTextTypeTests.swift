import Foundation
import NotionSwift
import Testing

struct RichTextTypeTests {
    
    @Test
    func unknownEndToEndCodable() throws {
        
        let base = RichTextType.unknown
        
        let encoded = try encodeToJson(base)
        let decoded: RichTextType = try decodeFromJson(encoded)
        
        #expect(decoded == base)
        
    }
    
}

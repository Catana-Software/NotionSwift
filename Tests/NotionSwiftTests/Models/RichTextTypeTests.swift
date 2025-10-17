import Foundation
import NotionSwift
import Testing

struct RichTextTypeTests {
    
    @Test(.disabled("Unable to end to end test currently"))
    func unknownEndToEndCodable() throws {
        
        let base = RichTextType.unknown
        
        let encoded = try encodeToJson(base)
        let decoded: RichTextType = try decodeFromJson(encoded)
        
        #expect(decoded == base)
        
    }
    
}

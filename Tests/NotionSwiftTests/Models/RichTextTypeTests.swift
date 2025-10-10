import Foundation
import NotionSwift
import Testing

struct RichTextTypeTests {
    
    @Test(.disabled("Unable to end to end test currently"))
    func unknownEndToEndCodable() throws {
        
        let base = RichTextType.unknown
        
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(base)
        let decoded = try JSONDecoder().decode(RichTextType.self, from: encoded)
        
        #expect(decoded == base)
        
    }
    
}

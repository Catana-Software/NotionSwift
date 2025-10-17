import Foundation
import NotionSwift
import Testing

struct Comment_DisplayNameTests {
    
    private typealias DisplayName = NotionSwift.Comment.DisplayName
    
    /// Sample JSON from https://developers.notion.com/reference/retrieve-comment
    /// relating to the response from comment API's
    @Test func decodesSampleResponse() throws {
        
        let name = "n!me"
        let json = """
        {
            "type": "integration",
            "resolved_name": "\(name)"
        }
        """
        
        let value: DisplayName = try decodeFromJson(json)
        
        switch value {
        case .integration(resolvedName: let resolvedName):
            #expect(resolvedName == name)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: DisplayName = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesCustomCase() throws {
        
        let name = "Integration X"
        let json = """
        {
            "type": "custom",
            "resolved_name": "\(name)"
        }
        """
        
        let value: DisplayName = try decodeFromJson(json)
        
        switch value {
        case .custom(resolvedName: let resolvedName):
            #expect(resolvedName == name)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: DisplayName = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }

    @Test func decodesUserCase() throws {
        
        let name = "Alice"
        let json = """
        {
            "type": "user",
            "resolved_name": "\(name)"
        }
        """
        
        let value: DisplayName = try decodeFromJson(json)
        
        switch value {
        case .user(resolvedName: let resolvedName):
            #expect(resolvedName == name)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: DisplayName = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
}

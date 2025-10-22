import Foundation
import NotionSwift
import Testing

struct Comment_DisplayNameRequestTests {
    
    private typealias DisplayName = NotionSwift.Comment.DisplayNameRequest
    
    /// Sample JSON from https://developers.notion.com/reference/comment-display-name
    /// relating to the request for calling comment API's
    ///
    /// The create comment API reference uses an example object that does not comply
    /// with the spec on the page at https://developers.notion.com/reference/create-a-comment
    /// in that it does not contain a name field, which is listed as the custom name
    @Test func decodesSampleRequest() throws {
        
        let name = "Notion Bot"
        
        let json = """
        {
            "type": "custom",
            "custom": {
                "name": "\(name)"
            }
        }
        """
        
        let value: DisplayName = try decodeFromJson(json)
        
        switch value {
        case .custom(name: let decodedName):
            #expect(decodedName == name)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: DisplayName = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesUserCase() throws {
        
        let json = """
        {
            "type": "user"
        }
        """
        
        let value: DisplayName = try decodeFromJson(json)
        
        switch value {
        case .user:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: DisplayName = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesIntegrationCase() throws {
        
        let json = """
        {
            "type": "integration"
        }
        """
        
        let value: DisplayName = try decodeFromJson(json)
        
        switch value {
        case .integration:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: DisplayName = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
}

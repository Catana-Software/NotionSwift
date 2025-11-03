@testable import NotionSwift
import Foundation
import Testing

struct URLBuilderTests {
 
    let params: [String: String] = ["key": "value"]
    
    let expectedQuery = "key=value"
    
    @Test func properlyFormsPageID() {
        
        let builder = URLBuilder()
        
        let uuid = Page.Identifier(UUIDv4())
        
        let result = builder
            .url(
                path: "/v1/comments/{identifier}",
                identifier: uuid,
                params: params
            )
        
        #expect(result.path().contains("comments"))
        #expect(result.path().contains(uuid.rawValue.uuidString.lowercased()))
        
        #expect(result.query() == expectedQuery)
        
    }
    
    @Test func properlyFormsBlockID() {
        
        let builder = URLBuilder()
        
        let uuid = Block.Identifier(UUIDv4())
        
        let result = builder
            .url(
                path: "/v1/comments/{identifier}",
                identifier: uuid,
                params: params
            )
        
        #expect(result.path().contains("comments"))
        #expect(result.path().contains(uuid.rawValue.uuidString.lowercased()))
        
        #expect(result.query() == expectedQuery)
        
    }
    
    @Test func properlyFormsUUIDv4ID() {
        
        let builder = URLBuilder()
        
        let uuid = UUIDv4()
        
        let result = builder
            .url(
                path: "/v1/comments/{identifier}",
                identifier: uuid,
                params: params
            )
        
        #expect(result.path().contains("comments"))
        #expect(result.path().contains(uuid.uuidString.lowercased()))
        
        #expect(result.query() == expectedQuery)
        
    }
    
    @Test func docsCommentsURLExample() {
        
        let uuid = UUIDv4()
        
        var combinedParams = BaseQueryParams().asParams
        combinedParams["block_id"] = uuid.uuidString.lowercased()
        
        let result = URLBuilder()
            .url(
                path: "/v1/comments",
                identifier: uuid,
                params: combinedParams
            )
        
        let expected = "https://api.notion.com/v1/comments?block_id=\(uuid.uuidString.lowercased())"
        
        #expect(result.absoluteString == expected)
        
    }
    
}

import Foundation
@testable import NotionSwift
import Testing

struct URLBuilderTests {
 
    let params: [String: String] = ["key": "value"]
    
    let expectedQuery = "key=value"
    
    @Test func properlyFormsPageID() {
        
        let builder = URLBuilder()
        
        let uuid = Page.Identifier(UUID().uuidString)
        
        let result = builder
            .url(
                path: "/v1/comments/{identifier}",
                identifier: uuid,
                params: params
            )
        
        #expect(result.path().contains("comments"))
        #expect(result.path().contains(uuid.rawValue))
        
        #expect(result.query() == expectedQuery)
        
    }
    
    @Test func properlyFormsBlockID() {
        
        let builder = URLBuilder()
        
        let uuid = Block.Identifier(UUID().uuidString)
        
        let result = builder
            .url(
                path: "/v1/comments/{identifier}",
                identifier: uuid,
                params: params
            )
        
        #expect(result.path().contains("comments"))
        #expect(result.path().contains(uuid.rawValue))
        
        #expect(result.query() == expectedQuery)
        
    }
    
    @Test func properlyFormsUUIDv4ID() {
        
        let builder = URLBuilder()
        
        let uuid = UUID().uuidString
        
        let result = builder
            .url(
                path: "/v1/comments/{identifier}",
                identifier: uuid,
                params: params
            )
        
        #expect(result.path().contains("comments"))
        #expect(result.path().contains(uuid))
        
        #expect(result.query() == expectedQuery)
        
    }
    
}

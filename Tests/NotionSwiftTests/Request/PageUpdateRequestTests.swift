import Foundation
import NotionSwift
import Testing

@Suite("PageUpdateRequest")
struct PageUpdateRequestTests {
    
    @Test func encodedValueDefaultExcludesEraseContent() throws {
        
        let request = PageUpdateRequest()
        
        let data = try JSONEncoder().encode(request)
        let string = try #require(String(data: data, encoding: .utf8))
        
        #expect(!string.contains("erase_content"))
        
    }
    
    @Test func encodedValueIncludesEraseContentProp() throws {
        
        let values = [true, false]
        
        for value in values {
            
            let request = PageUpdateRequest(eraseContent: value)
            
            let data = try JSONEncoder().encode(request)
            let string = try #require(String(data: data, encoding: .utf8))
            
            #expect(string.contains("erase_content"))
            #expect(string.contains("\(value)"))
            
        }
        
    }
    
    @Test func encodedValueDefaultExcludesIsLocked() throws {
        
        let request = PageUpdateRequest()
        
        let data = try JSONEncoder().encode(request)
        let string = try #require(String(data: data, encoding: .utf8))
        
        #expect(!string.contains("is_locked"))
        
    }
    
    @Test func encodedValueIncludesIsLockedProp() throws {
        
        let values = [true, false]
        
        for value in values {
            
            let request = PageUpdateRequest(isLocked: value)
            
            let data = try JSONEncoder().encode(request)
            let string = try #require(String(data: data, encoding: .utf8))
            
            #expect(string.contains("is_locked"))
            #expect(string.contains("\(value)"))
            
        }
        
    }
    
}

import Foundation
import NotionSwift
import Testing

@Suite("EntityIdentifier")
struct EntityIdentifierTests {
    
    @Test func pageEncodesAndRoundTrips() throws {
        
        let uuid = UUID()
        let lowercasedUUID = uuid.uuidString.lowercased()
        let identifier: Page.Identifier = .init(uuid)
        
        let encoded = try JSONEncoder().encode(identifier)
        let string = try #require(String(data: encoded, encoding: .utf8))
        #expect(string == "\"\(lowercasedUUID)\"")
        
        let decoded = try JSONDecoder().decode(Page.Identifier.self, from: encoded)
        #expect(decoded == identifier)
        
    }
    
    @Test func blockEncodesAndRoundTrips() throws {
        
        let uuid = UUID()
        let lowercasedUUID = uuid.uuidString.lowercased()
        let identifier: Block.Identifier = .init(uuid)
        
        let encoded = try JSONEncoder().encode(identifier)
        let string = try #require(String(data: encoded, encoding: .utf8))
        #expect(string == "\"\(lowercasedUUID)\"")
        
        let decoded = try JSONDecoder().decode(Block.Identifier.self, from: encoded)
        #expect(decoded == identifier)
        
    }
    
    @Test func stringValueRespectsCase() throws {
        
        let value = "ThIsIsThIdenTifier"
        
        let identifier: EntityIdentifier<String, String> = .init(value)
        
        let encoded = try JSONEncoder().encode(identifier)
        let string = try #require(String(data: encoded, encoding: .utf8))
        #expect(string == "\"\(value)\"")
        
        let decoded = try JSONDecoder()
            .decode(EntityIdentifier<String, String>.self, from: encoded)
        #expect(decoded == identifier)
        
        #expect(identifier.description.contains(value))
        
    }
    
    @Test func blockInitEncodesLowercased() throws {
        
        let identifier: Block.Identifier = .init()
        
        let encoded = try JSONEncoder().encode(identifier)
        let string = try #require(String(data: encoded, encoding: .utf8))
        
        #expect(string == string.lowercased())
        
    }
    
    @Test func pageInitEncodesLowercased() throws {
        
        let identifier: Page.Identifier = .init()
        
        let encoded = try JSONEncoder().encode(identifier)
        let string = try #require(String(data: encoded, encoding: .utf8))
        
        #expect(string == string.lowercased())
        
    }
    
    @Test func descriptionFromUUIDLowercased() {
        
        let uuid = UUID()
        let identifier: Page.Identifier = .init(uuid)
        
        #expect(identifier.description.contains(uuid.uuidString.lowercased()))
        
    }
    
    @Test func decodesFromUppercaseEncodedJSON() throws {
        
        let id = UUID()
        let value = id.uuidString
        let identifier: EntityIdentifier<String, String> = .init(value)
        
        let encoded = try JSONEncoder()
            .encode(identifier)
        
        let decoded = try JSONDecoder()
            .decode(EntityIdentifier<String, UUID>.self, from: encoded)
        
        #expect(decoded.rawValue == id)
        
    }
    
}

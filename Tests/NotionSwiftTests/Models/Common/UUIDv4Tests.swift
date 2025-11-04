import Foundation
import NotionSwift
import Testing

@Suite("UUIDv4")
struct UUIDv4Tests {
    
    private struct Box: Codable, Equatable {
        let id: UUIDv4
    }
    
    @Test func initWithInvalidReturnsNil() {
        
        #expect(UUIDv4(uuidString: "Not a uuid") == nil)
        
    }
    
    @Test func equatable() throws {
    
        let raw = UUID().uuidString
        let a = try #require(UUIDv4(uuidString: raw))
        let b = try #require(UUIDv4(uuidString: raw))
        #expect(a == b)

        let c = try #require(UUIDv4(uuidString: UUID().uuidString))
        #expect(a != c)

    }

    @Test func hashable() throws {
        
        let raw = UUID().uuidString
        let a = try #require(UUIDv4(uuidString: raw))
        let b = try #require(UUIDv4(uuidString: raw))
        #expect(a.hashValue == b.hashValue)

        var set: Set<UUIDv4> = []
        set.insert(a)
        set.insert(b) // should not add a second element
        #expect(set.count == 1)

        let c = try #require(UUIDv4(uuidString: UUID().uuidString))
        set.insert(c)
        
        #expect(set.count == 2)
        
    }

    @Test func hashableDictionaryKey() throws {
        
        let raw1 = UUID().uuidString
        let raw2 = UUID().uuidString
        let k1a = try #require(UUIDv4(uuidString: raw1))
        let k1b = try #require(UUIDv4(uuidString: raw1))
        let k2 = try #require(UUIDv4(uuidString: raw2))

        var dict: [UUIDv4: String] = [:]
        dict[k1a] = "first"
        // Writing with an equal key should overwrite
        dict[k1b] = "first-updated"
        dict[k2] = "second"

        #expect(dict.count == 2)
        #expect(dict[k1a] == "first-updated")
        #expect(dict[k1b] == "first-updated")
        #expect(dict[k2] == "second")
        
    }

    @Test func codableRoundTrip() throws {
        
        let raw = UUID().uuidString
        let id = try #require(UUIDv4(uuidString: raw))
        let box = Box(id: id)

        let data = try JSONEncoder().encode(box)
        let decoded = try JSONDecoder().decode(Box.self, from: data)

        #expect(decoded == box)
        #expect(decoded.id == id)
        
    }
    
    @Test func codableCaseVariantDecoding() throws {
        
        let uuid = UUID()
        
        let payloadString = "{" +
        "\"id\":\"\(uuid.uuidString)\"" +
        "}"
        
        let payload = payloadString.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(Box.self, from: payload)
        let canonical = try #require(UUIDv4(uuidString: uuid.uuidString.lowercased()))
        
        #expect(decoded.id == canonical)
        
    }

    @Test func caseInsensitivityEquality() throws {
        
        let lower = try #require(UUIDv4(uuidString: "123e4567-e89b-12d3-a456-426614174000"))
        let upper = try #require(UUIDv4(uuidString: "123E4567-E89B-12D3-A456-426614174000"))
        let mixed = try #require(UUIDv4(uuidString: "123E4567-e89B-12d3-a456-426614174000"))

        #expect(lower == upper)
        #expect(upper == mixed)

        let different = try #require(UUIDv4(uuidString: UUID().uuidString))
        #expect(lower != different)
        
    }

    @Test func caseInsensitivityHashing() throws {
        
        let lower = try #require(UUIDv4(uuidString: "123e4567-e89b-12d3-a456-426614174000"))
        let upper = try #require(UUIDv4(uuidString: "123E4567-E89B-12D3-A456-426614174000"))
        
        #expect(lower == upper)
        #expect(lower.hashValue == upper.hashValue)
        
        var set: Set<UUIDv4> = []
        set.insert(lower)
        set.insert(upper)
        
        #expect(set.count == 1)
        
    }
    
}

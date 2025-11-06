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
    
    @Test func noneV4UUIDReturnsNil() {
        
        let invalids = [
            "1893D87F-1339-38D6-B451-4F5FBE228567", // Invalid Version
            "6EF71350-BD0B-499D-0C4B-FE1EC2FE9C2C", // Invalid y
            "AA7F9B0D-3200-49B6-1B30-A80B9476DE13", // Invalid both
        ]
        
        for invalid in invalids {
            
            #expect(UUIDv4(uuidString: invalid) == nil)
            
        }
        
    }
    
    @Test func uuidStringFromUUID() {
        
        let uuid = UUID()
        
        let uuidv4 = UUIDv4(uuidString: uuid.uuidString)
        
        #expect(uuidv4?.uuidString == uuid.uuidString.lowercased())
        
    }
    
    @Test func initValuePreservedWithCanonicalLowercase() {
        
        let uuid = UUID()
        
        let v4 = UUIDv4(uuid: uuid)
        
        #expect(v4.uuidString == uuid.uuidString.lowercased())
        
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
    
    @Test func codableMissingVersion4NibbleThrows() {
        
        let uuid = UUID().uuidString.replacingOccurrences(of: "4", with: "1")
        
        let payloadString = "{" +
        "\"id\":\"\(uuid)\"" +
        "}"
        
        let payload = payloadString.data(using: .utf8)!
        
        #expect(throws: DecodingError.self) {
            
            let _ = try JSONDecoder().decode(Box.self, from: payload)
            
        }
        
    }
    
    @Test func codableMissingVersion4YThrows() {
        
        let uuid = "123e4567-e89b-42d3-1456-426614174000"
        
        let payloadString = "{" +
            "\"id\":\"\(uuid)\"" +
            "}"
        
        let payload = payloadString.data(using: .utf8)!
        
        #expect(throws: DecodingError.self) {
            
            let _ = try JSONDecoder().decode(Box.self, from: payload)
            
        }
        
    }
    
    @Test func codableCaseInsensitive() throws {
        
        let make: (String) -> Data = { uuidString in
            return (
                "{" +
                "\"id\":\"\(uuidString)\"" +
                "}"
            )
            .data(using: .utf8)!
        }
        
        let tests = [
            UUID().uuidString.lowercased(),
            UUID().uuidString.uppercased()
        ]
        
        for test in tests {
            
            let data = make(test)
            
            let decoded = try JSONDecoder().decode(Box.self, from: data)
            
            #expect(decoded.id.uuidString == test.lowercased())
            
        }
        
    }
    
    @Test func codableThrowsOnCompact() throws {
        
        let make: (String) -> Data = { uuidString in
            return (
                "{" +
                "\"id\":\"\(uuidString.replacingOccurrences(of: "-", with: ""))\"" +
                "}"
            )
            .data(using: .utf8)!
        }
        
        let tests = [
            UUID().uuidString.lowercased(),
            UUID().uuidString.uppercased()
        ]
        
        for test in tests {
            
            let data = make(test)
            
            #expect(throws: DecodingError.self) {
                
                let _ = try JSONDecoder().decode(Box.self, from: data)
                
            }
            
        }
        
    }
    
    @Test func caseInsensitivityEquality() throws {
        
        let lower = try #require(UUIDv4(uuidString: "123e4567-e89b-42d3-8456-426614174000"))
        let upper = try #require(UUIDv4(uuidString: "123E4567-E89B-42D3-8456-426614174000"))
        let mixed = try #require(UUIDv4(uuidString: "123E4567-e89B-42d3-8456-426614174000"))

        #expect(lower == upper)
        #expect(upper == mixed)

        let different = try #require(UUIDv4(uuidString: UUID().uuidString))
        #expect(lower != different)
        
    }

    @Test func caseInsensitivityHashing() throws {
        
        let lower = try #require(UUIDv4(uuidString: "123e4567-e89b-42d3-8456-426614174000"))
        let upper = try #require(UUIDv4(uuidString: "123E4567-E89B-42D3-8456-426614174000"))
        
        #expect(lower == upper)
        #expect(lower.hashValue == upper.hashValue)
        
        var set: Set<UUIDv4> = []
        set.insert(lower)
        set.insert(upper)
        
        #expect(set.count == 1)
        
    }
    
}

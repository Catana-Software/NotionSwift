import Foundation
import NotionSwift
import Testing

struct User_PersonTests {
    
    @Test func nilEmailCodable() throws {
        
        let person = User.Person(email: nil)
        
        let encoded = try encodeToJson(person)
        let decoded: User.Person = try decodeFromJson(encoded)
        
        #expect(person == decoded)
        
    }
    
    @Test func emailCodable() throws {
        
        let person = User.Person(email: "example@example.com")
        
        let encoded = try encodeToJson(person)
        let decoded: User.Person = try decodeFromJson(encoded)
        
        #expect(person == decoded)
        
    }
    
    @Test func equality() throws {
        
        let a = User.Person(email: nil)
        let b = User.Person(email: nil)
        let c = User.Person(email: "example@example.com")
        let d = User.Person(email: "example@example.com")
        
        #expect(a == b)
        #expect(b != c)
        #expect(c == d)
        
    }
    
}

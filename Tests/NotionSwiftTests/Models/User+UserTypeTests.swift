import Foundation
import NotionSwift
import Testing

struct User_UserTypeTests {
    
    @Test func equality() throws {
        
        let a = User.Person(email: nil)
        let b = User.Person(email: "example@example.com")
        
        let typeA = User.UserType.person(a)
        let typeB = User.UserType.person(b)
        let typeC = User.UserType.person(b)
        
        #expect(typeA != typeB)
        #expect(typeB == typeC)
        
    }
    
}

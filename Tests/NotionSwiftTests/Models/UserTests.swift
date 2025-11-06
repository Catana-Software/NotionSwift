import Foundation
import NotionSwift
import Testing

struct UserTests {
    
    @Test func personCodable() throws {
        
        let user = User(
            id: .init(LowercaseUUID()),
            type: .person(.init(email: "example@example.com")),
            name: "Username",
            avatarURL: URL.temporaryDirectory.path()
        )
        
        let encoded = try encodeToJson(user)
        let decoded: User = try decodeFromJson(encoded)
        
        #expect(user == decoded)
        
    }
    
    @Test func personEquality() throws {
        
        let base = User(
            id: .init(LowercaseUUID()),
            type: .person(.init(email: "example@example.com")),
            name: "Username",
            avatarURL: URL.temporaryDirectory.path()
        )
        
        let users = [
            base.updated(id: .init(LowercaseUUID())),
            base.updated(type: .bot(User.Bot())),
            base.updated(name: "Another name"),
            base.updated(avatarURL: URL.temporaryDirectory.appendingPathComponent("dir").path())
        ]
        
        for user in users {
            
            #expect(user != base)
            
        }
        
    }
    
    @Test func botCodable() throws {
        
        let bot = User.Bot()
        
        let user = User(
            id: .init(LowercaseUUID()),
            type: .bot(bot),
            name: "Botname",
            avatarURL: URL.temporaryDirectory.path()
        )
        
        let encoded = try JSONEncoder().encode(user)
        let decoded = try JSONDecoder().decode(User.self, from: encoded)
        
        #expect(user == decoded)
        
    }
    
    // TODO: Determine the use case for this as it is not present in docs
    @Test(.disabled())
    func unknownCodable() throws {
        
        let user = User(
            id: .init(LowercaseUUID()),
            type: .unknown,
            name: "A name",
            avatarURL: URL.temporaryDirectory.path()
        )
        
        let encoded = try encodeToJson(user)
        let decoded: User = try decodeFromJson(encoded)
        
        #expect(user == decoded)
        
    }
    
}

extension User {
    
    /// Returns a new `User` by copying the receiver and overriding any provided properties.
    ///
    /// - Parameters:
    ///   - id: Optional new identifier. If `nil`, the current `id` is retained.
    ///   - type: Optional new user type (e.g., person or bot). If `nil`, the current
    ///     `type` is retained.
    ///   - name: Optional new display name. If `nil`, the current `name` is retained.
    ///   - avatarURL: Optional new avatar URL string. If `nil`, the current `avatarURL`
    ///     is retained.
    ///
    /// - Returns: A new `User` with the specified overrides applied.
    func updated(
        id: User.Identifier? = nil,
        type: User.UserType? = nil,
        name: String? = nil,
        avatarURL: String? = nil
    ) -> User {
     
        return User(
            id: id ?? self.id,
            type: type ?? self.type,
            name: name ?? self.name,
            avatarURL: avatarURL ?? self.avatarURL
        )
        
    }
    
}

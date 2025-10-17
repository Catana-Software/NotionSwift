import Foundation
import NotionSwift
import Testing

struct Comment_ParentTests {
    
    private typealias Parent = NotionSwift.Comment.Parent
    
    /// Sample JSON from https://developers.notion.com/reference/parent-object
    @Test func decodesDatabaseSampleResponse() throws {
        
        let databaseID = "d9824bdc-8445-4327-be8b-5b47500af6ce"
        
        let json = """
        {
          "type": "database_id",
          "database_id": "\(databaseID)"
        }
        """
        
        let value: Parent = try decodeFromJson(json)
        
        switch value {
        case .database(let id):
            #expect(id == databaseID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: Parent = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesDatasourceSampleResponse() throws {
        
        let datasourceID = "1a44be12-0953-4631-b498-9e5817518db8"
        let databaseID = "d9824bdc-8445-4327-be8b-5b47500af6ce"
        
        let json = """
        {
          "type": "data_source_id",
          "data_source_id": "\(datasourceID)",
          "database_id": "\(databaseID)"
        }
        """
        
        let value: Parent = try decodeFromJson(json)
        
        switch value {
        case .dataSource(let ds, let db):
            #expect(ds == datasourceID)
            #expect(db == databaseID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: Parent = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesPageSampleResponse() throws {
        
        let pageID = "59833787-2cf9-4fdf-8782-e53db20768a5"
        
        let json = """
        {
          "type": "page_id",
          "page_id": "\(pageID)"
        }
        """
        
        let value: Parent = try decodeFromJson(json)
        
        switch value {
        case .page(let id):
            #expect(id == pageID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: Parent = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesWorkspaceSampleResponse() throws {
        
        let json = """
        {
          "type": "workspace",
          "workspace": true
        }
        """
        
        let value: Parent = try decodeFromJson(json)
        
        switch value {
        case .workspace:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: Parent = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesBlockIDSampleResponse() throws {
        
        let blockID = "7d50a184-5bbe-4d90-8f29-6bec57ed817b"
        
        let json = """
        {
          "type": "block_id",
          "block_id": "\(blockID)"
        }
        """
        
        let value: Parent = try decodeFromJson(json)
        
        switch value {
        case .block(let id):
            #expect(id == blockID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try encodeToJson(value)
        let decoded: Parent = try decodeFromJson(encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodingUnknownTypeThrowsTypeMismatch() throws {
        
        let unknownType = "unknown_type"
        
        let json = """
        {
          "type": "\(unknownType)",
          "workspace": true
        }
        """
        
        #expect(throws: Error.self) {
            let _: Parent = try decodeFromJson(json)
        }
        
        var thrown: Error?
        do {
            
            let _: Parent = try decodeFromJson(json)
            
        } catch {
            
            thrown = error
            
        }
        
        guard
            case DecodingError.typeMismatch(_, let context)? = thrown
        else {
            #expect(Bool(false), "Expected DecodingError.typeMismatch, got \(String(describing: thrown))")
            return
        }
        
        #expect(context.debugDescription.contains("Unknown parent type"))
        #expect(context.debugDescription.contains("unknown_type"))
        
    }
    
}

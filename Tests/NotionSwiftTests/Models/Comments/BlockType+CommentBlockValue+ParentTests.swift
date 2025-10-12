import Foundation
import NotionSwift
import Testing

struct BlockType_CommentBlockValue_ParentTests {
    
    /// Sample JSON from hhttps://developers.notion.com/reference/parent-object
    @Test func decodesDatabaseSampleResponse() throws {
        
        let databaseID = "d9824bdc-8445-4327-be8b-5b47500af6ce"
        
        let json = """
        {
          "type": "database_id",
          "database_id": "\(databaseID)"
        }
        """
        
        let data = Data(json.utf8)
        let value = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: data)
        
        switch value {
        case .database(let id):
            #expect(id == databaseID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: encoded)
        
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
        
        let data = Data(json.utf8)
        let value = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: data)
        
        switch value {
        case .dataSource(let ds, let db):
            #expect(ds == datasourceID)
            #expect(db == databaseID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: encoded)
        
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
        
        let data = Data(json.utf8)
        let value = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: data)
        
        switch value {
        case .page(let id):
            #expect(id == pageID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: encoded)
        
        #expect(decoded == value)
        
    }
    
    @Test func decodesWorkspaceSampleResponse() throws {
        
        let json = """
        {
          "type": "workspace",
          "workspace": true
        }
        """
        
        let data = Data(json.utf8)
        let value = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: data)
        
        switch value {
        case .workspace:
            #expect(true)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: encoded)
        
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
        
        let data = Data(json.utf8)
        let value = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: data)
        
        switch value {
        case .block(let id):
            #expect(id == blockID)
        default:
            #expect(Bool(false))
        }
        
        let encoded = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder()
            .decode(BlockType.CommentBlockValue.Parent.self, from: encoded)
        
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
        
        let data = Data(json.utf8)
        
        #expect(throws: Error.self) {
            _ = try JSONDecoder().decode(BlockType.CommentBlockValue.Parent.self, from: data)
        }
        
        var thrown: Error?
        do {
            
            _ = try JSONDecoder().decode(BlockType.CommentBlockValue.Parent.self, from: data)
            
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

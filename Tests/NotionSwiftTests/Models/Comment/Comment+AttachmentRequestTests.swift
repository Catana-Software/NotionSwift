import Foundation
import NotionSwift
import Testing

struct Comment_AttachmentRequestTests {
    
    private typealias AttachmentRequest = NotionSwift.Comment.AttachmentRequest
    
    /// This sample is taken from the docs at
    /// https://developers.notion.com/reference/comment-attachment
    @Test func decodesDocsSampleRequest() throws {
        
        let id = try #require(UUIDv4(uuidString: "2e2cdb8b-9897-4a6c-a935-82922b1cfb87"))
        
        let json = """
        {
            "file_upload_id": "\(id.uuidString)"
        }
        """
        
        let value: AttachmentRequest = try decodeFromJson(json)
        
        let encoded = try encodeToJson(value)
        
        let decoded: AttachmentRequest = try decodeFromJson(encoded)
        
        #expect(decoded.fileUploadID == id)
        #expect(decoded == value)
        
    }
    
    @Test func decodesModifiedDocsSampleWithTypeString() throws {
        
        let id = try #require(UUIDv4(uuidString: "2e2cdb8b-9897-4a6c-a935-82922b1cfb87"))
        let type = "file_upload"
        
        let json = """
        {
            "file_upload_id": "\(id.uuidString)",
            "type": "\(type)"
        }
        """
        
        let value: AttachmentRequest = try decodeFromJson(json)
        
        let encoded = try encodeToJson(value)
        
        let decoded: AttachmentRequest = try decodeFromJson(encoded)
        
        #expect(decoded.fileUploadID == id)
        #expect(decoded.type == type)
        #expect(decoded == value)
        
    }
    
}

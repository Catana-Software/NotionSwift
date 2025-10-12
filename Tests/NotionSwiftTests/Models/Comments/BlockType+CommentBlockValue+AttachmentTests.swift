import Foundation
import NotionSwift
import Testing

struct BlockType_CommentBlockValue_AttachmentTests {
    
    /// This sample is taken from the docs at
    /// https://developers.notion.com/reference/comment-attachment
    ///
    /// However the sample provided for this 'file' property does
    /// not comply with the spec for a file object, which has a 'type' property that is
    /// not present and will therefore throw. Instead it appears the docs are referring
    /// to what is implemented in this project as a `_FileLink`. Unfortunately that is not
    /// explicit in the docs, which instead directs to a `FileFile` (file object at
    /// https://developers.notion.com/reference/file-object#notion-hosted-files-type-file
    ///
    /// If the response is limited to a file type file, then this implementation is compliant
    /// with the spec. This note exists to draw future attention to this remaining ambigutity
    @Test func decodesDocsSampleResponse() throws {
        
        let json = """
        {
          "category": "video",
          "file": {
            "url": "https://s3.us-west-2.amazonaws.com/...",
            "expiry_time": "2025-06-10T21:26:03.070Z"
          }
        }
        """
        
        let data = Data(json.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        
        let value = try decoder
            .decode(BlockType.CommentBlockValue.Attachment.self, from: data)
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(.iso8601Full)
        
        let encoded = try encoder
            .encode(value)
        
        let decoded = try decoder
            .decode(BlockType.CommentBlockValue.Attachment.self, from: encoded)
        
        #expect(decoded == value)
        
    }
    
}

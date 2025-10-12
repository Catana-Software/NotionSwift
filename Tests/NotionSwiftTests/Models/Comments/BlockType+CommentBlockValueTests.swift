import Foundation
import NotionSwift
import Testing

struct BlockType_CommentBlockValueTests {
    
    /// Sample JSON from https://developers.notion.com/reference/comment-object
    @Test func decodesSampleResponse() throws {
        
        let id = "7a793800-3e55-4d5e-8009-2261de026179"
        
        let parent = """
          {
           "type": "page_id",
           "page_id": "5c6a2821-6bb1-4a7e-b6e1-c50111515c3d"
          }
        """
        
        let discussionID = "f4be6752-a539-4da2-a8a9-c3953e13bc0b"
        
        let createdTime = "2022-07-15T21:17:00.000Z"
        
        let lastEditedTime = "2022-07-15T21:17:00.000Z"
        
        let createdBy = """
          {
            "object": "user",
            "id": "e450a39e-9051-4d36-bc4e-8581611fc592"
          }
        """
        
        let richText = """
        [
          {
            "type": "text",
            "text": {
              "content": "Hello world",
              "link": null
            },
            "annotations": {
              "bold": false,
              "italic": false,
              "strikethrough": false,
              "underline": false,
              "code": false,
              "color": "default"
            },
            "plain_text": "Hello world",
            "href": null
          }
        ]
        """
        
        let json = """
        {
          "object": "comment",
          "id": "\(id)",
          "parent": \(parent),
          "discussion_id": "\(discussionID)",
          "created_time": "\(createdTime)",
          "last_edited_time": "\(lastEditedTime)",
          "created_by": \(createdBy),
          "rich_text": \(richText),
          "attachments": [
            {
              "category": "image",
              "file": {
                "url": "https://s3.us-west-2.amazonaws.com/...",
                "expiry_time": "2025-06-10T21:58:51.599Z"
              }
            }
          ],
          "display_name": {
            "type": "user",
            "resolved_name": "Avo Cado"
          }
        }
        """.data(using: .utf8)!
        
        let decoderForBlock = JSONDecoder()
        decoderForBlock.dateDecodingStrategy = .formatted(.iso8601Full)
        
        let decoded = try decoderForBlock.decode(
            BlockType.CommentBlockValue.self,
            from: json
        )
        
        // Expected
        
        let decoder = JSONDecoder()
        
        let expected = BlockType
            .CommentBlockValue(
                id: id,
                parent: try! decoder.decode(BlockType.CommentBlockValue.Parent.self, from: parent.data(using: .utf8)!),
                discussionID: discussionID,
                createdTime: DateFormatter.iso8601Full.date(from: createdTime)!,
                lastEditedTime: DateFormatter.iso8601Full.date(from: lastEditedTime)!,
                createdBy: try! decoder.decode(PartialUser.self, from: createdBy.data(using: .utf8)!),
                richText: try! decoder.decode([RichText].self, from: richText.data(using: .utf8)!)
            )
        
        // Assert
        
        #expect(decoded == expected)
        
    }
    
}

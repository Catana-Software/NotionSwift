import Foundation
import NotionSwift
import Testing

struct CommentTests {
    
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
        
        let attachments = """
        [
          {
            "category": "image",
            "file": {
              "url": "https://s3.us-west-2.amazonaws.com/...",
              "expiry_time": "2025-06-10T21:58:51.599Z"
            }
          }
        ]
        """
        
        let displayName = """
        {
          "type": "user",
          "resolved_name": "Avo Cado"
        }
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
          "attachments": \(attachments),
          "display_name": \(displayName)
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.iso8601Full)
        
        let decoded = try decoder.decode(
            NotionSwift.Comment.self,
            from: json
        )
        
        let expected = Comment(
            id: id,
            parent: try! decoder
                .decode(
                    Comment.Parent.self,
                    from: parent.data(using: .utf8)!
                ),
            discussionID: discussionID,
            createdTime: DateFormatter.iso8601Full.date(from: createdTime)!,
            lastEditedTime: DateFormatter.iso8601Full.date(from: lastEditedTime)!,
            createdBy: try! decoder.decode(PartialUser.self, from: createdBy.data(using: .utf8)!),
            richText: try! decoder.decode([RichText].self, from: richText.data(using: .utf8)!),
            attachments: try! decoder
                .decode(
                    [NotionSwift.Comment.Attachment].self,
                    from: attachments.data(using: .utf8)!
                ),
            displayName: try! decoder
                .decode(
                    NotionSwift.Comment.DisplayName.self,
                    from: displayName.data(using: .utf8)!
                )
        )
        
        #expect(decoded == expected)
        
    }
    
    /// Sample from comments API response docs at
    /// https://developers.notion.com/reference/retrieve-comment
    @Test func decodesSampleWithoutAttachments() throws {
        
        let id = "249911a-125e-803e-a164-001cf338b8ec"
        
        let parent = """
          {
            "type": "block_id",
            "block_id": "247vw11a-125e-8053-8e73-d3b3ed4f5768"
          }
        """
        
        let discussionID = "1mv7b911a-125e-80df-8c9e-001c179f63ef"
        
        let createdTime = "2025-08-06T20:36:00.000Z"
        
        let lastEditedTime = "2025-08-06T20:36:00.000Z"
        
        let createdBy = """
          {
            "object": "user",
            "id": "2092e755-4912-81f0-98dd-0002ad4ec952"
          }
        """
        
        let richText = """
          [
            {
              "type": "text",
              "text": {
                "content": "hello there",
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
              "plain_text": "hello there",
              "href": null
            }
          ]
        """
        
        let displayName = """
        {
          "type": "integration",
          "resolved_name": "int"
        }
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
          "display_name": \(displayName)
        }
        """.data(using: .utf8)!
        
        let decoderForBlock = JSONDecoder()
        decoderForBlock.dateDecodingStrategy = .formatted(.iso8601Full)
        
        let decoded = try decoderForBlock.decode(
            NotionSwift.Comment.self,
            from: json
        )
        
        let decoder = JSONDecoder()
        
        let expected = Comment(
            id: id,
            parent: try! decoder
                .decode(
                    NotionSwift.Comment.Parent.self,
                    from: parent.data(using: .utf8)!
                ),
            discussionID: discussionID,
            createdTime: DateFormatter.iso8601Full.date(from: createdTime)!,
            lastEditedTime: DateFormatter.iso8601Full.date(from: lastEditedTime)!,
            createdBy: try! decoder.decode(PartialUser.self, from: createdBy.data(using: .utf8)!),
            richText: try! decoder.decode([RichText].self, from: richText.data(using: .utf8)!),
            attachments: nil,
            displayName: try! decoder
                .decode(
                    NotionSwift.Comment.DisplayName.self,
                    from: displayName.data(using: .utf8)!
                )
        )
        
        #expect(decoded == expected)
        
    }
    
}

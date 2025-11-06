import Foundation
import NotionSwift
import Testing

struct CommentTests {
    
    private typealias Comm = NotionSwift.Comment
    
    private func makeComment(richText: [RichText]) -> Comm {
        
        let comment = Comm(
            id: LowercaseUUID(),
            parent: .workspace,
            discussionID: LowercaseUUID(),
            createdTime: .now,
            lastEditedTime: .now,
            createdBy: .init(id: .init(LowercaseUUID())),
            richText: richText,
            attachments: nil,
            displayName: .custom(resolvedName: "Bot")
        )
        
        return comment
        
    }
    
    /// Sample JSON from https://developers.notion.com/reference/comment-object
    @Test func decodesSampleResponse() throws {
        
        let id = try #require(LowercaseUUID(uuidString: "7a793800-3e55-4d5e-8009-2261de026179"))
        
        let parent = """
          {
           "type": "page_id",
           "page_id": "5c6a2821-6bb1-4a7e-b6e1-c50111515c3d"
          }
        """
        
        let discussionID = try #require(LowercaseUUID(uuidString: "f4be6752-a539-4da2-a8a9-c3953e13bc0b"))
        
        let createdTime = "2022-07-15T21:17:00.000Z"
        
        let lastEditedTime = "2022-07-15T21:17:00.000Z"
        
        let createdBy = """
          {
            "object": "user",
            "id": "e450a39e-9051-4d36-bc4e-8581611fc592"
          }
        """
        
        let plainText = "Hello world"
        
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
            "plain_text": "\(plainText)",
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
          "id": "\(id.uuidString)",
          "parent": \(parent),
          "discussion_id": "\(discussionID.uuidString)",
          "created_time": "\(createdTime)",
          "last_edited_time": "\(lastEditedTime)",
          "created_by": \(createdBy),
          "rich_text": \(richText),
          "attachments": \(attachments),
          "display_name": \(displayName)
        }
        """
        
        let decoded: Comm = try decodeFromJson(json)
        
        let expected = Comm(
            id: id,
            parent: try! decodeFromJson(parent),
            discussionID: discussionID,
            createdTime: DateFormatter.iso8601Full.date(from: createdTime)!,
            lastEditedTime: DateFormatter.iso8601Full.date(from: lastEditedTime)!,
            createdBy: try! decodeFromJson(createdBy),
            richText: try! decodeFromJson(richText),
            attachments: try! decodeFromJson(attachments),
            displayName: try! decodeFromJson(displayName)
        )
        
        #expect(decoded == expected)
        
        // Use this construction of a comment to inspect our computed `plainText` property
        #expect(decoded.plainText == plainText)
        
    }
    
    /// Sample from comments API response docs at
    /// https://developers.notion.com/reference/retrieve-comment
    ///
    /// __Note:__ Alterations made to UUID values to cause valid version 4 UUIDs
    @Test func decodesSampleWithoutAttachments() throws {
        
        let id = try #require(LowercaseUUID(uuidString: "26E409D8-125e-403e-a164-001cf338b8ec"))
        
        let parentId = try #require(LowercaseUUID(uuidString: "247ae11a-125e-4053-8e73-d3b3ed4f5768"))
        let parent = """
          {
            "type": "block_id",
            "block_id": "\(parentId.uuidString)"
          }
        """
        
        let discussionID = try #require(LowercaseUUID(uuidString: "C83CA45A-125e-40df-8c9e-001c179f63ef"))
        
        let createdTime = "2025-08-06T20:36:00.000Z"
        
        let lastEditedTime = "2025-08-06T20:36:00.000Z"
        
        let createdBy = """
          {
            "object": "user",
            "id": "2092e755-4912-81f0-98dd-0002ad4ec952"
          }
        """
        
        let plainText = "hello there"
        
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
              "plain_text": "\(plainText)",
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
          "id": "\(id.uuidString)",
          "parent": \(parent),
          "discussion_id": "\(discussionID.uuidString)",
          "created_time": "\(createdTime)",
          "last_edited_time": "\(lastEditedTime)",
          "created_by": \(createdBy),
          "rich_text": \(richText),
          "display_name": \(displayName)
        }
        """
        
        let decoded: Comm = try decodeFromJson(json)
        
        let expected = Comm(
            id: id,
            parent: try! decodeFromJson(parent),
            discussionID: discussionID,
            createdTime: DateFormatter.iso8601Full.date(from: createdTime)!,
            lastEditedTime: DateFormatter.iso8601Full.date(from: lastEditedTime)!,
            createdBy: try! decodeFromJson(createdBy),
            richText: try! decodeFromJson(richText),
            attachments: nil,
            displayName: try! decodeFromJson(displayName)
        )
        
        #expect(decoded == expected)
        #expect(decoded.plainText == plainText)
        
    }
    
    @Test func plainTextEmptyForEmptyRichText() {
        
        let comment = makeComment(richText: [])
        
        #expect(comment.plainText == "")
        
    }
    
    @Test func plainTextEmptyForRichTextNilPlainText() throws {
        
        let richText = RichText(string: "This has no plain text")
        
        try #require(richText.plainText == nil)
        
        let comment = makeComment(richText: [richText])
        
        #expect(comment.plainText == "")
        
    }
    
    @Test func plainTextContainedAllPlainText() throws {
        
        let thisIs = "This is "
        let richText0 = RichText(plainText: thisIs, type: .text(.init(content: thisIs)))
        
        let aString = "a string "
        let richText1 = RichText(plainText: aString, type: .text(.init(content: aString)))
        
        let link = LowercaseUUID().uuidString
        let richText2 = RichText(
            plainText: link,
            type: .mention(.init(type: .page(.init(.init(LowercaseUUID())))))
        )
        
        let comment = makeComment(richText: [richText0, richText1, richText2])
        
        #expect(comment.plainText == thisIs + aString + link)
        
    }
    
}

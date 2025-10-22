import Foundation
import NotionSwift
import Testing

struct Comment_CreateRequestTests {
    
    private typealias CreateRequest = NotionSwift.Comment.CreateRequest
    private typealias AttachmentRequest = NotionSwift.Comment.AttachmentRequest
    private typealias Comm = NotionSwift.Comment
    
    /// This sample is taken from the docs at
    /// https://developers.notion.com/reference/comment-display-name
    ///
    /// - Important: The docs sample has a parent object that does not
    /// supply a "type" property, which is specified in the reference docs at
    /// https://developers.notion.com/reference/parent-object. The wording of the
    /// docs is that in the case of a page parent the "type" is always page id,
    /// from this it has been inferred that this property is not optional.
    ///
    /// In addition the RichText array contains objects with missing properties.
    ///
    /// As such this test has been disabled as it will not pass.
    @Test(.disabled("Unable to decode API doc sample"))
    func decodesDocsSampleRequest() throws {
        
        let id = "2d0a1ffaf-a4d8-4acf-a1ed-abae6e110418"
        
        let json = """
        {
          "parent": {
            "page_id": "\(id)"
          },
          "rich_text": [
            {
              "text": {
                "content": "Thanks for checking us out!"
              }
            }
          ],
          "display_name": {
            "type": "custom",
            "custom": {
              "name": "Notion Bot"
            }
          }
        }
        """
        
        let request: CreateRequest = try decodeFromJson(json)
        
        let encoded = try encodeToJson(request)
        
        let decoded: CreateRequest = try decodeFromJson(encoded)
        
        #expect(decoded == request)
        
    }
    
    @Test func initWithParentThrowsOnGtr3Attachments() {
        
        let blockParent = Comm.Parent.block(UUID().uuidString)
        let pageParent = Comm.Parent.page(UUID().uuidString)
        
        let displayNameCustom = Comm.DisplayNameRequest.custom(name: "Name")
        let displayNameIntegration = Comm.DisplayNameRequest.integration
        let displayNameUser = Comm.DisplayNameRequest.user
        
        let parents = [blockParent, pageParent].shuffled()
        let displayNames = [displayNameUser, displayNameIntegration, displayNameCustom].shuffled()
        
        for parent in parents {
            
            for displayName in displayNames {
                
                for count in 4..<10 {
                    
                    #expect(throws: CreateRequest.RequestError.self) {
                        
                        let _ = try CreateRequest(
                            parent: parent,
                            richText: makeRichText(count: .random(in: 0...10)),
                            attachments: makeAttachments(count: count),
                            displayName: displayName
                        )
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    @Test func initWithDiscussionThrowsOnGtr3Attachments() {
        
        let displayNameCustom = Comm.DisplayNameRequest.custom(name: "Name")
        let displayNameIntegration = Comm.DisplayNameRequest.integration
        let displayNameUser = Comm.DisplayNameRequest.user
        
        let displayNames = [displayNameUser, displayNameIntegration, displayNameCustom].shuffled()
        
        for displayName in displayNames {
            
            for count in 4..<10 {
                
                #expect(throws: CreateRequest.RequestError.self) {
                    
                    let _ = try CreateRequest(
                        discussionID: UUID().uuidString,
                        richText: makeRichText(count: .random(in: 0...10)),
                        attachments: makeAttachments(count: count),
                        displayName: displayName
                    )
                    
                }
                
            }
            
            
        }
        
    }
    
    /// - Note: Uses an empty RichText property to allow codable testing
    @Test func codableParentInit() throws {
        
        let blockParent = Comm.Parent.block(UUID().uuidString)
        let pageParent = Comm.Parent.page(UUID().uuidString)
        
        let displayNameCustom = Comm.DisplayNameRequest.custom(name: "Name")
        let displayNameIntegration = Comm.DisplayNameRequest.integration
        let displayNameUser = Comm.DisplayNameRequest.user
        
        let parents = [blockParent, pageParent].shuffled()
        let displayNames = [displayNameUser, displayNameIntegration, displayNameCustom].shuffled()
        
        for parent in parents {
            
            for displayName in displayNames {
                
                let request = try CreateRequest(
                    parent: parent,
                    richText: [],
                    attachments: makeAttachments(count: .random(in: 0..<3)),
                    displayName: displayName
                )
                
                let json = try encodeToJson(request)
                let decoded: CreateRequest = try decodeFromJson(json)
                
                #expect(decoded == request)
                
            }
            
        }
        
    }
    
    /// - Note: Uses an empty RichText property to allow codable testing
    @Test func codableDiscussionIdInit() throws {
        
        let displayNameCustom = Comm.DisplayNameRequest.custom(name: "Name")
        let displayNameIntegration = Comm.DisplayNameRequest.integration
        let displayNameUser = Comm.DisplayNameRequest.user
        let displayNames = [displayNameUser, displayNameIntegration, displayNameCustom].shuffled()
        
        for displayName in displayNames {
            
            let request = try CreateRequest(
                discussionID: UUID().uuidString,
                richText: [],
                attachments: makeAttachments(count: .random(in: 0..<3)),
                displayName: displayName
            )
            
            let json = try encodeToJson(request)
            let decoded: CreateRequest = try decodeFromJson(json)
            
            #expect(decoded == request)
            
        }
        
    }
    
    @Test func decodingThrowsWhenBothDiscussionIdAndParentProvided() throws {
        
        let json = """
        {
          "discussion_id": "\(UUID().uuidString)",
          "parent": {
            "type": "page_id",
            "page_id": "\(UUID().uuidString)"
          },
          "rich_text": [],
          "attachments": [],
          "display_name": {
            "type": "custom",
            "custom": {
              "name": "Notion Bot"
            }
          }
        }
        """
        
        do {
            
            let _: CreateRequest = try decodeFromJson(json)
            #expect(Bool(false))
            
        } catch let error as CreateRequest.RequestError {
            
            switch error {
            case .parentAndDiscussionConflict: break
            default: #expect(Bool(false))
            }
            
        } catch {
            
            #expect(Bool(false))
            
        }
        
    }
    
    @Test func decodingThrowsWhenNeitherDiscussionIdNorParentProvided() throws {
        
        let json = """
        {
          "rich_text": [],
          "attachments": [],
          "display_name": {
            "type": "custom",
            "custom": {
              "name": "Notion Bot"
            }
          }
        }
        """
        
        do {
            
            let _: CreateRequest = try decodeFromJson(json)
            #expect(Bool(false))
            
        } catch let error as CreateRequest.RequestError {
            
            switch error {
            case .missingLocation: break
            default: #expect(Bool(false))
            }
            
        } catch {
            
            #expect(Bool(false))
            
        }
        
    }
    
}

extension Comment_CreateRequestTests {
    
    /// Creates a `RichText` instance from a plain `String` for use in tests.
    ///
    /// - Parameter string: The plain text content to embed in a `RichText` value.
    ///
    /// - Returns: A `RichText` with `plainText` set to `string` and a `.text` content
    ///   type initialized with the same content.
    private func richText(_ string: String) -> RichText {
        return .init(plainText: string, type: .text(.init(content: string)))
    }
    
    /// Creates an array of `RichText` test fixtures with incrementing placeholder content.
    ///
    /// If `count` is less than or equal to zero, this function returns an empty array.
    ///
    /// - Parameter count: The number of `RichText` items to generate.
    ///
    /// - Returns: An array containing `count` `RichText` values with content like "Text 0",
    ///   "Text 1", etc.
    private func makeRichText(count: Int) -> [RichText] {
        guard count > 0 else { return [] }
        return (0..<count)
            .map { richText("Text \($0)") }
    }
    
    /// Creates an array of `AttachmentRequest` test fixtures.
    ///
    /// - Parameter count: The number of attachments to create. If `count` ≤ 0, returns an
    ///   empty array.
    ///
    /// - Returns: An array of `AttachmentRequest` instances with unique `fileUploadID` values.
    private func makeAttachments(count: Int) -> [AttachmentRequest] {
        
        guard count > 0 else { return [] }
        
        return (0..<count)
            .map { _ in makeAttachment() }
        
    }
    
    /// Creates a single `AttachmentRequest` test fixture with a unique `fileUploadID`.
    ///
    /// The `type` is set to `nil`.
    ///
    /// - Returns: A new `AttachmentRequest`.
    private func makeAttachment() -> AttachmentRequest {
        
        return AttachmentRequest(
            fileUploadID: UUID().uuidString,
            type: nil
        )
        
    }
    
}

import Foundation

extension Comment {
    
    /// The `CreateRequest` models the data required for a call to the
    /// [create comment API](https://developers.notion.com/reference/create-a-comment).
    ///
    /// API reference can be found
    /// [here](https://developers.notion.com/reference/comment-attachment). The main points
    /// to cover for encoding/decoding behaviour are listed below:
    ///
    /// There are three locations where a new comment can be added with the public API:
    ///
    /// * A page
    /// * A block
    /// * An existing discussion thread
    ///
    /// The request body will differ slightly depending on which type of comment is being
    /// added with this endpoint.
    ///
    /// To add a new comment to a page or block, a parent object with a page id or block id
    /// must be provided in the body params.
    ///
    /// To add a new comment to an existing discussion thread, a discussion id string must be
    /// provided in the body params. (Inline comments to start a new discussion thread cannot
    /// be created via the public API.)
    ///
    /// *Either* the parent.page&lowbar;id, parent.bloc&lowbar;id or discussion&lowbar;id parameter
    /// must be provided — ONLY one can be specified.
    public struct CreateRequest {
        
        /// The target location for a new comment: either a page or a block.
        ///
        /// Mutually exclusive with `discussionID`. Provide this to start a new discussion
        /// on a page or block; leave `nil` when replying within an existing discussion.
        public let parent: Parent?
        
        /// The identifier of an existing discussion thread to reply to.
        ///
        /// Mutually exclusive with `parent`. Provide this to add a comment within an
        /// existing discussion; leave `nil` when starting a new discussion on a page/block.
        public let discussionID: UUIDv4?
        
        /// The comment body as an ordered array of rich text objects.
        ///
        /// Encoded as `rich_text` per the Notion API.
        public let richText: [RichText]
        
        /// Attachment requests to include alongside the comment (maximum of 3).
        ///
        /// Validated by initializers; decoding accepts the payload as-is.
        public let attachments: [AttachmentRequest]
        
        /// The display name to attribute to the authored comment.
        /// 
        /// Encoded as `display_name` per the Notion API.
        public let displayName: DisplayNameRequest
        
        /// Creates a request to add a new comment to a page or block.
        ///
        /// Use this initializer to start a new discussion on a specific page or block by
        /// providing a `parent` that identifies the target. Only one of `parent` or
        /// `discussionID` may be set for a request; when using this initializer,
        /// `discussionID` is set to `nil`.
        ///
        /// - Parameter parent: The parent location for the new comment. Provide either a
        ///   page ID or block ID parent.
        /// - Parameter richText: The content of the comment as an array of rich text objects,
        ///   in display order.
        /// - Parameter attachments: Max 3 requests to include alongside the comment.
        /// - Parameter displayName: The display name to attribute to the comment.
        ///
        /// - Throws: `RequestError.maxAttachments(count:)` if `attachments.count` is greater
        ///   than 3.
        public init(
            parent: Parent,
            richText: [RichText],
            attachments: [AttachmentRequest],
            displayName: DisplayNameRequest
        ) throws {
            
            guard
                attachments.count <= 3
            else { throw RequestError.overAttachmentLimit(count: attachments.count) }
            
            self.parent = parent
            self.discussionID = nil
            self.richText = richText
            self.attachments = attachments
            self.displayName = displayName
            
        }
        
        /// Creates a request to add a new comment to an existing discussion thread.
        ///
        /// Use this initializer when you want to reply to an existing discussion by
        /// providing its `discussionID`. Only one of `parent` or `discussionID` may be
        /// set for a request; when using this initializer, `parent` is set to `nil`.
        ///
        /// - Parameter discussionID: The identifier of the existing discussion thread to reply
        ///   to.
        /// - Parameter richText: The content of the comment as an array of rich text objects,
        ///   in display order.
        /// - Parameter attachments: Max 3 requests to include alongside the comment.
        /// - Parameter displayName: The display name to attribute to the comment.
        ///
        /// - Throws: `RequestError.overAttachmentLimit(count:)` if `attachments.count` is greater
        ///   than 3.
        public init(
            discussionID: UUIDv4,
            richText: [RichText],
            attachments: [AttachmentRequest],
            displayName: DisplayNameRequest
        ) throws {
            
            guard
                attachments.count <= 3
            else { throw RequestError.overAttachmentLimit(count: attachments.count) }
            
            self.parent = nil
            self.discussionID = discussionID
            self.richText = richText
            self.attachments = attachments
            self.displayName = displayName
            
        }
        
    }
    
}

extension Comment.CreateRequest: Codable {
    
    /// Errors that can occur when constructing or decoding a `Comment.CreateRequest`
    public enum RequestError: Error {
        
        /// The number of attachment requests exceeded the maximum allowed.
        ///
        /// - Parameter count: The number of attachments provided in the request.
        case overAttachmentLimit(count: Int)
        
        /// Neither a `parent` nor a `discussionID` was provided.
        /// Exactly one location must be specified for a valid request.
        case missingLocation
        
        /// Both `parent` and `discussionID` were provided.
        /// These fields are mutually exclusive and only one may be set.
        case parentAndDiscussionConflict
        
    }
    
    private enum CodingKeys: String, CodingKey {
        case parent
        case discussionID = "discussion_id"
        case richText = "rich_text"
        case attachments
        case displayName = "display_name"
    }
    
    /// Decodes a `CreateRequest` according to Notion API spec
    ///
    /// Expected keys (snake_case where applicable):
    /// - `parent`: Optional object identifying the target page or block. Mutually exclusive
    ///   with `discussion_id`.
    /// - `discussion_id`: Optional UUIDv4 identifying an existing discussion. Mutually
    ///   exclusive with `parent`.
    /// - `rich_text`: Required array of `RichText` objects that make up the comment body.
    /// - `attachments`: Required array of `AttachmentRequest` objects. The count is validated
    ///   by initializers when constructing in Swift; decoding accepts what the payload provides.
    /// - `display_name`: Required `DisplayNameRequest` for attribution.
    ///
    /// Decoding rules:
    /// - Exactly one of `parent` or `discussion_id` must be present. If neither is present,
    ///   decoding fails with `RequestError.missingLocation`.
    /// - If both `parent` and `discussion_id` are present, decoding fails with
    ///   `RequestError.parentAndDiscussionConflict`.
    /// - `rich_text`, `attachments`, and `display_name` must be present and valid or decoding will
    ///   throw the corresponding `DecodingError`.
    ///
    /// - Throws: `RequestError.missingLocation` or `RequestError.parentAndDiscussionConflict` for
    ///   invalid location specification, or standard `DecodingError` for malformed payloads.
    public init(from decoder: any Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let parent = try container.decodeIfPresent(Comment.Parent.self, forKey: .parent)
        let discussionID = try container.decodeIfPresent(UUIDv4.self, forKey: .discussionID)
        let richText = try container.decode([RichText].self, forKey: .richText)
        let attachments = try container.decode([Comment.AttachmentRequest].self, forKey: .attachments)
        let displayName = try container.decode(Comment.DisplayNameRequest.self, forKey: .displayName)

        let hasParent = (parent != nil)
        let hasDiscussion = (discussionID != nil)
        
        if !hasParent && !hasDiscussion { throw RequestError.missingLocation }
        if hasParent && hasDiscussion { throw RequestError.parentAndDiscussionConflict }

        self.parent = parent
        self.discussionID = discussionID
        self.richText = richText
        self.attachments = attachments
        self.displayName = displayName
        
    }
    
}

extension Comment.CreateRequest: Equatable {}
extension Comment.CreateRequest: Sendable {}


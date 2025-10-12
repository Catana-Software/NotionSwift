import Foundation

extension BlockType {
    
    /// A type describing a comment block
    ///
    /// This model represents a single comment within a discussion thread, including
    /// identifiers, timestamps, author information, and the rich text content of the
    /// comment.
    ///
    /// Notion API documentation can be found at
    /// https://developers.notion.com/reference/comment-object
    ///
    /// Key characteristics:
    /// - object: Always "comment", matching the Notion API’s object discriminator.
    /// - id: A unique identifier for the comment.
    /// - parent: The parent context (database, data source, page, or workspace) where the
    ///   comment resides.
    /// - discussionID: Identifier linking this comment to a broader discussion thread.
    /// - createdTime / lastEditedTime: Creation and last modification timestamps for auditing
    ///   and UI display.
    /// - createdBy: A lightweight representation of the user who authored the comment.
    /// - richText: The rich text content supporting formatting, links, and mentions.
    ///
    /// Codable behavior:
    /// - Uses snake_case key mapping to align with Notion API response fields:
    ///   - discussion_id, created_time, last_edited_time, created_by, rich_text.
    /// - The `parent` property encodes/decodes a tagged representation with a `type` field
    ///   and associated payload fields (e.g., database_id, data_source_id, page_id, workspace).
    ///
    /// Thread-safety and value semantics:
    /// - Conforms to `Sendable` and `Equatable`, making it suitable for use in Swift Concurrency
    ///   contexts and for reliable equality checks in testing or state management.
    public struct CommentBlockValue {
        
        /// Always "comment"
        public let object: String = "comment"
        
        /// Unique identifier of the comment
        public let id: UUIDv4
        
        /// Information about the comment's parent block or entity
        ///
        /// The parent typically identifies where this comment lives (for example,
        /// a page or a specific block). See `BlockType.CommentBlockValue.Parent`
        public let parent: Parent
        
        /// Unique identifier for the discussion thread that this comment belongs to
        ///
        /// Multiple comments that are part of the same conversation share the same
        /// `discussionID`
        public let discussionID: UUIDv4
        
        /// The date and time when this comment was created
        public let createdTime: Date
        
        /// The date and time when this comment was last edited
        ///
        /// If a comment has never been edited, this value may be equal to `createdTime`
        public let lastEditedTime: Date
        
        /// The user who originally authored the comment
        ///
        /// Use this to attribute the comment in UI and auditing contexts
        public let createdBy: PartialUser
        
        /// The content of the comment as rich text
        ///
        /// Supports formatting, links, and mentions
        public let richText: [RichText]
        
        /// Creates a new `CommentBlockValue`.
        ///
        /// - Parameter id: Unique identifier of the comment.
        /// - Parameter parent: Information about the comment's parent block or entity.
        /// - Parameter discussionID: The identifier of discussion thread containing this comment.
        /// - Parameter createdTime: The timestamp when the comment was created.
        /// - Parameter lastEditedTime: The timestamp when the comment was last edited.
        /// - Parameter createdBy: The user who authored the comment.
        /// - Parameter richText: The rich text content of the comment.
        public init(
            id: UUIDv4,
            parent: Parent,
            discussionID: UUIDv4,
            createdTime: Date,
            lastEditedTime: Date,
            createdBy: PartialUser,
            richText: [RichText]
        ) {
            
            self.id = id
            self.parent = parent
            self.discussionID = discussionID
            self.createdTime = createdTime
            self.lastEditedTime = lastEditedTime
            self.createdBy = createdBy
            self.richText = richText
            
        }
        
    }
    
}

extension BlockType.CommentBlockValue: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case object
        case id
        case parent
        case discussionID = "discussion_id"
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case createdBy = "created_by"
        case richText = "rich_text"
    }
    
}

extension BlockType.CommentBlockValue: Equatable {}
extension BlockType.CommentBlockValue: Sendable {}


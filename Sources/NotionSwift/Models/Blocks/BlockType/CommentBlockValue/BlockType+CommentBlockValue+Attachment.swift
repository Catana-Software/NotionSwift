import Foundation

extension BlockType.CommentBlockValue {
    
    /// Attachment value associated with a comment block
    ///
    /// Represents a piece of content attached to a comment, such as images,
    /// audio, video, PDFs or productivity files. Each attachment includes a
    /// category and a file object describing a time-limited URL
    public struct Attachment {
        
        /// The high-level type of the attachment as reported by Notion
        public let category: Category
        
        /// The file metadata containing the URL (as a `String`) and its expiration time
        public let file: FileObject
        
    }
    
}

extension BlockType.CommentBlockValue.Attachment: Codable {}
extension BlockType.CommentBlockValue.Attachment: Equatable {}
extension BlockType.CommentBlockValue.Attachment: Sendable {}

import Foundation

extension BlockType.CommentBlockValue.Attachment {
    
    /// Categories of attachments supported by Notion comments
    ///
    /// These values correspond to the `type` field in the Notion API response
    public enum Category: String {
        
        case audio
        case image
        case pdf
        case productivity
        case video
        
    }
    
}

extension BlockType.CommentBlockValue.Attachment.Category: Codable {}
extension BlockType.CommentBlockValue.Attachment.Category: Equatable {}
extension BlockType.CommentBlockValue.Attachment.Category: Sendable {}

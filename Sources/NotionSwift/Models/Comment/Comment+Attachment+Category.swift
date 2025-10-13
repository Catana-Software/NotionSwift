import Foundation

extension Comment.Attachment {
    
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

extension Comment.Attachment.Category: Codable {}
extension Comment.Attachment.Category: Equatable {}
extension Comment.Attachment.Category: Sendable {}

import Foundation

/// Notion Comment Attachment file object
///
/// This implementation follows the Notion documentation at
/// https://developers.notion.com/reference/comment-attachment
///
/// It intentionally differs from the `FileFile` implementation elsewhere in
/// the project. The observed response structure for comment attachments
/// appears to align with an internal `_FileLink` shape, exposing a direct
/// URL and an expiration timestamp. If future API responses introduce
/// additional shapes, this type may need to be revisited to better align
/// with the spec
extension Comment.Attachment {
    
    /// A time limited link to the attached file
    public struct FileObject {
        
        /// The direct URL to the file resource. This link is time-limited and may
        /// require refresh after expiration
        public let url: String
        
        /// The date and time when the URL expires.
        ///
        /// Decoding expects the ISO 8601 timestamp provided by Notion under the
        /// `expiry_time` key.
        public let expiryTime: Date
        
    }
    
}

extension Comment.Attachment.FileObject: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case url
        case expiryTime = "expiry_time"
    }
    
}

extension Comment.Attachment.FileObject: Equatable {}
extension Comment.Attachment.FileObject: Sendable {}

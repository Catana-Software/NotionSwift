import Foundation

extension Comment {
    
    /// The `AttachmentRequest` object represents files that are to be attached to a
    /// `Comment` by calling the
    /// [create comment API](https://developers.notion.com/reference/create-a-comment).
    ///
    /// API reference can be found
    /// [here](https://developers.notion.com/reference/comment-attachment).
    ///
    /// - Important: Comments can currently support up to 3 attachments.
    public struct AttachmentRequest {
        
        /// ID of a File Upload with a status of "uploaded"
        public let fileUploadID: LowercaseUUID
        
        /// An optional with possible value of "file&lowbar;upload". The API reference lists
        /// this property as optional with a single enum case and does not specify under what
        /// circumstances it would be used. It would therefore appear to be acceptable to always
        /// omit, but is provided here for compatability
        public let type: String?
        
        /// Creates a new `AttachmentRequest` used to attach an uploaded file to a `Comment`.
        ///
        /// This initializer is to prepae the payload for Notion's create comment API.
        ///
        /// - Parameter fileUploadID: The identifier of a File Upload resource that has a status
        ///   of "uploaded" in Notion. This ID must reference an already-uploaded file.
        /// - Parameter type: An optional string that may be set to "file&lowbar;upload". The
        ///   Notion API marks this as optional with a single supported value and does not specify
        ///   when it is required; it is generally acceptable to omit this value.
        public init(
            fileUploadID: LowercaseUUID,
            type: String?
        ) {
            
            self.fileUploadID = fileUploadID
            self.type = type
            
        }
        
    }
    
}

extension Comment.AttachmentRequest: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case fileUploadID = "file_upload_id"
        case type
    }
    
}

extension Comment.AttachmentRequest: Equatable {}
extension Comment.AttachmentRequest: Sendable {}

import Foundation

// MARK: - Comments

extension NotionClient {
    
    /// Retrieves a single comment by its identifier
    ///
    /// See Notion API: https://developers.notion.com/reference/retrieve-comment
    ///
    /// - Parameter id: An identifier to retrieve.
    /// - Parameter completed: A closure called with the result containing `Comment` on success,
    ///   or a `NotionClientError` on failure.
    public func comment(
        id: UUIDv4,
        completed: @Sendable @escaping (Result<Comment, NotionClientError>) -> Void
    ) {
        
        networkClient.get(
            urlBuilder.url(
                path: "/v1/comments/{identifier}",
                identifier: id
            ),
            headers: headers(),
            completed: completed
        )
        
    }
    
    /// Retrieves a list of comments for an identifier relating to a block
    ///
    /// See Notion API: https://developers.notion.com/reference/list-comments
    ///
    /// - Parameter id: A `block_id` parameter to query list of unresolved comments.
    /// - Parameter params: The start cursor and page size params.
    /// - Parameter completed: A closure called with the result containing a
    ///   `ListResponse` of `Comment` on success, or a `NotionClientError` on failure.
    public func comments(
        id: UUIDv4,
        params: BaseQueryParams,
        completed: @Sendable @escaping (Result<ListResponse<Comment>, NotionClientError>) -> Void
    ) {
        
        var combinedParams = params.asParams
        combinedParams["block_id"] = id
        
        networkClient.get(
            urlBuilder
                .url(
                    path: "/v1/comments",
                    params: combinedParams
                ),
            headers: headers(),
            completed: completed
        )
        
    }
    
    /// Creates a new comment in Notion
    ///
    /// Sends a POST request to the Notion API endpoint `/v1/comments` to create a comment
    /// associated with a specific block or discussion thread.
    ///
    /// See Notion API: https://developers.notion.com/reference/create-a-comment
    ///
    /// - Parameter request: The payload describing the comment to create, including the target
    ///   context (e.g., a block ID or discussion ID) and the comment content.
    /// - Parameter completed: A closure invoked upon completion with a `Result` containing:
    ///   - `.success(Comment)`: The newly created `Comment` returned by the API.
    ///   - `.failure(NotionClientError)`: An error describing why the request failed.
    public func create(
        request: Comment.CreateRequest,
        completed: @Sendable @escaping (Result<Comment, NotionClientError>) -> Void
    ) {
        
        networkClient.post(
            urlBuilder.url(path: "/v1/comments"),
            body: request,
            headers: headers(),
            completed: completed
        )
        
    }
    
}

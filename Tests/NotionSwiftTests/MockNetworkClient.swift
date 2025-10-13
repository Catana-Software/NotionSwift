import Foundation
@testable import NotionSwift

/// A simple test double for `NetworkClient` that returns supplied result
final class MockNetworkClient: NetworkClient {
    
    private var anyResult: Any
    
    init(
        success: [Comment],
        nextCursor: String? = nil,
        hasMore: Bool = false
    ) {
        
        self.anyResult = Result<ListResponse<Comment>, NotionClientError>
            .success(
                ListResponse(
                    results: success,
                    nextCursor: nextCursor,
                    hasMore: hasMore
                )
            )
        
    }
    
    init(success: Comment) {
        
        self.anyResult = Result<Comment, NotionClientError>
            .success(success)
        
    }
    
    init(
        failure: NotionClientError
    ) {
        
        self.anyResult = failure
        
    }
    
    func get<T: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<T, NotionClientError>) -> Void
    ) {
        
        guard
            let result = anyResult as? Result<T, NotionClientError>
        else {
            
            let error = NSError(domain: "Test logic error", code: 1)
            
            completed(.failure(.genericError(error)))
            
            return
        }
        
        completed(result)
        
    }
    
    func post<T: Encodable, U: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<U, NotionClientError>) -> Void
    ) {
        fatalError("Tests not implemented for uses of this method")
    }
    
    func patch<T: Encodable, U: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<U, NotionClientError>) -> Void
    ) {
        fatalError("Tests not implemented for uses of this method")
    }
    
    func delete<T: Decodable>(
        _ url: URL,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<T, NotionClientError>) -> Void
    ) {
        fatalError("Tests not implemented for uses of this method")
    }
    
    func delete<T: Encodable, U: Decodable>(
        _ url: URL,
        body: T,
        headers: Network.HTTPHeaders,
        completed: @escaping (Result<U, NotionClientError>) -> Void
    ) {
        fatalError("Tests not implemented for uses of this method")
    }
    
}

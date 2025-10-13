import Foundation
@testable import NotionSwift

/// A simple test double for `NetworkClient` that returns supplied result
final class MockNetworkClient: NetworkClient {
    
    private var anyResult: Any
    
    private var expectedURL: URL?
    
    init(
        success: [Comment],
        nextCursor: String? = nil,
        hasMore: Bool = false,
        expectedURL: URL? = nil
    ) {
        
        self.anyResult = Result<ListResponse<Comment>, NotionClientError>
            .success(
                ListResponse(
                    results: success,
                    nextCursor: nextCursor,
                    hasMore: hasMore
                )
            )
        
        self.expectedURL = expectedURL
        
    }
    
    init(
        success: Comment,
        expectedURL: URL? = nil
    ) {
        
        self.anyResult = Result<Comment, NotionClientError>
            .success(success)
        
        self.expectedURL = expectedURL
        
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
        
        if let expectedURL = expectedURL {
            
            if url.absoluteString != expectedURL.absoluteString {
                
                let error = NSError(
                    domain: "URL mismatch expected: \(expectedURL), got: \(url)",
                    code: 1
                )
             
                completed(.failure(.genericError(error)))
                
                return
            }
            
        }
        
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

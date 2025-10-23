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
                
        if let result: Result<T, NotionClientError> = check(url: url) {
            completed(result)
            return
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
        
        if let result: Result<U, NotionClientError> = check(url: url) {
            completed(result)
            return
        }
        
        guard
            let result = anyResult as? Result<U, NotionClientError>
        else {
            
            let error = NSError(domain: "Test logic error", code: 1)
            
            completed(.failure(.genericError(error)))
            
            return
            
        }
        
        completed(result)
        
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
    
    /// Verifies that a requested URL matches an expected URL set on the mock and returns a
    /// failure result if it does not.
    ///
    /// This helper is used by the mock network client to enforce that calls are made to the
    /// correct endpoint during tests.
    ///
    /// - If `expectedURL` is set and the provided `url` does not match (by `absoluteString`
    ///   comparison), the method returns
    ///   a `.failure(.genericError(NSError))` describing the mismatch.
    /// - If `expectedURL` is not set, or the URLs match, the method returns `nil`, signaling
    ///   that no error should be injected and the caller may proceed with its normal result
    ///   handling.
    ///
    /// - Parameter url: The URL invoked by the test code.
    ///
    /// - Returns: A typed `Result<U, NotionClientError>` failure when the URL mismatches, or
    ///   `nil` when the URL is acceptable.
    ///
    /// - Note: The generic type `U` is only used to shape the returned `Result` type so it
    ///   integrates with the caller's expected generic signature; no value of type `U`
    ///   is produced here.
    func check<U>(url: URL) -> Result<U, NotionClientError>? {
        
        if let expectedURL = expectedURL {
            
            if url.absoluteString != expectedURL.absoluteString {
                
                let error = NSError(
                    domain: "URL mismatch expected: \(expectedURL), got: \(url)",
                    code: 1
                )
             
                return .failure(.genericError(error))
                
            }
            
        }
        
        return nil
        
    }
    
}

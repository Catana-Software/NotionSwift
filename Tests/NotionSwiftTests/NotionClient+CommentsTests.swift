@testable import NotionSwift
import Foundation
import Testing

struct NotionClient_CommentsTests {
    
    private typealias Comm = NotionSwift.Comment
    
    let testProvider: StringAccessKeyProvider = {
        return .testProvider
    }()
    
    private func makeComment(
        richText: [RichText],
        displayName: Comm.DisplayName = .custom(resolvedName: "Bot")
    ) -> Comm {
        Comm(
            id: UUID().uuidString,
            parent: .workspace,
            discussionID: UUID().uuidString,
            createdTime: .now,
            lastEditedTime: .now,
            createdBy: PartialUser(id: .init(UUID().uuidString)),
            richText: richText,
            attachments: nil,
            displayName: displayName
        )
    }
    
    // MARK: Get Comments
    
    @Test func commentfailure() {
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(failure: .unsupportedResponseError)
        )
        
        client.comment(id: UUID().uuidString) { result in
            
            switch result {
            case .success: #expect(Bool(false))
            case .failure: #expect(true)
            }
            
        }
        
    }
    
    @Test func commentSuccess() {
        
        let richText = RichText(
            string: "This is the text",
            annotations: .underline
        )
        
        let comment = makeComment(richText: [richText])
        
        let requestID = UUID().uuidString
        
        let expectedURL = URLBuilder()
            .url(
                path: "/v1/comments/{identifier}",
                identifier: requestID
            )
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(
                success: comment,
                expectedURL: expectedURL
            )
        )
        
        client.comment(id: requestID) { result in
            
            switch result {
            case .success(let success): #expect(success == comment)
            case .failure(let error): #expect(Bool(false), "\(error)")
            }
            
        }
        
    }
    
    @Test func commentsFailure() {
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(failure: .unsupportedResponseError)
        )
        
        let params = BaseQueryParams(
            startCursor: UUID().uuidString,
            pageSize: 20
        )
        
        client.comments(id: UUID().uuidString, params: params) { result in
            
            switch result {
            case .success: #expect(Bool(false), "Expected failure but received success")
            case .failure: #expect(true)
            }
            
        }
    }
    
    @Test func commentsSuccess() {
        
        let richText = RichText(
            string: "This is the text",
            annotations: .underline
        )
        
        let underline = RichText(
            string: "Underline",
            annotations: .underline
        )
        
        let comments: [Comm] = [
            makeComment(richText: [richText]),
            makeComment(richText: [underline])
        ]
        
        let requestID = UUID().uuidString
        
        var combinedParams = BaseQueryParams().asParams
        combinedParams["block_id"] = requestID
        
        let expectedURL = URLBuilder()
            .url(
                path: "/v1/comments",
                params: combinedParams
            )
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(
                success: comments,
                expectedURL: expectedURL
            )
        )
        
        client.comments(id: requestID, params: BaseQueryParams()) { result in
            
            switch result {
            case .success(let success): #expect(success.results == comments)
            case .failure(let error): #expect(Bool(false), "\(error)")
            }
            
        }
        
    }
    
    // MARK: Create Comment
    
    @Test func createCommentFailsWithFailureCase() throws {
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(failure: .unsupportedResponseError)
        )
        
        let request = try Comm
            .CreateRequest(
                parent: .page(UUID().uuidString),
                richText: [],
                attachments: [],
                displayName: .custom(name: "Bot")
            )
        
        client.create(request: request) { result in
            
            switch result {
            case .success: #expect(Bool(false))
            case .failure: #expect(true)
            }
            
        }
        
    }
    
    @Test func createCommentReturnsExpectedComment() throws {
        
        let richText = RichText(
            string: "This is the text",
            annotations: .underline
        )
        
        let displayName = "Bot"
        
        let comment = makeComment(
            richText: [richText],
            displayName: .custom(resolvedName: displayName)
        )
        
        let expectedURL = URLBuilder()
            .url(path: "/v1/comments")
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(success: comment, expectedURL: expectedURL)
        )
        
        let request = try Comm
            .CreateRequest(
                parent: .workspace,
                richText: comment.richText,
                attachments: [],
                displayName: .custom(name: displayName)
            )
        
        client.create(request: request) { result in
            
            switch result {
            case .success(let returnedComment): #expect(returnedComment == comment)
            case .failure: #expect(Bool(false))
            }
            
        }
        
    }
    
}

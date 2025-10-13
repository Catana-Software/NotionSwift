import NotionSwift
import Testing
import Foundation

struct NotionClient_CommentsTests {
    
    private typealias Comm = NotionSwift.Comment
    
    let testProvider: StringAccessKeyProvider = {
        return .testProvider
    }()
    
    @Test func commentfailure() {
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(failure: .unsupportedResponseError)
        )
        
        client.comment(id: UUID().uuidString) { result in

            switch result {
            case .success:
                #expect(Bool(false))
                
            case .failure:
                #expect(true)
                
            }
            
        }
        
    }
    
    @Test func commentSuccess() {
        
        let partialUser = PartialUser(id: .init(UUID().uuidString))
        
        let richText = RichText(
            string: "This is the text",
            annotations: .underline
        )
        
        let comment = Comm(
            id: UUID().uuidString,
            parent: .workspace,
            discussionID: UUID().uuidString,
            createdTime: .now,
            lastEditedTime: .now,
            createdBy: partialUser,
            richText: [richText],
            attachments: nil,
            displayName: .custom(resolvedName: "Bot")
        )
        
        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(success: comment)
        )
        
        client.comment(id: UUID().uuidString) { result in

            switch result {
            case .success(let success):
                #expect(success == comment)
                
            case .failure:
                #expect(Bool(false))
                
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

        client.comments(params: params) { result in
            switch result {
            case .success:
                #expect(Bool(false), "Expected failure but received success")
            case .failure:
                #expect(true)
            }
        }
    }

    @Test func commentsSuccess() {
        
        let partialUser = PartialUser(id: .init(UUID().uuidString))
        let richText = RichText(
            string: "This is the text",
            annotations: .underline
        )

        let comments: [Comm] = [
            Comm(
                id: UUID().uuidString,
                parent: .workspace,
                discussionID: UUID().uuidString,
                createdTime: .now,
                lastEditedTime: .now,
                createdBy: partialUser,
                richText: [richText],
                attachments: nil,
                displayName: .custom(resolvedName: "Bot")
            ),
            Comm(
                id: UUID().uuidString,
                parent: .workspace,
                discussionID: UUID().uuidString,
                createdTime: .now,
                lastEditedTime: .now,
                createdBy: partialUser,
                richText: [richText],
                attachments: nil,
                displayName: .custom(resolvedName: "Bot 2")
            )
        ]

        let client = NotionClient(
            accessKeyProvider: testProvider,
            networkClient: MockNetworkClient(success: comments)
        )

        let params = BaseQueryParams(
            startCursor: UUID().uuidString,
            pageSize: 20
        )

        client.comments(params: params) { result in
            
            switch result {
            case .success(let success):
                #expect(success.results == comments)
                
            case .failure:
                #expect(Bool(false))
                
            }
        }
        
    }
    
}

import XCTest
@testable import NotionSwift

final class NotionSwiftTests: XCTestCase {

}

extension StringAccessKeyProvider {
    
    static let testProvider = StringAccessKeyProvider(accessKey: "the-access-key")
    
}

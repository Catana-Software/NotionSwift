//
//  Created by Wojciech Chojnacki on 16/09/2021.
//

import Foundation

public struct ErrorResponse: Equatable {
    public let status: Int
    public let code: String
    public let message: String
}

extension ErrorResponse: Decodable {}

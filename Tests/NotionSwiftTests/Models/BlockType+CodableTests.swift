import Foundation
import NotionSwift
import Testing

struct BlockType_CodableTests {
    
    @Test
    func codable() throws {
        
        let tableRow = BlockType
            .tableRow(.init(
                cells: [
                    [.init(string: "A")], [.init(string: "b")],
                    [.init(string: "C")], [.init(string: "D")]
                ]
            ))
        
        let encoded = try encodeToJson(tableRow)
        let decoded: BlockType = try decodeFromJson(encoded)
        
        #expect(tableRow == decoded)
        
    }
    
}

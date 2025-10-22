import Foundation
import NotionSwift
import Testing

struct RichText_AnnotationsTests {
    
    func randomColor() -> String {

        BlockColor.allCases.randomElement().map(\.rawValue) ?? "default"

    }

    @Test func endToEndCodable() throws {
        
        for _ in 0..<10 {
            
            let base = RichText
                .Annotations(
                    bold: .random(),
                    italic: .random(),
                    strikethrough: .random(),
                    underline: .random(),
                    code: .random(),
                    color: randomColor()
                )
            
            let encoded = try encodeToJson(base)
            let decoded: RichText.Annotations = try decodeFromJson(encoded)
            
            #expect(decoded == base)
            
        }
        
    }
    
}

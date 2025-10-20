import Foundation
import NotionSwift
import Testing

struct RichTextTests {
    
    func randomColor() -> String {

        BlockColor.allCases.randomElement().map(\.rawValue) ?? "default"

    }
    
    @Test(.disabled("Disabled until reason for inconsistent implementation found"))
    func endToEndCodable() throws {
        
        for _ in 0..<10 {
            
            let annotations = RichText
                .Annotations(
                    bold: .random(),
                    italic: .random(),
                    strikethrough: .random(),
                    underline: .random(),
                    code: .random(),
                    color: randomColor()
                )
            
            let base = RichText(
                string: randomColor(),
                annotations: annotations
            )
            
            let encoded = try encodeToJson(base)
            let decoded: RichText = try decodeFromJson(encoded)
            
            #expect(decoded == base)
            
        }
        
    }
    
}

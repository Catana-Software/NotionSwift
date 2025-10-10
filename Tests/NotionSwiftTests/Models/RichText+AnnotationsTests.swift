import Foundation
import NotionSwift
import Testing

struct RichText_AnnotationsTests {
    
    func randomColor() -> String {
        
        let colors = [
            "blue",
            "blue_background",
            "brown",
            "brown_background",
            "default",
            "gray",
            "gray_background",
            "green",
            "green_background",
            "orange",
            "orange_background",
            "pink",
            "pink_background",
            "purple",
            "purple_background",
            "red",
            "red_background",
            "yellow",
            "yellow_background"
        ]
        
        return colors.randomElement()!
        
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
            
            let encoder = JSONEncoder()
            let encoded = try encoder.encode(base)
            let decoded = try JSONDecoder()
                .decode(
                    RichText.Annotations.self,
                    from: encoded
                )
            
            #expect(decoded == base)
            
        }
        
    }
    
}

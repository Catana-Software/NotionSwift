import Foundation
import NotionSwift
import Testing

struct RichText_AnnotationsTests {
    
    static func randomColor() -> String {

        BlockColor.allCases.randomElement().map(\.rawValue) ?? "default"

    }

    static func randomAnnotations() -> RichText.Annotations {

        .init(
            bold: .random(),
            italic: .random(),
            strikethrough: .random(),
            underline: .random(),
            code: .random(),
            color: randomColor()
        )

    }

    @Test
    func testEncoding() async throws {
        let tests: [(RichText.Annotations, String)] = [
            (.init(bold: true, italic: true, strikethrough: true, underline: false, code: true, color: "brown_background"),
            """
            {"bold":true,"code":true,"color":"brown_background","italic":true,"strikethrough":true,"underline":false}
            """),

            (.init(),
            """
            {"bold":false,"code":false,"color":"default","italic":false,"strikethrough":false,"underline":false}
            """),
        ]

        for (annotations, expected) in tests {
            let encoded = try encodeToJson(annotations)
            #expect(encoded == expected)
        }
    }

    @Test
    func testDecoding() async throws {
        let tests: [(String, RichText.Annotations)] = [
            ("""
            {"bold":true,"code":true,"color":"brown_background","italic":true,"strikethrough":true,"underline":false}
            """, .init(bold: true, italic: true, strikethrough: true, underline: false, code: true, color: "brown_background")),

            ("""
            {"bold":false,"code":false,"color":"default","italic":false,"strikethrough":false,"underline":false}
            """, .init()),
        ]

        for (json, expected) in tests {
            let decoded: RichText.Annotations = try decodeFromJson(json)
            #expect(decoded == expected)
        }
    }

    @Test func endToEndCodable() throws {
        
        for _ in 0..<1000 {
            
            let base = Self.randomAnnotations()
            
            let encoded = try encodeToJson(base)
            let decoded: RichText.Annotations = try decodeFromJson(encoded)
            
            #expect(decoded == base)
            
        }
        
    }
    
}

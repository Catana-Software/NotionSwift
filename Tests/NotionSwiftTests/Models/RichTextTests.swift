import Foundation
import NotionSwift
import Testing

struct RichTextTests {

    @Test
    func testJSON() async throws {
        let tests: [(String, RichText)] = [
            ("""
            {"annotations":{"bold":true,"code":true,"color":"brown_background","italic":true,"strikethrough":true,"underline":false},
             "type":"text",
             "text":{"content":"blah blah blah"}}
            """, RichText(string: "blah blah blah", annotations: .init(bold: true, italic: true, strikethrough: true, underline: false, code: true, color: "brown_background"))),

            ("""
            {"type":"text",
             "text":{"content":"Green background","link":null},
             "annotations":{"bold":false,"italic":false,"strikethrough":false,"underline":false,"code":false,"color":"green_background"},
             "plain_text":"Green background",
             "href":null}
            """, RichText(plainText: "Green background", annotations: .init(color: "green_background")))
        ]

        for (json, expected) in tests {
            let decoded: RichText = try decodeFromJson(json)
            #expect(decoded == expected)
        }
    }

    @Test
    func endToEndCodable() throws {
        
        for _ in 0..<1000 {
            
            let annotations = RichText_AnnotationsTests.randomAnnotations()
            
            let length = Int.random(in: 0...100)
            let text = String((0...length).map { _ in "abcdefghijklmnopqrstuvwxyz,.!? ".randomElement()! })
            let domain = String((0...Int.random(in: 1...10)).map { _ in "abcdefghijklmnopqrstuvwxyz".randomElement()! })
            let href = Bool.random() ? "https://\(domain).com" : nil
            // the "string" constructor doesn't fill in the plainText field,
            // so mix it up a bit better...
            let base = Bool.random() ?
                RichText(string: text, annotations: annotations) :
                RichText(plainText: text, href: href, annotations: annotations)
            
            let encoded = try encodeToJson(base)
            let decoded: RichText = try decodeFromJson(encoded)
            #expect(decoded == base)
            
        }
        
    }
    
}

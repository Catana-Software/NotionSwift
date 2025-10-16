import Foundation
import NotionSwift
import Testing

struct Page_PropertiesTests {
    
    func makePage(properties: [Page.PropertyName: PageProperty]) -> Page {
        
        let user = PartialUser(id: .init(UUID().uuidString))
        
        let page = Page(
            id: .init(UUID().uuidString),
            createdTime: .now,
            lastEditedTime: .now,
            createdBy: user,
            lastEditedBy: user,
            icon: nil,
            cover: nil,
            parent: .workspace,
            archived: false,
            properties: properties,
            url: .temporaryDirectory
        )
        
        return page
        
    }
    
    @Test func pageWithoutTitleReturnsNil() {
        
        let properties = [
            "Not a title": PageProperty(id: .init(UUID().uuidString), type: .createdTime(.now))
        ]
        
        let page = makePage(properties: properties)
        
        let result = page.title
        
        #expect(result == nil)
        
    }
    
    @Test func pageSampleTitlePropertyMatches() throws {
        
        let page: Page = try decodeFromJson(Self.pageJSON)
        
        let result = page
            .title?
            .compactMap { text in
                
                switch text.type {
                    
                case .text(let textValue):
                    return textValue.content
                    
                default:
                    return nil
                    
                }
                
            }
            .joined()
            .lowercased()
        
        #expect(result == "bug bash")
        
    }
    
    @Test func docsSampleDecodes() throws {
        
        let result: [Page.PropertyName: PageProperty] = try decodeFromJson(Self.propertiesJSON)
        
        #expect(result.count == 1)
        
    }
    
}

extension Page_PropertiesTests {
    
    /// Sample taken from Notion Docs at
    /// https://developers.notion.com/reference/page-property-values#title
    static let propertiesJSON = """
        {
          "Title": {
            "id": "title",
            "type": "title",
            "title": [
              {
                "type": "text",
                "text": {
                  "content": "A better title for the page",
                  "link": null
                },
                "annotations": {
                  "bold": false,
                  "italic": false,
                  "strikethrough": false,
                  "underline": false,
                  "code": false,
                  "color": "default"
                },
                "plain_text": "This is also not done",
                "href": null
              }
            ]
          }
        }
        """
    
    /// Sample taken from Notion Docs at
    /// https://developers.notion.com/reference/page
    static let pageJSON = """
        {
            "object": "page",
            "id": "be633bf1-dfa0-436d-b259-571129a590e5",
            "created_time": "2022-10-24T22:54:00.000Z",
            "last_edited_time": "2023-03-08T18:25:00.000Z",
            "created_by": {
                "object": "user",
                "id": "c2f20311-9e54-4d11-8c79-7398424ae41e"
            },
            "last_edited_by": {
                "object": "user",
                "id": "9188c6a5-7381-452f-b3dc-d4865aa89bdf"
            },
            "cover": null,
            "icon": {
                "type": "emoji",
                "emoji": "🐞"
            },
            "parent": {
                "type": "data_source_id",
                "data_source_id": "a1d8501e-1ac1-43e9-a6bd-ea9fe6c8822b"
            },
            "archived": true,
            "in_trash": true,
            "properties": {
                "Due date": {
                    "id": "M%3BBw",
                    "type": "date",
                    "date": {
                        "start": "2023-02-23",
                        "end": null,
                        "time_zone": null
                    }
                },
                "Status": {
                    "id": "Z%3ClH",
                    "type": "status",
                    "status": {
                        "id": "86ddb6ec-0627-47f8-800d-b65afd28be13",
                        "name": "Not started",
                        "color": "default"
                    }
                },
                "Title": {
                    "id": "title",
                    "type": "title",
                    "title": [
                        {
                            "type": "text",
                            "text": {
                                "content": "Bug bash",
                                "link": null
                            },
                            "annotations": {
                                "bold": false,
                                "italic": false,
                                "strikethrough": false,
                                "underline": false,
                                "code": false,
                                "color": "default"
                            },
                            "plain_text": "Bug bash",
                            "href": null
                        }
                    ]
                }
            },
            "url": "https://www.notion.so/Bug-bash-be633bf1dfa0436db259571129a590e5",
                "public_url": "https://jm-testing.notion.site/p1-6df2c07bfc6b4c46815ad205d132e22d"
        }
        """
    
}

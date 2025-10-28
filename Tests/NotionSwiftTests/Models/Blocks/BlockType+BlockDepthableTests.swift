import Foundation
import NotionSwift
import Testing

@Suite("BlockType: BlockDepthable")
struct BlockType_BlockDepthableTests {
    
    @Test func noChildrenTypeReportsZero() {
        
        let blocks: [BlockType] = [
            .heading1([]),
            .heading2([]),
            .heading3([]),
            .code([]),
            .childPage(""),
            .childDatabase(""),
            .embed(url: "https://example.com", caption: []),
            .bookmark(url: "https://example.com", caption: []),
            .equation(expression: "1+1"),
            .divider,
            .breadcrumb,
            .linkToPage(.page(Page.Identifier(UUID().uuidString))),
            .unsupported(type: "unknown")
        ]
        
        for block in blocks {
            #expect(block.childrenDepth == 0)
        }
        
    }
    
    @Test func childCapableWithEmptyReturnsZero() {
        
        let childCapableBlocks: [BlockType] = [
            .paragraph([]),
            .bulletedListItem([]),
            .numberedListItem([]),
            .toDo([]),
            .toggle([]),
            .quote([]),
            .callout([])
        ]
        
        for block in childCapableBlocks {
            #expect(block.childrenDepth == 0)
        }
        
    }
    
    @Test func singleLevelChildrenReturnsOne() {
        
        let paragraph = BlockType.paragraph([])
        let block = BlockType
            .paragraph(
                .init(richText: [], children: [paragraph], color: .default)
            )
        
        #expect(block.childrenDepth == 1)
        
    }
    
    @Test func linearChainDepthCountsAllLevels() {
        
        let block: BlockType = .paragraph(
            .init(richText: [], children: [
                .paragraph(
                    .init(richText: [], children: [
                        .paragraph(
                            .init(richText: [], children: [
                                .paragraph([])
                            ], color: .default)
                        )
                    ], color: .default)
                )
            ], color: .default)
        )
        
        #expect(block.childrenDepth == 3)
        
    }
    
    @Test func branchingTakesMaxDepth() {
        
        // Left branch depth 1, right branch depth 3 => overall depth 3
        let block: BlockType = .toggle(.init(richText: [], children: [
            .paragraph([]), // depth 1 branch
            .toggle(.init(richText: [], children: [
                .paragraph(.init(richText: [], children: [
                    .paragraph([])
                ], color: .default))
            ], color: .default))
        ], color: .default))
        
        #expect(block.childrenDepth == 3)
        
    }
    
    @Test func mixedSiblingsDepthUsesDeepestPath() {
        
        // Root quote with multiple shallow siblings and one deeper subtree
        let block: BlockType = .quote(.init(richText: [], children: [
            .paragraph([]),
            .bulletedListItem([]),
            .numberedListItem([]),
            .callout(.init(richText: [], children: [
                .quote(.init(richText: [], children: [
                    .paragraph([])
                ], color: .default))
            ], color: .default))
        ], color: .default))
        
        // Deepest path: quote -> callout -> quote -> paragraph = 3
        #expect(block.childrenDepth == 3)
        
    }
    
    @Test func emptyChildrenEverywhereReturnsZero() {
        
        let block: BlockType = .toDo(.init(richText: [], color: .default, children: [
            .toDo([]),
            .toggle([]),
            .quote([])
        ]))
        
        #expect(block.childrenDepth == 1)
        
    }
    
    @Test func deeplyNestedMixedBlocks() {
        
        let block: BlockType = .callout(.init(richText: [], children: [
            .paragraph([]),
            .toggle(.init(richText: [], children: [
                .bulletedListItem(.init(richText: [], children: [
                    .numberedListItem(.init(richText: [], children: [
                        .quote(.init(richText: [], children: [
                            .paragraph([])
                        ], color: .default))
                    ], color: .default))
                ], color: .default))
            ], color: .default))
        ], color: .default))
        
        #expect(block.childrenDepth == 5)
        
    }
    
    @Test func syncedBlockReportsZero() {
        
        let block: BlockType = .syncedBlock(.reference(.init("synced")))
        
        #expect(block.childrenDepth == 0)
        
    }
    
    @Test func tableRowReportsZero() {
        
        let block: BlockType = .tableRow(.init(cells: []))
        
        #expect(block.childrenDepth == 0)
        
    }
    
    @Test func tableWithNoRowsReportsZero() {
        
        let block: BlockType = .table(
            .init(tableWidth: 0, hasColumnHeader: false, hasRowHeader: false, children: [])
        )
        
        #expect(block.childrenDepth == 0)
        
    }
    
    @Test func tableWithRowsReportsOne() {
        
        let block: BlockType = .table(
            .init(tableWidth: 2, hasColumnHeader: true, hasRowHeader: false, children: [
                .tableRow(.init(cells: [])),
                .tableRow(.init(cells: []))
            ])
        )
        
        #expect(block.childrenDepth == 1)
        
    }
    
    @Test func columnWithNoChildrenReportsZero() {
        
        let block: BlockType = .column(.init(children: []))
        
        #expect(block.childrenDepth == 0)
        
    }
    
    @Test func columnWithNestedDepthCountsLevels() {
        
        let nested: BlockType = .column(.init(children: [
            .paragraph(.init(richText: [], children: [
                .paragraph(.init(richText: [], children: [
                    .paragraph([])
                ], color: .default))
            ], color: .default))
        ]))
        
        #expect(nested.childrenDepth == 3)
        
    }
    
    @Test func columnListEmptyReportsZero() {
        
        let block: BlockType = .columnList(.init(children: []))
        
        #expect(block.childrenDepth == 0)
    }
    
    @Test func columnListWithColumnsReportsOne() {
        
        let block: BlockType = .columnList(.init(children: [
            .column(.init(children: [])),
            .column(.init(children: []))
        ]))
        
        #expect(block.childrenDepth == 1)
        
    }
    
    @Test func columnListDeepestPathWins() {
        
        // Left column shallow, right column deeper
        let block: BlockType = .columnList(.init(children: [
            .column(.init(children: [ .paragraph([]) ])),
            .column(.init(children: [
                .toggle(.init(richText: [], children: [
                    .paragraph(.init(richText: [], children: [ .paragraph([]) ], color: .default))
                ], color: .default))
            ]))
        ]))
        
        // columnList -> column -> toggle -> paragraph -> paragraph = 4
        #expect(block.childrenDepth == 4)
        
    }
    
    @Test func templateEmptyReportsZero() {
        
        let block: BlockType = .template(.init(richText: [], children: []))
        
        #expect(block.childrenDepth == 0)
        
    }
    
    @Test func templateWithNestedChildrenCountsDepth() {
        
        let block: BlockType = .template(.init(richText: [], children: [
            .paragraph(.init(richText: [], children: [
                .quote(.init(richText: [], children: [ .paragraph([]) ], color: .default))
            ], color: .default))
        ]))
        
        // template -> paragraph -> quote -> paragraph = 3
        #expect(block.childrenDepth == 3)
        
    }
    
}

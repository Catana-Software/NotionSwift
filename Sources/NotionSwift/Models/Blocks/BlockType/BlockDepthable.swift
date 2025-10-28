import Foundation

public protocol BlockDepthable {
    
    /// Direct access to nested children blocks (if any).
    var children: [BlockType]? { get }
    
    /// The depth of children for this block-like value.
    var childrenDepth: Int { get }
    
}

public extension BlockDepthable {
    
    /// Computes the maximum depth of nested child blocks beneath the current block
    ///
    /// A block with no children returns `0`. A block with direct children (and no further
    /// nesting) returns `1`. Each additional level of nesting increases the depth by 1,
    /// taking the deepest branch into account.
    ///
    /// - Returns: An integer representing how many levels of nested `BlockType` children exist
    ///   under this block.
    ///
    /// - Note: This value is derived recursively by inspecting `children` and computing
    ///   `1 + max(child.childrenDepth)`. If `children` is `nil` or empty, the depth is `0`.
    var childrenDepth: Int {
        
        guard
            let children = children, !children.isEmpty
        else { return 0 }
        
        return 1 + children.reduce(0) { max($0, $1.childrenDepth) }
        
    }
    
}

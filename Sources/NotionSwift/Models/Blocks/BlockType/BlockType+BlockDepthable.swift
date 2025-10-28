extension BlockType: BlockDepthable {
    
    /// Direct access to any nested child blocks contained within this block
    ///
    /// - Returns: An optional array of `BlockType` values representing this block's
    ///   immediate children. Returns `nil` when the block type cannot contain children
    ///   (e.g., headings, media, or other leaf nodes), and an empty array when the
    ///   block supports children but currently has none.
    ///
    /// - Note:
    ///   - This property only exposes the first level of nesting (direct children).
    ///     To compute how deep the hierarchy goes, use `childrenDepth`.
    ///   - For composite block types (e.g., lists, toggles, callouts, columns, tables),
    ///     the value is forwarded to the associated value's `children`.
    ///   - For leaf block types (e.g., headings, code, media, divider), this is `nil`.
    public var children: [BlockType]? {
        
        switch self {
            
        case .bulletedListItem(let v): return v.children
        case .callout(let v): return v.children
        case .column(let v): return v.children
        case .columnList(let v): return v.children
        case .numberedListItem(let v): return v.children
        case .paragraph(let v): return v.children
        case .quote(let v): return v.children
        case .syncedBlock: return nil
        case .table(let v): return v.children
        case .template(let v): return v.children
        case .toDo(let v): return v.children
        case .toggle(let v): return v.children
            
        case .audio, .bookmark, .breadcrumb,
                .childDatabase, .childPage, .code,
                .divider, .embed, .equation, .file,
                .heading1, .heading2, .heading3,
                .image, .linkToPage, .pdf,
                .tableOfContents, .tableRow, .unsupported,
                .video: return nil
            
        }
        
    }
    
}

import Foundation

extension Page {
    
    /// The page's title as an array of rich text segments.
    ///
    /// Iterates over the page's `properties` and returns the value of the first
    /// property whose type is `.title`, preserving the rich text segments as
    /// provided by the source. If the page has no title property, this returns `nil`
    ///
    /// - Returns: An optional array of `RichText` representing the page title.
    public var title: [RichText]? {
        
        for value in properties.values {
            
            switch value.type {
                
            case .title(let richText):
                return richText
             
            default:
                break
                
            }
            
        }
        
        return nil
        
    }
    
}

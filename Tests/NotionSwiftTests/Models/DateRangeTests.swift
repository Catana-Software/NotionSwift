import Foundation
import NotionSwift
import Testing

struct DateRangeTests {
    
    @Test func equality() throws {
        
        let a = DateValue
            .dateAndTime(buildTimeDate(day: 10, month: 11, year: 2021, hour: 23, min: 22, sec: 45))
        
        let b = DateValue
            .dateAndTime(buildTimeDate(day: 10, month: 11, year: 2021, hour: 23, min: 23, sec: 45))
        
        let startAndEnd = DateRange(start: a, end: b)
        let noEnd = DateRange(start: a, end: nil)
        
        #expect(startAndEnd == DateRange(start: a, end: b))
        #expect(startAndEnd != noEnd)
        
    }
    
}

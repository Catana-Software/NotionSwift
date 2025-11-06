//
//  Created by Wojciech Chojnacki on 02/06/2021.
//

import Foundation

public struct DatabasePropertyFilter: Sendable {
    public let property: String
    public let filterType: PropertyType
}

extension DatabasePropertyFilter {
    public enum PropertyType: Sendable {
        case title(TextCondition)
        case richText(TextCondition)
        case url(TextCondition)
        case email(TextCondition)
        case phoneNumber(TextCondition)
        case number(NumberCondition)
        case checkbox(CheckboxCondition)
        case select(SimpleGenericCondition<String>)
        case multiSelect(SimpleGenericCondition<String>)
        case date(DateCondition)
        case createdTime(DateCondition)
        case lastEditedTime(DateCondition)
        case dateBy(SimpleGenericCondition<LowercaseUUID>)
        case createdBy(SimpleGenericCondition<LowercaseUUID>)
        case lastEditedBy(SimpleGenericCondition<LowercaseUUID>)
        case files(FilesCondition)
        case relation(SimpleGenericCondition<LowercaseUUID>)
        case formula(FormulaCondition)
        case status(StatusCondition)
    }
}

extension DatabasePropertyFilter {
    public enum FormulaCondition: Sendable {
        case string(TextCondition)
        case checkbox(CheckboxCondition)
        case number(NumberCondition)
        case date(DateCondition)
    }
}

extension DatabasePropertyFilter {
    public enum FilesCondition: Sendable {
        case isEmpty
        case isNotEmpty
    }
}

extension DatabasePropertyFilter {
    public enum DateCondition: Sendable {
        case equals(Date)
        case before(Date)
        case after(Date)
        case onOrBefore(Date)
        case isEmpty
        case isNotEmpty
        case onOrAfter(Date)
        case pastWeek
        case pastMonth
        case pastYear
        case thisWeek
        case nextWeek
        case nextMonth
        case nextYear
    }
}

extension DatabasePropertyFilter {
    public enum SimpleGenericCondition<T: Encodable & Sendable>: Sendable where T: Sendable {
        case contains(T)
        case doesNotContain(T)
        case isEmpty
        case isNotEmpty
    }
}

extension DatabasePropertyFilter {
    public enum CheckboxCondition: Sendable {
        case equals(Bool)
        case doesNotEqual(Bool)
    }
}

extension DatabasePropertyFilter {
    public enum NumberCondition: Sendable {
        case equals(Double)
        case doesNotEqual(Double)
        case greaterThan(Double)
        case lessThan(Double)
        case greaterThanOrEqualTo(Double)
        case lessThanOrEqualTo(Double)
        case isEmpty
        case isNotEmpty
    }
}

extension DatabasePropertyFilter {
    public enum TextCondition: Sendable {
        case equals(String)
        case doesNotEqual(String)
        case contains(String)
        case doesNotContain(String)
        case startsWith(String)
        case endsWith(String)
        case isEmpty
        case isNotEmpty
    }
}

extension DatabasePropertyFilter {
    public enum StatusCondition: Sendable {
        case equals(String)
        case doesNotEqual(String)
        case isEmpty
        case isNotEmpty
    }
}


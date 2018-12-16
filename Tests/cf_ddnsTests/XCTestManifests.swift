import XCTest

#if !os(macOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(cf_ddnsTests.allTests),
    ]
}
#endif
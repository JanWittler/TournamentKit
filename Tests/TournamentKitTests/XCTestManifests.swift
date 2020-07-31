import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TournamentKitTests.allTests),
        testCase(TournamentKitWrongResultsTests.allTests)
    ]
}
#endif

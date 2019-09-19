import XCTest
@testable import Counter

final class CounterTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Counter().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

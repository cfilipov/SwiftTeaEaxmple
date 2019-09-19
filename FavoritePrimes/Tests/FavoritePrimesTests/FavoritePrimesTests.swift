import XCTest
@testable import FavoritePrimes

final class FavoritePrimesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FavoritePrimes().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

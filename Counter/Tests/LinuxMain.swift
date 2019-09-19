import XCTest

import CounterTests

var tests = [XCTestCaseEntry]()
tests += CounterTests.allTests()
XCTMain(tests)

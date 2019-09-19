import XCTest

import SequenialSideEffectsTests

var tests = [XCTestCaseEntry]()
tests += SequenialSideEffectsTests.allTests()
XCTMain(tests)

/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import QuickLayoutCore
import XCTest

final class FuzzyComparisonTests: XCTestCase {

  func testFuzzyComparisons() {

    XCTAssertEqual(Fuzzy.compare(58.666666666666664, greaterThan: 58.66666666666666), false)
    XCTAssertEqual(Fuzzy.compare(83.66666666666667, greaterThan: 83.66666666666666), false)
    XCTAssertEqual(Fuzzy.compare(83.66666666666667, greaterThan: 83.66666666666666), false)

    XCTAssertEqual(Fuzzy.compare(58.666666666666664, equalTo: 58.66666666666666), true)
    XCTAssertEqual(Fuzzy.compare(83.66666666666667, equalTo: 83.66666666666666), true)
    XCTAssertEqual(Fuzzy.compare(83.66666666666667, equalTo: 83.66666666666666), true)

    // Test isEqual
    XCTAssertEqual(Fuzzy.compare(1.0, equalTo: 1.0), true)
    XCTAssertEqual(Fuzzy.compare(1.0, equalTo: 1.000001), true)
    XCTAssertEqual(Fuzzy.compare(1.0, equalTo: 2.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, equalTo: Double.nan), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, equalTo: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, equalTo: Double.infinity), false)
    XCTAssertEqual(Fuzzy.compare(Double.infinity, equalTo: Double.infinity), true)
    XCTAssertEqual(Fuzzy.compare(Double.infinity, equalTo: -Double.infinity), false)
    XCTAssertEqual(Fuzzy.compare(-Double.infinity, equalTo: Double.infinity), false)
    XCTAssertEqual(Fuzzy.compare(-Double.infinity, equalTo: -Double.infinity), true)
    XCTAssertEqual(Fuzzy.compare(0.0, equalTo: -0.0), true)

    // Test isLessThan
    XCTAssertEqual(Fuzzy.compare(1.0, lessThan: 2.0), true)
    XCTAssertEqual(Fuzzy.compare(2.0, lessThan: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(1.0, lessThan: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, lessThan: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.infinity, lessThan: 1.0), false)

    // Test isGreaterThan
    XCTAssertEqual(Fuzzy.compare(2.0, greaterThan: 1.0), true)
    XCTAssertEqual(Fuzzy.compare(1.0, greaterThan: 2.0), false)
    XCTAssertEqual(Fuzzy.compare(1.0, greaterThan: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, greaterThan: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(-Double.infinity, greaterThan: 1.0), false)

    XCTAssertEqual(Fuzzy.compare(Double.infinity, greaterThan: Double.infinity), false)
    XCTAssertEqual(Fuzzy.compare(Double.infinity, greaterThan: -Double.infinity), true)
    XCTAssertEqual(Fuzzy.compare(-Double.infinity, greaterThan: Double.infinity), false)
    XCTAssertEqual(Fuzzy.compare(-Double.infinity, greaterThan: -Double.infinity), false)

    XCTAssertEqual(Fuzzy.compare(Double.nan, greaterThan: Double.infinity), false)
    XCTAssertEqual(Fuzzy.compare(Double.infinity, greaterThan: Double.nan), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, greaterThan: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(10, greaterThan: Double.nan), false)

    // Test isLessThanOrEqual
    XCTAssertEqual(Fuzzy.compare(1.0, lessThanOrEqual: 2.0), true)
    XCTAssertEqual(Fuzzy.compare(1.0, lessThanOrEqual: 1.0), true)
    XCTAssertEqual(Fuzzy.compare(2.0, lessThanOrEqual: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, lessThanOrEqual: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.infinity, lessThanOrEqual: 1.0), false)

    // Test isGreaterThanOrEqual
    XCTAssertEqual(Fuzzy.compare(2.0, greaterThanOrEqual: 1.0), true)
    XCTAssertEqual(Fuzzy.compare(1.0, greaterThanOrEqual: 1.0), true)
    XCTAssertEqual(Fuzzy.compare(1.0, greaterThanOrEqual: 2.0), false)
    XCTAssertEqual(Fuzzy.compare(Double.nan, greaterThanOrEqual: 1.0), false)
    XCTAssertEqual(Fuzzy.compare(-Double.infinity, greaterThanOrEqual: 1.0), false)
  }

  func testTolerance() {
    XCTAssertEqual(Fuzzy.compare(1.0001, equalTo: 1.0, tolerance: 0.0001), true)
    XCTAssertEqual(Fuzzy.compare(1.00011, equalTo: 1.0, tolerance: 0.0001), false)
    XCTAssertEqual(Fuzzy.compare(1.0, equalTo: 1.0001, tolerance: 0.0001), true)
    XCTAssertEqual(Fuzzy.compare(1.0, equalTo: 1.00011, tolerance: 0.0001), false)
  }
}

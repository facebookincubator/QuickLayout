/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import QuickLayoutCore
import XCTest

private struct TestData {
  let screenScale: CGFloat
  let input: CGFloat
  let output: CGFloat
}

@MainActor
class PixelGridRoundingTests: XCTestCase {
  func test3_0() {
    let testTada = [
      TestData(screenScale: 3.0, input: 0.99, output: 1.0),
      TestData(screenScale: 3.0, input: 0.0, output: 0.0),
      TestData(screenScale: 3.0, input: 0.49999999, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.333333333, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.6666666666, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.99999999999, output: 1.0),
      TestData(screenScale: 3.0, input: 0.0333333333333, output: 0.0),

      TestData(screenScale: 3.0, input: 0.00, output: 0.0),

      TestData(screenScale: 3.0, input: 0.11, output: 0.0),
      TestData(screenScale: 3.0, input: 0.12, output: 0.0),
      TestData(screenScale: 3.0, input: 0.13, output: 0.0),
      TestData(screenScale: 3.0, input: 0.14, output: 0.0),
      TestData(screenScale: 3.0, input: 0.15, output: 0.0),
      TestData(screenScale: 3.0, input: 0.16, output: 0.0),
      TestData(screenScale: 3.0, input: 0.17, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.18, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.19, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.20, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.30, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.40, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.41, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.42, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.43, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.44, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.45, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.46, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.47, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.48, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.49, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.50, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.60, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.70, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.80, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.81, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.82, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.83, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.84, output: 1.0),
      TestData(screenScale: 3.0, input: 0.85, output: 1.0),
      TestData(screenScale: 3.0, input: 0.86, output: 1.0),
      TestData(screenScale: 3.0, input: 0.87, output: 1.0),
      TestData(screenScale: 3.0, input: 0.88, output: 1.0),
      TestData(screenScale: 3.0, input: 0.89, output: 1.0),
      TestData(screenScale: 3.0, input: 0.90, output: 1.0),
      TestData(screenScale: 3.0, input: 1.00, output: 1.0),
    ]

    for testData in testTada {
      for base in 0...10 {
        let input = CGFloat(base) + testData.input
        let output = CGFloat(base) + testData.output
        let result = roundPositionToPixelGrid(input, screenScale: testData.screenScale)
        XCTAssertEqual(result, output, "input \(input)")

        let result2 = roundPositionToPixelGrid(-input, screenScale: testData.screenScale)
        XCTAssertEqual(result2, -output, "input \(-input)")
      }
    }
  }

  func test3_0_SizeRounding() {
    let testTada = [
      TestData(screenScale: 3.0, input: 0.99, output: 1.0),
      TestData(screenScale: 3.0, input: 0.0, output: 0.0),
      TestData(screenScale: 3.0, input: 0.49999999, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.333333333, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.6666666666, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.99999999999, output: 1.0),
      TestData(screenScale: 3.0, input: 0.0333333333333, output: 0.3333333333333333),

      TestData(screenScale: 3.0, input: 0.00, output: 0.0),

      TestData(screenScale: 3.0, input: 0.11, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.12, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.13, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.14, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.15, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.16, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.17, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.18, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.19, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.20, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.30, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.31, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.32, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.33, output: 0.3333333333333333),
      TestData(screenScale: 3.0, input: 0.34, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.35, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.36, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.37, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.38, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.39, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.40, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.41, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.42, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.43, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.44, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.45, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.46, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.47, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.48, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.49, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.50, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.60, output: 0.6666666666666666),
      TestData(screenScale: 3.0, input: 0.70, output: 1.0),
      TestData(screenScale: 3.0, input: 0.80, output: 1.0),
      TestData(screenScale: 3.0, input: 0.81, output: 1.0),
      TestData(screenScale: 3.0, input: 0.82, output: 1.0),
      TestData(screenScale: 3.0, input: 0.83, output: 1.0),
      TestData(screenScale: 3.0, input: 0.84, output: 1.0),
      TestData(screenScale: 3.0, input: 0.85, output: 1.0),
      TestData(screenScale: 3.0, input: 0.86, output: 1.0),
      TestData(screenScale: 3.0, input: 0.87, output: 1.0),
      TestData(screenScale: 3.0, input: 0.88, output: 1.0),
      TestData(screenScale: 3.0, input: 0.89, output: 1.0),
      TestData(screenScale: 3.0, input: 0.90, output: 1.0),
      TestData(screenScale: 3.0, input: 1.00, output: 1.0),
    ]

    for testData in testTada {
      for base in 0...10 {
        let input = CGFloat(base) + testData.input
        let output = CGFloat(base) + testData.output
        let result = roundSizeToPixelGrid(input, screenScale: testData.screenScale)
        XCTAssertEqual(result, output, "input \(input)")

        let result2 = roundSizeToPixelGrid(-input, screenScale: testData.screenScale)
        XCTAssertEqual(result2, -output, "input \(-input)")
      }
    }
  }

  func test2_0() {
    let testTada = [
      TestData(screenScale: 2.0, input: 0.99, output: 1.0),
      TestData(screenScale: 2.0, input: 0.0, output: 0.0),
      TestData(screenScale: 2.0, input: 0.49999999, output: 0.5),
      TestData(screenScale: 2.0, input: 0.75, output: 1.0),
      TestData(screenScale: 2.0, input: 0.74, output: 0.5),
      TestData(screenScale: 2.0, input: 0.25, output: 0.5),
      TestData(screenScale: 2.0, input: 0.56666666666, output: 0.5),
      TestData(screenScale: 2.0, input: 0.57777777777, output: 0.5),
      TestData(screenScale: 2.0, input: 0.99219191, output: 1.0),
      TestData(screenScale: 2.0, input: 0.99999999, output: 1.0),

      TestData(screenScale: 2.0, input: 0.0, output: 0.0),
      TestData(screenScale: 2.0, input: 0.1, output: 0.0),
      TestData(screenScale: 2.0, input: 0.2, output: 0.0),
      TestData(screenScale: 2.0, input: 0.24999, output: 0.5),
      TestData(screenScale: 2.0, input: 0.25, output: 0.5),
      TestData(screenScale: 2.0, input: 0.3, output: 0.5),
      TestData(screenScale: 2.0, input: 0.4, output: 0.5),
      TestData(screenScale: 2.0, input: 0.5, output: 0.5),
      TestData(screenScale: 2.0, input: 0.6, output: 0.5),
      TestData(screenScale: 2.0, input: 0.7, output: 0.5),
      TestData(screenScale: 2.0, input: 0.8, output: 1.0),
      TestData(screenScale: 2.0, input: 0.9, output: 1.0),
      TestData(screenScale: 2.0, input: 1.0, output: 1.0),
    ]

    for testData in testTada {
      for base in 0...10 {
        let input = CGFloat(base) + testData.input
        let output = CGFloat(base) + testData.output
        let result = roundPositionToPixelGrid(input, screenScale: testData.screenScale)
        XCTAssertEqual(result, output, "input \(input)")

        let result2 = roundPositionToPixelGrid(-input, screenScale: testData.screenScale)
        XCTAssertEqual(result2, -output, "input \(-input)")
      }
    }
  }

  func test2_0_SizeRounding() {
    let testTada = [
      TestData(screenScale: 2.0, input: 0.99, output: 1.0),
      TestData(screenScale: 2.0, input: 0.0, output: 0.0),
      TestData(screenScale: 2.0, input: 0.49999999, output: 0.5),
      TestData(screenScale: 2.0, input: 0.75, output: 1.0),
      TestData(screenScale: 2.0, input: 0.74, output: 1.0),
      TestData(screenScale: 2.0, input: 0.25, output: 0.5),
      TestData(screenScale: 2.0, input: 0.56666666666, output: 1.0),
      TestData(screenScale: 2.0, input: 0.57777777777, output: 1.0),
      TestData(screenScale: 2.0, input: 0.99219191, output: 1.0),
      TestData(screenScale: 2.0, input: 0.99999999, output: 1.0),

      TestData(screenScale: 2.0, input: 0.0, output: 0.0),
      TestData(screenScale: 2.0, input: 0.1, output: 0.5),
      TestData(screenScale: 2.0, input: 0.2, output: 0.5),
      TestData(screenScale: 2.0, input: 0.24999, output: 0.5),
      TestData(screenScale: 2.0, input: 0.25, output: 0.5),
      TestData(screenScale: 2.0, input: 0.3, output: 0.5),
      TestData(screenScale: 2.0, input: 0.4, output: 0.5),
      TestData(screenScale: 2.0, input: 0.5, output: 0.5),
      TestData(screenScale: 2.0, input: 0.6, output: 1.0),
      TestData(screenScale: 2.0, input: 0.7, output: 1.0),
      TestData(screenScale: 2.0, input: 0.8, output: 1.0),
      TestData(screenScale: 2.0, input: 0.9, output: 1.0),
      TestData(screenScale: 2.0, input: 1.0, output: 1.0),
    ]

    for testData in testTada {
      for base in 0...10 {
        let input = CGFloat(base) + testData.input
        let output = CGFloat(base) + testData.output
        let result = roundSizeToPixelGrid(input, screenScale: testData.screenScale)
        XCTAssertEqual(result, output, "input \(input)")

        let result2 = roundSizeToPixelGrid(-input, screenScale: testData.screenScale)
        XCTAssertEqual(result2, -output, "input \(-input)")
      }
    }
  }

  func testSpecialRoundingLogic() {
    var result: CGFloat = 0.0

    result = roundPositionToPixelGrid(1.249999, screenScale: 2.0)
    XCTAssertEqual(result, 1.5)

    result = roundPositionToPixelGrid(-1.249999, screenScale: 2.0)
    XCTAssertEqual(result, -1.5)
  }

  func testNegativeValues() {
    var result: CGFloat = 0.0
    result = roundPositionToPixelGrid(-0.4, screenScale: 2.0)
    XCTAssertEqual(result, -0.5)

    result = roundPositionToPixelGrid(-1.56666666666, screenScale: 2.0)
    XCTAssertEqual(result, -1.5)

    result = roundPositionToPixelGrid(-2.00000, screenScale: 3.0)
    XCTAssertEqual(result, -2.0)
  }

  func testInvalidValues() {
    var result: CGFloat = 0.0

    result = roundPositionToPixelGrid(CGFloat.nan, screenScale: 2.0)
    XCTAssertTrue(result.isNaN)

    result = roundPositionToPixelGrid(CGFloat.greatestFiniteMagnitude - 10, screenScale: 2.0)
    XCTAssertEqual(result, CGFloat.greatestFiniteMagnitude - 10)

    result = roundPositionToPixelGrid(CGFloat.greatestFiniteMagnitude, screenScale: 2.0)
    XCTAssertEqual(result, CGFloat.greatestFiniteMagnitude)

    result = roundPositionToPixelGrid(CGFloat.infinity, screenScale: 2.0)
    XCTAssertEqual(result, .infinity)

    result = roundPositionToPixelGrid(CGFloat.nan, screenScale: 3.0)
    XCTAssertTrue(result.isNaN)

    result = roundPositionToPixelGrid(CGFloat.greatestFiniteMagnitude - 10, screenScale: 3.0)
    XCTAssertEqual(result, CGFloat.greatestFiniteMagnitude - 10)

    result = roundPositionToPixelGrid(CGFloat.infinity, screenScale: 3.0)
    XCTAssertEqual(result, .infinity)
  }
}

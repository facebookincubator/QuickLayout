/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// Disabled during swift-format 6.3 rollout, feel free to remove:
// swift-format-ignore-file: OrderedImports

import XCTest

@testable import QuickLayoutBridge
@testable import QuickLayoutBridgeTestUsage

@MainActor
final class BodyCreationTests: XCTestCase {

  func testMultipleSizeThatFitsWithoutChangingProps() {
    let view = BodyCreationTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    let size = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size.width, 33)
    XCTAssertEqual(size.height, 33)
    XCTAssertEqual(view.bodyCounter, 1)

    let size2 = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size2.width, 33)
    XCTAssertEqual(size2.height, 33)
    XCTAssertEqual(view.bodyCounter, 2)
  }

  func testBodyCacheReset() {
    let view = BodyCreationTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    let size = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size.width, 33)
    XCTAssertEqual(size.height, 33)
    XCTAssertEqual(view.bodyCounter, 1)

    view.setNeedsLayout()
    let size2 = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size2.width, 33)
    XCTAssertEqual(size2.height, 33)
    XCTAssertEqual(view.bodyCounter, 2)
  }

  func testMultipleSizeThatFitsAndChangingProps() {
    let view = BodyCreationTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    let size = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size.width, 33)
    XCTAssertEqual(size.height, 33)
    XCTAssertEqual(view.bodyCounter, 1)

    view.frameSize = CGSize(width: 34, height: 33)
    let size2 = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size2.width, 34)
    XCTAssertEqual(size2.height, 33)
    XCTAssertEqual(view.bodyCounter, 2)
  }

  func testMultipleLayoutSubviewsWithoutChangingProps() {
    let view = BodyCreationTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    view.layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 1)

    view.layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 2)
  }

  func testMultipleLayoutSubviewsWithChangingProps() {
    let view = BodyCreationTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    view.layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 1)

    view.frameSize = CGSize(width: 34, height: 33)
    view.layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 2)
  }

  func testMultipleFlexibilityForAxisCalls() {
    let view = BodyCreationTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    _ = view.quick_flexibility(for: .horizontal)
    XCTAssertEqual(view.bodyCounter, 1)

    _ = view.quick_flexibility(for: .horizontal)
    XCTAssertEqual(view.bodyCounter, 2)
  }
}

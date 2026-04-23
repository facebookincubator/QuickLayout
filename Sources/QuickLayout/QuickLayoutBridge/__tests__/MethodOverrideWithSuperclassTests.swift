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
final class MethodOverrideWithSuperclassTests: XCTestCase {
  func testMultipleLayoutSubviewsWithoutChangingProps() {
    let view = MethodOverrideWithSuperclassTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    (view as UIView).layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.layoutSubviewsCounter, 1)
    XCTAssertEqual(view.baseLayoutSubviewsCounter, 1)

    (view as UIView).layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 2)
    XCTAssertEqual(view.layoutSubviewsCounter, 2)
    XCTAssertEqual(view.baseLayoutSubviewsCounter, 2)
  }

  func testMultipleLayoutSubviewsWithChangingProps() {
    let view = MethodOverrideWithSuperclassTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    (view as UIView).layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.layoutSubviewsCounter, 1)
    XCTAssertEqual(view.baseLayoutSubviewsCounter, 1)

    view.frameSize = CGSize(width: 33, height: 34)

    (view as UIView).layoutSubviews()
    XCTAssertEqual(view.bodyCounter, 2)
    XCTAssertEqual(view.layoutSubviewsCounter, 2)
    XCTAssertEqual(view.baseLayoutSubviewsCounter, 2)
  }

  func testMultipleSizeThatFitsWithoutChangingProps() {
    let view = MethodOverrideWithSuperclassTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    let size = (view as UIView).sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size.width, 100)
    XCTAssertEqual(size.height, 100)
    XCTAssertEqual(view.sizeThatFitsCounter, 1)
    XCTAssertEqual(view.baseSizeThatFitsCounter, 1)
    XCTAssertEqual(view.bodyCounter, 0)

    let size2 = (view as UIView).sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size2.width, 100)
    XCTAssertEqual(size2.height, 100)
    XCTAssertEqual(view.sizeThatFitsCounter, 2)
    XCTAssertEqual(view.baseSizeThatFitsCounter, 2)
    XCTAssertEqual(view.bodyCounter, 0)
  }

  func testMultipleSizeThatFitsAndChangingProps() {
    let view = MethodOverrideWithSuperclassTestView()
    view.frameSize = CGSize(width: 33, height: 33)
    let size = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size.width, 100)
    XCTAssertEqual(size.height, 100)
    XCTAssertEqual(view.sizeThatFitsCounter, 1)
    XCTAssertEqual(view.baseSizeThatFitsCounter, 1)
    XCTAssertEqual(view.bodyCounter, 0)

    view.frameSize = CGSize(width: 34, height: 33)
    let size2 = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size2.width, 100)
    XCTAssertEqual(size2.height, 100)
    XCTAssertEqual(view.sizeThatFitsCounter, 2)
    XCTAssertEqual(view.baseSizeThatFitsCounter, 2)
    XCTAssertEqual(view.bodyCounter, 0)
  }
}

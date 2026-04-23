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
final class BodyCreationWithNestedViewsTests: XCTestCase {

  func testMultipleSizeThatFitsWithoutChangingProps() {
    let view = BodyCreationWithNestedViewsTestView()
    view.childView1.leafView.frameSize = CGSize(width: 33, height: 33)
    view.childView2.leafView.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    _ = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.childView1.bodyCounter, 2)
    XCTAssertEqual(view.childView2.bodyCounter, 2)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 1)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 1)

    _ = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(view.bodyCounter, 2)
    XCTAssertEqual(view.childView1.bodyCounter, 4)
    XCTAssertEqual(view.childView2.bodyCounter, 4)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 2)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 2)
  }

  func testMultipleSizeThatFitsAndChangingProps() {
    let view = BodyCreationWithNestedViewsTestView()
    view.childView1.leafView.frameSize = CGSize(width: 33, height: 33)
    view.childView2.leafView.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    _ = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.childView1.bodyCounter, 2)
    XCTAssertEqual(view.childView2.bodyCounter, 2)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 1)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 1)

    view.property += 1
    view.childView1.property += 1
    view.childView2.property += 1

    _ = view.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(view.bodyCounter, 2)
    XCTAssertEqual(view.childView1.bodyCounter, 4)
    XCTAssertEqual(view.childView2.bodyCounter, 4)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 2)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 2)
  }

  func testMultipleLayoutSubviewsWithoutChangingProps() {
    let view = BodyCreationWithNestedViewsTestView()
    view.childView1.leafView.frameSize = CGSize(width: 33, height: 33)
    view.childView2.leafView.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    view.layoutIfNeeded()
    view.childView1.layoutIfNeeded()
    view.childView2.layoutIfNeeded()
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.childView1.bodyCounter, 3)
    XCTAssertEqual(view.childView2.bodyCounter, 3)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 2)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 2)

    view.layoutIfNeeded()
    view.childView1.layoutIfNeeded()
    view.childView2.layoutIfNeeded()
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.childView1.bodyCounter, 3)
    XCTAssertEqual(view.childView2.bodyCounter, 3)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 2)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 2)
  }

  func testMultipleLayoutSubviewsWithChangingProps() {
    let view = BodyCreationWithNestedViewsTestView()
    view.childView1.leafView.frameSize = CGSize(width: 33, height: 33)
    view.childView2.leafView.frameSize = CGSize(width: 33, height: 33)
    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

    view.layoutIfNeeded()
    view.childView1.layoutIfNeeded()
    view.childView2.layoutIfNeeded()
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.childView1.bodyCounter, 3)
    XCTAssertEqual(view.childView2.bodyCounter, 3)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 2)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 2)

    view.property += 1
    view.childView1.property += 1
    view.childView2.property += 1

    view.layoutIfNeeded()
    view.childView1.layoutIfNeeded()
    view.childView2.layoutIfNeeded()
    XCTAssertEqual(view.bodyCounter, 2)
    XCTAssertEqual(view.childView1.bodyCounter, 6)
    XCTAssertEqual(view.childView2.bodyCounter, 6)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 4)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 4)
  }

  func testMultipleFlexibilityForAxisCalls() {
    let view = BodyCreationWithNestedViewsTestView()
    view.childView1.leafView.frameSize = CGSize(width: 33, height: 33)
    view.childView2.leafView.frameSize = CGSize(width: 33, height: 33)

    view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    _ = view.quick_flexibility(for: .horizontal)
    XCTAssertEqual(view.bodyCounter, 1)
    XCTAssertEqual(view.childView1.bodyCounter, 1)
    XCTAssertEqual(view.childView2.bodyCounter, 1)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 0)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 0)

    _ = view.quick_flexibility(for: .horizontal)
    XCTAssertEqual(view.bodyCounter, 2)
    XCTAssertEqual(view.childView1.bodyCounter, 2)
    XCTAssertEqual(view.childView2.bodyCounter, 2)
    XCTAssertEqual(view.childView1.leafView.sizeThatFitsCounter, 0)
    XCTAssertEqual(view.childView2.leafView.sizeThatFitsCounter, 0)
  }
}

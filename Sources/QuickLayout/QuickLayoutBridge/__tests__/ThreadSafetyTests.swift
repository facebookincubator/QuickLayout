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
@testable @preconcurrency import QuickLayoutCore

@MainActor
class ThreadSafetyTests: XCTestCase {

  func testSpacerInASingleStack() {
    let layout1 = HStack {
      Spacer(10)
    }
    let size1 = layout1.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size1.height, 0)
    XCTAssertEqual(size1.width, 10)

    let layout2 = VStack {
      Spacer(10)
    }
    let size2 = layout2.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size2.height, 10)
    XCTAssertEqual(size2.width, 0)
  }

  func testSpacerInANestedStacks() {
    let layout1 = VStack {
      HStack {
        Spacer(10)
      }
    }
    let size1 = layout1.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size1.height, 0)
    XCTAssertEqual(size1.width, 10)

    let layout2 = HStack {
      VStack {
        Spacer(10)
      }
    }
    let size2 = layout2.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size2.height, 10)
    XCTAssertEqual(size2.width, 0)
  }

  func testNestedStacks() {
    let element1 = TestElement()
    let element2 = TestElement()
    let element3 = TestElement()
    let element4 = TestElement()

    let layout1 =
      HStack {
        element1
        VStack {
          element2
          HStack {
            element3
            VStack {
              element4
            }
          }
        }
      }

    let size1 = layout1.sizeThatFits(CGSize(width: 100, height: 100))
    XCTAssertEqual(size1.height, 0)
    XCTAssertEqual(size1.width, 0)
    XCTAssertEqual(element1.layoutMainAxis, [.horizontal])
    XCTAssertEqual(element1.flexibilityMainAxis, [.horizontal])
    XCTAssertEqual(element2.layoutMainAxis, [.vertical])
    XCTAssertEqual(element2.flexibilityMainAxis, [.vertical])
    XCTAssertEqual(element3.layoutMainAxis, [.horizontal])
    XCTAssertEqual(element3.flexibilityMainAxis, [.horizontal])
    XCTAssertEqual(element4.layoutMainAxis, [.vertical])
    XCTAssertEqual(element4.flexibilityMainAxis, [.vertical])
  }

  func testNestedStacksOnBackgroundQueue() {
    let element1 = TestElement()
    let element2 = TestElement()
    let element3 = TestElement()
    let element4 = TestElement()
    let layout1 =
      HStack {
        element1
        VStack {
          element2
          HStack {
            element3
            VStack {
              element4
            }
          }
        }
      }

    let expectation = XCTestExpectation(description: "Layout on background queue")
    let queue = DispatchQueue(label: "com.quick_layout.test_queue")
    queue.async {
      _ = layout1.sizeThatFits(CGSize(width: 100, height: 100))
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 15.0)

    XCTAssertEqual(element1.layoutMainAxis, [.horizontal])
    XCTAssertEqual(element1.flexibilityMainAxis, [.horizontal])
    XCTAssertEqual(element2.layoutMainAxis, [.vertical])
    XCTAssertEqual(element2.flexibilityMainAxis, [.vertical])
    XCTAssertEqual(element3.layoutMainAxis, [.horizontal])
    XCTAssertEqual(element3.flexibilityMainAxis, [.horizontal])
    XCTAssertEqual(element4.layoutMainAxis, [.vertical])
    XCTAssertEqual(element4.flexibilityMainAxis, [.vertical])
  }
}

private class TestElement: Element {

  var layoutMainAxis: Set<Axis> = []
  var flexibilityMainAxis: Set<Axis> = []

  func quickInternal_isSpacer() -> Bool {
    return true
  }

  func quick_flexibility(for axis: Axis) -> Flexibility {
    let mainAxis = LayoutContext.latestMainAxis
    flexibilityMainAxis.insert(mainAxis)
    return .fixedSize
  }

  func quick_layoutPriority() -> CGFloat {
    0
  }

  func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    let mainAxis = LayoutContext.latestMainAxis
    layoutMainAxis.insert(mainAxis)
    return LayoutNode(view: nil, dimensions: ElementDimensions(CGSize.zero))
  }

  func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    // no-op
  }
}

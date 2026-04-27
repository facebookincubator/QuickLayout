/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import FBTestImageGenerator
@testable import QuickLayoutBridge
@testable import QuickLayoutCore

@MainActor
class HStackRTLServerSnapshotTests: FBServerSnapshotTestCase {

  func testWithThreeViews() {
    let view1 = UIView()
    view1.backgroundColor = ColorPallete.blue

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.yellow

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.red

    let layout = HStack {
      view1
        .frame(width: 100, height: 100)
      view2
        .frame(width: 80, height: 80)
      view3
        .frame(width: 40, height: 40)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 300, height: 300)),
      layoutDirection: .rightToLeft
    )
  }

  func testWithThreeViewsAndSpacing() {
    let view1 = UIView()
    view1.backgroundColor = ColorPallete.blue

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.yellow

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.red

    let layout = HStack(spacing: 10) {
      view1
        .frame(width: 100, height: 100)
      view2
        .frame(width: 80, height: 80)
      view3
        .frame(width: 40, height: 40)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 300, height: 300)),
      layoutDirection: .rightToLeft
    )
  }

  func testWithThreeViewsAndSpacers() {
    let view1 = UIView()
    view1.backgroundColor = ColorPallete.blue

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.yellow

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.red

    let layout = HStack {
      view1
        .frame(width: 100, height: 100)
      Spacer(40)
      view2
        .frame(width: 80, height: 80)
      Spacer(10)
      view3
        .frame(width: 40, height: 40)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 300, height: 300)),
      layoutDirection: .rightToLeft
    )
  }

  func testWithOneViewAndSpacerAfter() {
    let view1 = UIView()
    view1.backgroundColor = ColorPallete.blue

    let layout = HStack(spacing: 10) {
      view1
        .frame(width: 100, height: 100)
      Spacer(40)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 300, height: 300)),
      layoutDirection: .rightToLeft
    )
  }

  func testWithOneViewAndSpacerBefore() {
    let view1 = UIView()
    view1.backgroundColor = ColorPallete.blue

    let layout = HStack(spacing: 10) {
      Spacer(40)
      view1
        .frame(width: 100, height: 100)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 300, height: 300)),
      layoutDirection: .rightToLeft
    )
  }

  func testWithSingleSpacer() {
    let view1 = UIView()
    view1.backgroundColor = ColorPallete.blue

    let layout = HStack(spacing: 10) {
      Spacer(40)
    }

    takeSnapshot(
      with: layout,
      in: .exact(CGSize(width: 100, height: 100)),
      layoutDirection: .rightToLeft
    )
  }
}

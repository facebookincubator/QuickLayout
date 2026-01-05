/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import FBTestImageGenerator
import QuickLayoutBridge

@MainActor
class LayoutPriorityServerSnaposhTests: FBServerSnapshotTestCase {

  func testWithoutLayoutPriorities() {

    let view1 = UILabel()
    view1.text = "Mauris ullamcorper lacus eget enim feugiat rhoncus. Nullam vulputate enim ac lorem consequat faucibus."
    view1.numberOfLines = 0

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.red

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.blue

    let view4 = UIView()
    view4.backgroundColor = ColorPallete.orange

    let layout = HStack(spacing: 8) {
      view1
      view2
      view3
      view4
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }

  func testWithRedHavingHighestLayoutPriority() {

    let view1 = UILabel()
    view1.text = "Mauris ullamcorper lacus eget enim feugiat rhoncus. Nullam vulputate enim ac lorem consequat faucibus."
    view1.numberOfLines = 0

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.red

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.blue

    let view4 = UIView()
    view4.backgroundColor = ColorPallete.orange

    let layout = HStack(spacing: 8) {
      view1
      view2
        .layoutPriority(1)
      view3
      view4
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }

  func testWithBlueHavingHighestLayoutPriority() {

    let view1 = UILabel()
    view1.text = "Mauris ullamcorper lacus eget enim feugiat rhoncus. Nullam vulputate enim ac lorem consequat faucibus."
    view1.numberOfLines = 0

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.red

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.blue

    let view4 = UIView()
    view4.backgroundColor = ColorPallete.orange

    let layout = HStack(spacing: 8) {
      view1
      view2
      view3
        .layoutPriority(1)
      view4
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }

  func testWithOrangeHavingHighestLayoutPriority() {

    let view1 = UILabel()
    view1.text = "Mauris ullamcorper lacus eget enim feugiat rhoncus. Nullam vulputate enim ac lorem consequat faucibus."
    view1.numberOfLines = 0

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.red

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.blue

    let view4 = UIView()
    view4.backgroundColor = ColorPallete.orange

    let layout = HStack(spacing: 8) {
      view1
      view2
      view3
      view4
        .layoutPriority(1)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }

  func testWithRedAndOrangeHavingHighestLayoutPriority() {

    let view1 = UILabel()
    view1.text = "Mauris ullamcorper lacus eget enim feugiat rhoncus. Nullam vulputate enim ac lorem consequat faucibus."
    view1.numberOfLines = 0

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.red

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.blue

    let view4 = UIView()
    view4.backgroundColor = ColorPallete.orange

    let layout = HStack(spacing: 8) {
      view1
      view2
        .layoutPriority(1)
      view3
      view4
        .layoutPriority(1)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }

  func testWithTextHavingHighestLayoutPriority() {

    let view1 = UILabel()
    view1.text = "Mauris ullamcorper lacus eget enim feugiat rhoncus. Nullam vulputate enim ac lorem consequat faucibus."
    view1.numberOfLines = 0

    let view2 = UIView()
    view2.backgroundColor = ColorPallete.red

    let view3 = UIView()
    view3.backgroundColor = ColorPallete.blue

    let view4 = UIView()
    view4.backgroundColor = ColorPallete.orange

    let layout = HStack(spacing: 8) {
      view1
        .layoutPriority(1)
      view2
      view3
      view4
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }
}

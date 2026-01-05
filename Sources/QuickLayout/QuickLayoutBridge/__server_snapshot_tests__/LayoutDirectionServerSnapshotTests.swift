/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import QuickLayoutBridge
import XCTest

class LayoutDirectionSnapShotTests: FBServerSnapshotTestCase {

  func testOverrideLeftToRight() {
    let label1 = UILabel()
    let label2 = UILabel()

    label1.text = "Hello"
    label2.text = "Goodbye"

    let layout = HStack {
      label1
      Spacer()
      label2
    }
    .layoutDirection(.leftToRight)

    takeSnapshot(
      with: layout,
      in: .exact(CGSize(width: 300, height: 44))
    )
  }

  func testOverrideRightToLeft() {
    let label1 = UILabel()
    let label2 = UILabel()

    label1.text = "Hello"
    label2.text = "Goodbye"

    let layout = HStack {
      label1
      Spacer()
      label2
    }
    .layoutDirection(.rightToLeft)

    takeSnapshot(
      with: layout,
      in: .exact(CGSize(width: 300, height: 44))
    )
  }

  func testFlexibleFrameAlignment() {
    let label1 = UILabel()

    label1.text = "Lorem Ipsum"

    let layout =
      label1
      .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
      .layoutDirection(.rightToLeft)

    takeSnapshot(
      with: layout,
      in: .exact(CGSize(width: 300, height: 44))
    )
  }

  func testFixedFrameAlignment() {
    let label1 = UILabel()

    label1.text = "Lorem Ipsum"

    let layout =
      label1
      .frame(width: 200, alignment: .leading)
      .layoutDirection(.rightToLeft)

    takeSnapshot(
      with: layout,
      in: .exact(CGSize(width: 200, height: 44))
    )
  }
}

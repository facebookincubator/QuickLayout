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
class ConstrainedSizeServerSnapshotTests: FBServerSnapshotTestCase {

  func testConstrainedSizeMaxWidthWithFixedChild() {
    let view1 = ColorView(ColorPallete.yellow, text: "1")
    let view2 = ColorView(ColorPallete.yellow, text: "2")
    let view3 = ColorView(ColorPallete.yellow, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(ColorPallete.yellow, text: "5")
    let view6 = ColorView(ColorPallete.yellow, text: "6")
    let view7 = ColorView(ColorPallete.yellow, text: "7")
    let view8 = ColorView(ColorPallete.yellow, text: "8")
    let view9 = ColorView(ColorPallete.yellow, text: "9")

    let borderView1 = BorderView()
    let borderView2 = BorderView()
    let borderView3 = BorderView()
    let borderView4 = BorderView()
    let borderView5 = BorderView()
    let borderView6 = BorderView()
    let borderView7 = BorderView()
    let borderView8 = BorderView()
    let borderView9 = BorderView()

    let layout = VStack(alignment: .center, spacing: 10) {
      view1
        .frame(width: 40)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView1 }
        .frame(width: 50)
        .frame(height: 20)

      view2
        .frame(width: 40)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView2 }
        .frame(width: 150)
        .frame(height: 20)

      view3
        .frame(width: 40)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView3 }
        .frame(width: 250)
        .frame(height: 20)

      view4
        .frame(width: 160)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView4 }
        .frame(width: 50)
        .frame(height: 20)

      view5
        .frame(width: 160)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView5 }
        .frame(width: 150)
        .frame(height: 20)

      view6
        .frame(width: 160)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView6 }
        .frame(width: 250)
        .frame(height: 20)

      view7
        .frame(width: 260)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView7 }
        .frame(width: 50)
        .frame(height: 20)

      view8
        .frame(width: 260)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView8 }
        .frame(width: 150)
        .frame(height: 20)

      view9
        .frame(width: 260)
        .constrainedSize(maxWidth: 200)
        .overlay { borderView9 }
        .frame(width: 250)
        .frame(height: 20)
    }
    .frame(width: 320)

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }

  func testConstrainedSizeMaxWidthWithFlexibleChild() {
    let view1 = ColorView(ColorPallete.yellow, text: "1")
    let view2 = ColorView(ColorPallete.yellow, text: "2")
    let view3 = ColorView(ColorPallete.yellow, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(ColorPallete.yellow, text: "5")
    let view6 = ColorView(ColorPallete.yellow, text: "6")
    let view7 = ColorView(ColorPallete.yellow, text: "7")
    let view8 = ColorView(ColorPallete.yellow, text: "8")
    let view9 = ColorView(ColorPallete.yellow, text: "9")

    let borderView1 = BorderView()
    let borderView2 = BorderView()
    let borderView3 = BorderView()
    let borderView4 = BorderView()
    let borderView5 = BorderView()
    let borderView6 = BorderView()
    let borderView7 = BorderView()
    let borderView8 = BorderView()
    let borderView9 = BorderView()

    let layout = VStack(alignment: .center, spacing: 10) {
      view1
        .constrainedSize(maxWidth: 200)
        .overlay { borderView1 }
        .frame(width: 50)
        .frame(height: 20)

      view2
        .constrainedSize(maxWidth: 200)
        .overlay { borderView2 }
        .frame(width: 150)
        .frame(height: 20)

      view3
        .constrainedSize(maxWidth: 200)
        .overlay { borderView3 }
        .frame(width: 250)
        .frame(height: 20)

      view4
        .constrainedSize(maxWidth: 200)
        .overlay { borderView4 }
        .frame(width: 50)
        .frame(height: 20)

      view5
        .constrainedSize(maxWidth: 200)
        .overlay { borderView5 }
        .frame(width: 150)
        .frame(height: 20)

      view6
        .constrainedSize(maxWidth: 200)
        .overlay { borderView6 }
        .frame(width: 250)
        .frame(height: 20)

      view7
        .constrainedSize(maxWidth: 200)
        .overlay { borderView7 }
        .frame(width: 50)
        .frame(height: 20)

      view8
        .constrainedSize(maxWidth: 200)
        .overlay { borderView8 }
        .frame(width: 150)
        .frame(height: 20)

      view9
        .constrainedSize(maxWidth: 200)
        .overlay { borderView9 }
        .frame(width: 250)
        .frame(height: 20)
    }
    .frame(width: 320)

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }

  func testConstrainedSizeMaxHeightWithFixedChild() {
    let view1 = ColorView(ColorPallete.yellow, text: "1")
    let view2 = ColorView(ColorPallete.yellow, text: "2")
    let view3 = ColorView(ColorPallete.yellow, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(ColorPallete.yellow, text: "5")
    let view6 = ColorView(ColorPallete.yellow, text: "6")
    let view7 = ColorView(ColorPallete.yellow, text: "7")
    let view8 = ColorView(ColorPallete.yellow, text: "8")
    let view9 = ColorView(ColorPallete.yellow, text: "9")

    let borderView1 = BorderView()
    let borderView2 = BorderView()
    let borderView3 = BorderView()
    let borderView4 = BorderView()
    let borderView5 = BorderView()
    let borderView6 = BorderView()
    let borderView7 = BorderView()
    let borderView8 = BorderView()
    let borderView9 = BorderView()

    let layout = HStack(alignment: .center, spacing: 10) {
      view1
        .frame(height: 10)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView1 }
        .frame(height: 20)
        .frame(width: 100)

      view2
        .frame(height: 10)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView2 }
        .frame(height: 50)
        .frame(width: 100)

      view3
        .frame(height: 10)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView3 }
        .frame(height: 80)
        .frame(width: 100)

      view4
        .frame(height: 40)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView4 }
        .frame(height: 20)
        .frame(width: 100)

      view5
        .frame(height: 40)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView5 }
        .frame(height: 50)
        .frame(width: 100)

      view6
        .frame(height: 40)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView6 }
        .frame(height: 80)
        .frame(width: 100)

      view7
        .frame(height: 70)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView7 }
        .frame(height: 20)
        .frame(width: 100)

      view8
        .frame(height: 70)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView8 }
        .frame(height: 50)
        .frame(width: 100)

      view9
        .frame(height: 70)
        .constrainedSize(maxHeight: 50)
        .overlay { borderView9 }
        .frame(height: 80)
        .frame(width: 100)
    }

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 1000, height: 320))
    )
  }

  func testConstrainedSizeBothConstraints() {
    let view1 = ColorView(ColorPallete.yellow, text: "1")
    let view2 = ColorView(ColorPallete.yellow, text: "2")
    let view3 = ColorView(ColorPallete.yellow, text: "3")
    let view4 = ColorView(ColorPallete.yellow, text: "4")
    let view5 = ColorView(ColorPallete.yellow, text: "5")
    let view6 = ColorView(ColorPallete.yellow, text: "6")
    let view7 = ColorView(ColorPallete.yellow, text: "7")
    let view8 = ColorView(ColorPallete.yellow, text: "8")
    let view9 = ColorView(ColorPallete.yellow, text: "9")

    let borderView1 = BorderView()
    let borderView2 = BorderView()
    let borderView3 = BorderView()
    let borderView4 = BorderView()
    let borderView5 = BorderView()
    let borderView6 = BorderView()
    let borderView7 = BorderView()
    let borderView8 = BorderView()
    let borderView9 = BorderView()

    let layout = VStack(alignment: .center, spacing: 10) {
      view1
        .frame(width: 40)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView1 }
        .frame(width: 50)
        .frame(height: 60)

      view2
        .frame(width: 40)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView2 }
        .frame(width: 150)
        .frame(height: 60)

      view3
        .frame(width: 40)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView3 }
        .frame(width: 250)
        .frame(height: 60)

      view4
        .frame(width: 160)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView4 }
        .frame(width: 50)
        .frame(height: 60)

      view5
        .frame(width: 160)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView5 }
        .frame(width: 150)
        .frame(height: 60)

      view6
        .frame(width: 160)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView6 }
        .frame(width: 250)
        .frame(height: 60)

      view7
        .frame(width: 260)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView7 }
        .frame(width: 50)
        .frame(height: 60)

      view8
        .frame(width: 260)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView8 }
        .frame(width: 150)
        .frame(height: 60)

      view9
        .frame(width: 260)
        .constrainedSize(maxWidth: 200, maxHeight: 50)
        .overlay { borderView9 }
        .frame(width: 250)
        .frame(height: 60)
    }
    .frame(width: 320)

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 640))
    )
  }

  func testConstrainedSizeVsFlexibleFrame() {
    let viewA1 = ColorView(ColorPallete.yellow, text: "A1")
    let viewB1 = ColorView(ColorPallete.blue, text: "B1")
    let viewA2 = ColorView(ColorPallete.yellow, text: "A2")
    let viewB2 = ColorView(ColorPallete.blue, text: "B2")
    let viewA3 = ColorView(ColorPallete.yellow, text: "A3")
    let viewB3 = ColorView(ColorPallete.blue, text: "B3")

    let borderViewA1 = BorderView()
    let borderViewB1 = BorderView()
    let borderViewA2 = BorderView()
    let borderViewB2 = BorderView()
    let borderViewA3 = BorderView()
    let borderViewB3 = BorderView()

    let layout = VStack(alignment: .center, spacing: 10) {
      // Child width 40, maxWidth 200
      viewA1
        .frame(width: 40)
        .constrainedSize(maxWidth: 200)
        .overlay { borderViewA1 }
        .frame(width: 250)
        .frame(height: 20)

      viewB1
        .frame(width: 40)
        .frame(maxWidth: 200)
        .overlay { borderViewB1 }
        .frame(width: 250)
        .frame(height: 20)

      // Child width 160, maxWidth 200
      viewA2
        .frame(width: 160)
        .constrainedSize(maxWidth: 200)
        .overlay { borderViewA2 }
        .frame(width: 250)
        .frame(height: 20)

      viewB2
        .frame(width: 160)
        .frame(maxWidth: 200)
        .overlay { borderViewB2 }
        .frame(width: 250)
        .frame(height: 20)

      // Child width 260, maxWidth 200
      viewA3
        .frame(width: 260)
        .constrainedSize(maxWidth: 200)
        .overlay { borderViewA3 }
        .frame(width: 250)
        .frame(height: 20)

      viewB3
        .frame(width: 260)
        .frame(maxWidth: 200)
        .overlay { borderViewB3 }
        .frame(width: 250)
        .frame(height: 20)
    }
    .frame(width: 320)

    takeSnapshot(
      with: layout,
      in: .proposed(CGSize(width: 320, height: 320))
    )
  }
}

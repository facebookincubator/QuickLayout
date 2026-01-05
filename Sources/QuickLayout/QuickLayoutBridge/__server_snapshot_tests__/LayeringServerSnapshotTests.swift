/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import FBTestImageGenerator
import QuickLayoutBridge

private class LabelView: UIView {
  let label = UILabel()

  init(_ text: String) {
    super.init(frame: .zero)
    label.text = text
    label.textColor = .white
    self.addSubview(label)
  }

  private lazy var layout: Layout = {
    HStack {
      label
    }
  }()

  public required init?(coder: NSCoder) {
    fatalError()
  }

  override func layoutSubviews() {
    layout.applyFrame(bounds)
  }
}

@MainActor
class LayeringServerSnaposhTests: FBServerSnapshotTestCase {

  func testLayeringWithAlignment() {

    let label1 = UILabel()
    label1.text = "Hello World"

    let targetView = UIView()
    targetView.backgroundColor = ColorPallete.blue

    let view1 = LabelView("1")
    view1.backgroundColor = ColorPallete.red
    let view2 = LabelView("2")
    view2.backgroundColor = ColorPallete.yellow
    let view3 = LabelView("3")
    view3.backgroundColor = ColorPallete.orange

    let view4 = LabelView("4")
    view4.backgroundColor = ColorPallete.orange
    let view5 = LabelView("5")
    view5.backgroundColor = ColorPallete.red
    let view6 = LabelView("6")
    view6.backgroundColor = ColorPallete.yellow

    let view7 = LabelView("7")
    view7.backgroundColor = ColorPallete.yellow
    let view8 = LabelView("8")
    view8.backgroundColor = ColorPallete.orange
    let view9 = LabelView("9")
    view9.backgroundColor = ColorPallete.red

    let layout = HStack {
      label1
      Spacer(8)
      targetView
        .frame(width: 100, height: 100)
        .overlay(alignment: .topLeading) {
          view1.frame(width: 30, height: 30)
        }
        .overlay(alignment: .top) {
          view2.frame(width: 30, height: 30)
        }
        .overlay(alignment: .topTrailing) {
          view3.frame(width: 30, height: 30)
        }
        .overlay(alignment: .leading) {
          view4.frame(width: 30, height: 30)
        }
        .overlay {
          view5.frame(width: 30, height: 30)
        }
        .overlay(alignment: .trailing) {
          view6.frame(width: 30, height: 30)
        }
        .overlay(alignment: .bottomLeading) {
          view7.frame(width: 30, height: 30)
        }
        .overlay(alignment: .bottom) {
          view8.frame(width: 30, height: 30)
        }
        .overlay(alignment: .bottomTrailing) {
          view9.frame(width: 30, height: 30)
        }
    }

    takeSnapshot(
      with: layout,
      in: .exact(CGSize(width: 200, height: 200))
    )
  }

  func testLayeringWithNil() {

    let label1 = UILabel()
    label1.text = "Hello World"

    let targetView = UIView()
    targetView.backgroundColor = ColorPallete.blue

    let view1: UIView? = nil

    let layout = HStack {
      label1
      Spacer(8)
      targetView
        .frame(width: 100, height: 100)
        .overlay(alignment: .topLeading) {
          view1?.frame(width: 30, height: 30)
        }
    }

    takeSnapshot(
      with: layout,
      in: .exact(CGSize(width: 200, height: 200))
    )
  }
}

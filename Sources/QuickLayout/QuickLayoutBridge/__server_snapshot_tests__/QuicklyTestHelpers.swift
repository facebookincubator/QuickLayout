/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBServerSnapshotTestCase
import Foundation
import METAUIColorSwift
import QuickLayoutBridge

struct ColorPallete {
  static let blue = UIColor(rgb: 0x4793AF)
  static let yellow = UIColor(rgb: 0xFFC470)
  static let orange = UIColor(rgb: 0xDD5746)
  static let red = UIColor(rgb: 0x8B322C)
}

enum SizeType {
  case proposed(_ size: CGSize)
  case exact(_ size: CGSize)
}

func takeSnapshot(
  with layout: Layout,
  in sizeType: SizeType,
  alignment: Alignment? = nil,
  identifier: String? = nil,
  containerBackground: UIColor? = nil,
  layoutDirection: LayoutDirection? = nil
) {
  let targetView = TestView()
  targetView.backgroundColor = containerBackground
  layout.views().forEach { targetView.addSubview($0) }
  targetView.layout = layout
  targetView.layoutDirection = layoutDirection
  targetView.alignment = alignment
  switch sizeType {
  case .exact(let size): targetView.frame.size = size
  case .proposed(let size): targetView.frame.size = targetView.sizeThatFits(size)
  }

  let backgroundView = UIView()
  backgroundView.bounds = targetView.bounds
  backgroundView.backgroundColor = .clear
  backgroundView.addSubview(targetView)
  targetView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
  FBTakeSnapshotOfViewAfterScreenUpdates(backgroundView, nil)
}

func takeSnapshot(of targetView: UIView, in sizeType: SizeType, identifier: String? = nil) {

  switch sizeType {
  case .exact(let size): targetView.frame.size = size
  case .proposed(let size): targetView.frame.size = targetView.sizeThatFits(size)
  }

  let backgroundView = UIView()
  backgroundView.bounds = targetView.bounds
  backgroundView.backgroundColor = .clear
  backgroundView.addSubview(targetView)
  targetView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
  FBTakeSnapshotOfViewAfterScreenUpdates(backgroundView, nil)
}

final class TestView: UIView {

  var layout: Layout = EmptyLayout()
  var alignment: Alignment?
  var layoutDirection: LayoutDirection?

  override func layoutSubviews() {
    super.layoutSubviews()
    if let alignment, let layoutDirection {
      layout.applyFrame(bounds, alignment: alignment, layoutDirection: layoutDirection)
    } else if let alignment {
      layout.applyFrame(bounds, alignment: alignment)
    } else if let layoutDirection {
      layout.applyFrame(bounds, alignment: .center, layoutDirection: layoutDirection)
    } else {
      layout.applyFrame(bounds)
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return layout.sizeThatFits(size)
  }
}

class ViewWithSize: UIView {

  let customSize: CGSize
  var proposedSizes = [CGSize]()

  init(customSize: CGSize) {
    self.customSize = customSize
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    proposedSizes.append(size)
    return customSize
  }
}

func generateTestImage(with text: String, size: CGSize, backgroundColor: UIColor = ColorPallete.blue) -> UIImage? {
  assert(Thread.isMainThread)

  let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
  let label = UILabel(frame: frame)
  label.textAlignment = .center
  label.backgroundColor = backgroundColor
  label.textColor = .white
  label.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .regular)
  label.text = text

  let renderer = UIGraphicsImageRenderer(size: frame.size)
  let image = renderer.image { (context) in
    label.layer.render(in: context.cgContext)
  }
  return image
}

class TestPlaceholderView: UIView {

  private let lineColor: UIColor
  private let lineWidth: CGFloat
  private let intrinsicSize: CGSize?
  private let fillColor: UIColor

  init(lineColor: UIColor = UIColor.black, lineWidth: CGFloat = 2, fillColor: UIColor = .white, intrinsicSize: CGSize? = nil) {
    self.lineColor = lineColor
    self.intrinsicSize = intrinsicSize
    self.lineWidth = lineWidth
    self.fillColor = fillColor
    super.init(frame: .zero)
    layer.borderColor = lineColor.cgColor
    layer.borderWidth = lineWidth
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // Fully flexible if no intrinsic size is set.
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    return intrinsicSize ?? size
  }

  override func draw(_ rect: CGRect) {
    fillColor.setFill()

    UIRectFill(rect)

    lineColor.setStroke()

    let linePath = UIBezierPath()
    linePath.lineWidth = lineWidth
    // First line from top left to bottom right
    linePath.move(to: CGPoint.zero)
    linePath.addLine(to: CGPoint(x: rect.width, y: rect.height))
    linePath.stroke()
    // Second line from top right to bottom left
    linePath.move(to: CGPoint(x: rect.width, y: 0))
    linePath.addLine(to: CGPoint(x: 0, y: rect.height))
    linePath.stroke()
  }
}

class ColorView: UIView {

  private let text: String?

  init(_ color: UIColor, text: String? = nil) {
    self.text = text
    super.init(frame: .zero)
    self.backgroundColor = color
  }

  override func draw(_ rect: CGRect) {
    super.draw(rect)

    if let text {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .center

      let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 16),
        .paragraphStyle: paragraphStyle,
        .foregroundColor: UIColor.black,
      ]

      let attributedString = NSAttributedString(string: text, attributes: attributes)
      let textRect = CGRect(x: 0, y: (rect.height - attributedString.size().height) / 2, width: rect.width, height: attributedString.size().height)
      attributedString.draw(in: textRect)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class BorderView: UIView {
  init() {
    super.init(frame: .zero)
    self.layer.borderColor = UIColor.black.cgColor
    self.layer.borderWidth = 1
    self.backgroundColor = UIColor.clear
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

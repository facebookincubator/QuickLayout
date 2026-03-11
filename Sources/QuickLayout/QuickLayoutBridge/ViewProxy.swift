/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutCore
@_exported import UIKit

// MARK: - Definition

/**
 ViewProxy should be utilized for sizing purposes. If you need to find the size of a layout,
 but you don't have the views yet, you can build a matching layout using ViewProxy objects
 in place of views.

 For regular layout, where views exist, ViewProxy should not be used. It is a stand in for
 missing views only.
 */
public struct ViewProxy: LeafElement {
  private let horizontalFlexibility: Flexibility
  private let verticalFlexibility: Flexibility
  private let proxySizingCalculation: (CGSize) -> CGSize

  public static func empty() -> ViewProxy {
    return ViewProxy(width: 0, height: 0)
  }

  public init(width: CGFloat, height: CGFloat) {
    self.init(flexibility: .fixedSize) { _ in CGSize(width: width, height: height) }
  }

  public init(width: CGFloat) {
    self.init(horizontal: .fixedSize, vertical: .fullyFlexible) { proposedSize in
      CGSize(width: width, height: proposedSize.height)
    }
  }

  public init(height: CGFloat) {
    self.init(horizontal: .fullyFlexible, vertical: .fixedSize) { proposedSize in
      CGSize(width: proposedSize.width, height: height)
    }
  }

  public init() {
    self.init(horizontal: .fullyFlexible, vertical: .fullyFlexible) { proposedSize in
      proposedSize
    }
  }

  public init(flexibility: Flexibility, proxySizingCalculation: @escaping (CGSize) -> CGSize) {
    self.horizontalFlexibility = flexibility
    self.verticalFlexibility = flexibility
    self.proxySizingCalculation = proxySizingCalculation
  }

  public init(horizontal horizontalFlexibility: Flexibility, vertical verticalFlexibility: Flexibility, proxySizingCalculation: @escaping (CGSize) -> CGSize) {
    self.horizontalFlexibility = horizontalFlexibility
    self.verticalFlexibility = verticalFlexibility
    self.proxySizingCalculation = proxySizingCalculation
  }

  // MARK: - Element Conformance

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> QuickLayoutCore.LayoutNode {
    return LayoutNode(view: nil, dimensions: ElementDimensions(proxySizingCalculation(proposedSize)))
  }

  public func quick_flexibility(for axis: QuickLayoutCore.Axis) -> QuickLayoutCore.Flexibility {
    switch axis {
    case .horizontal: return horizontalFlexibility
    case .vertical: return verticalFlexibility
    }
  }

  public func quick_layoutPriority() -> CGFloat {
    0
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
  }

  public func backingView() -> UIView? {
    nil
  }
}

// MARK: - UIKit Conformance

public extension UILabel {
  // While we could use NSString's boundingRectWithSize:, UILabel applies
  // caching, performance optimizations, and includes details like shadow offset.
  private static let sizingLabel = UILabel()
  static func proxy(for text: String, numberOfLines: Int = 1, with font: UIFont? = nil) -> ViewProxy {
    return ViewProxy(flexibility: .partial) { constrainingSize in
      assert(Thread.isMainThread, "UILabel ViewProxy can be used only on the main thread. Prefer using FOALabel.swift if you need to have background safe advance sizing.")
      sizingLabel.attributedText = nil
      sizingLabel.text = text
      sizingLabel.font = font
      sizingLabel.numberOfLines = numberOfLines
      return sizingLabel.quick_layoutThatFits(constrainingSize).size
    }
  }
  // Separate sizing label for attributed strings to prevent UIKit's internal
  // paragraph style caching from leaking stale properties (e.g. minimumLineHeight)
  // to subsequent text-based proxy calls on the shared sizingLabel.
  private static let attributedSizingLabel = UILabel()
  static func proxy(for attributedText: NSAttributedString, numberOfLines: Int = 1) -> ViewProxy {
    return ViewProxy(flexibility: .partial) { constrainingSize in
      assert(Thread.isMainThread, "UILabel ViewProxy can be used only on the main thread. Prefer using FOALabel.swift if you need to have background safe advance sizing.")
      attributedSizingLabel.text = nil
      attributedSizingLabel.attributedText = attributedText
      attributedSizingLabel.numberOfLines = numberOfLines
      return attributedSizingLabel.quick_layoutThatFits(constrainingSize).size
    }
  }
}

public extension UIImageView {
  static func proxy(for image: UIImage?) -> ViewProxy {
    return ViewProxy(flexibility: .fixedSize) { _ in
      return image?.size ?? .zero
    }
  }
}

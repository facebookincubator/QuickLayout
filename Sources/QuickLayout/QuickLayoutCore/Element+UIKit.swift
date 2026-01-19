/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

@MainActor
private let uiViewSizeThatFitsSelector = #selector(UIView.sizeThatFits(_:))

@MainActor
private let uiViewSizeThatFitsInstanceMethod = UIView.instanceMethod(for: uiViewSizeThatFitsSelector)

private func sanitizeSize(_ size: CGSize) -> CGSize {
  CGSize(
    width: size.width.isFinite ? size.width : 10,
    height: size.height.isFinite ? size.height : 10
  )
}

// patternlint-disable-next-line retroactive-conformance-systemlib
#if compiler(>=6)
extension UIView: @preconcurrency LeafElement {}
#else
extension UIView: LeafElement {}
#endif

extension UIView {
  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    assert(Thread.isMainThread, "UIViews can be laid out only on the main thread.")

    let viewType = self.quick_viewType()
    switch viewType {
    case .baseView: return BaseViewLayout.layoutThatFits(view: self, proposedSize: proposedSize)
    case .label: return LabelViewLayout.layoutThatFits(view: self, proposedSize: proposedSize)
    case .horizontallyExpandable: return HorizontallyExpandableViewLayout.layoutThatFits(view: self, proposedSize: proposedSize)
    case .scrollView: return ScrollViewLayout.layoutThatFits(view: self, proposedSize: proposedSize)
    case .tableView: return TableViewLayout.layoutThatFits(view: self, proposedSize: proposedSize)
    case .textView: return TextViewLayout.layoutThatFits(view: self, proposedSize: proposedSize)
    case .fixedSize: return FixedSizeViewLayout.layoutThatFits(view: self, proposedSize: proposedSize)
    }
  }

  @objc
  open func quick_flexibility(for axis: Axis) -> Flexibility {
    assert(Thread.isMainThread, "UIViews can be laid out only on the main thread.")

    let viewType = self.quick_viewType()
    switch viewType {
    case .baseView: return BaseViewLayout.flexibility(for: axis, view: self)
    case .label: return LabelViewLayout.flexibility(for: axis)
    case .horizontallyExpandable: return HorizontallyExpandableViewLayout.flexibility(for: axis)
    case .scrollView: return ScrollViewLayout.flexibility(for: axis)
    case .textView: return TextViewLayout.flexibility(for: axis)
    case .tableView: return TableViewLayout.flexibility(for: axis)
    case .fixedSize: return FixedSizeViewLayout.flexibility(for: axis)
    }
  }

  public func quick_layoutPriority() -> CGFloat {
    return 0
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    views.append(self)
  }

  public func backingView() -> UIView? {
    self
  }
}

@MainActor
private struct BaseViewLayout {

  @MainActor
  private static func measure(_ view: UIView, _ proposedSize: CGSize) -> CGSize {
    if view.method(for: uiViewSizeThatFitsSelector) != uiViewSizeThatFitsInstanceMethod {
      return view.sizeThatFits(proposedSize)
    }
    return proposedSize
  }

  static func layoutThatFits(view: UIView, proposedSize: CGSize) -> LayoutNode {
    let size = measure(view, proposedSize)
    return LayoutNode(view: view, dimensions: ElementDimensions(sanitizeSize(size)))
  }

  static func flexibility(for axis: Axis, view: UIView) -> Flexibility {
    if view.method(for: uiViewSizeThatFitsSelector) != uiViewSizeThatFitsInstanceMethod {
      return .partial
    }
    return .fullyFlexible
  }
}

@MainActor
private struct LabelViewLayout {

  static func layoutThatFits(view: UIView, proposedSize: CGSize) -> LayoutNode {
    var size = CGSize.zero
    if proposedSize.width > 1 && proposedSize.height > 1 {
      /*
       Below, the measured size is clamped with the constraining size
       to ensure the label doesn't grow beyond the proposed size.
       This is OK but not ideal because clamping wouldn't round to the nearest visible line
       leading to extra space on top and bottom.
       Learn more: https://facebookincubator.github.io/QuickLayout/layout/calculate-size-label/#label-layout-implementation-in-quicklayout
       */
      size = view.sizeThatFits(proposedSize)
      size.width = roundSizeToPixelGrid(min(size.width, proposedSize.width))
      size.height = roundSizeToPixelGrid(min(size.height, proposedSize.height))
    }
    return LayoutNode(view: view, dimensions: ElementDimensions(size))
  }

  static func flexibility(for axis: Axis) -> Flexibility {
    return .partial
  }
}

@MainActor
private struct HorizontallyExpandableViewLayout {

  static func layoutThatFits(view: UIView, proposedSize: CGSize) -> LayoutNode {
    let height = view.sizeThatFits(proposedSize).height
    let size = CGSize(width: proposedSize.width, height: height)
    return LayoutNode(view: view, dimensions: ElementDimensions(sanitizeSize(size)))
  }

  static func flexibility(for axis: Axis) -> Flexibility {
    switch axis {
    case .horizontal: return .fullyFlexible
    case .vertical: return .fixedSize
    }
  }
}

@MainActor
private struct TableViewLayout {

  static func layoutThatFits(view: UIView, proposedSize: CGSize) -> LayoutNode {
    var size = proposedSize
    let selector = #selector(UITableView.sizeThatFits(_:))
    if view.method(for: selector) != UITableView.instanceMethod(for: selector) {
      size = view.sizeThatFits(proposedSize)
    }
    return LayoutNode(view: view, dimensions: ElementDimensions(sanitizeSize(size)))
  }

  static func flexibility(for axis: Axis) -> Flexibility {
    .fullyFlexible
  }
}

@MainActor
private struct ScrollViewLayout {

  static func layoutThatFits(view: UIView, proposedSize: CGSize) -> LayoutNode {
    var size = proposedSize
    let selector = #selector(UIScrollView.sizeThatFits(_:))
    if view.method(for: selector) != UIScrollView.instanceMethod(for: selector) {
      size = view.sizeThatFits(proposedSize)
    }
    return LayoutNode(view: view, dimensions: ElementDimensions(sanitizeSize(size)))
  }

  static func flexibility(for axis: Axis) -> Flexibility {
    .fullyFlexible
  }
}

@MainActor
private struct TextViewLayout {

  static func layoutThatFits(view: UIView, proposedSize: CGSize) -> LayoutNode {
    var size = proposedSize
    let selector = #selector(UITextView.sizeThatFits(_:))
    if view.method(for: selector) != UITextView.instanceMethod(for: selector) {
      size = view.sizeThatFits(proposedSize)
    }
    return LayoutNode(view: view, dimensions: ElementDimensions(sanitizeSize(size)))
  }

  static func flexibility(for axis: Axis) -> Flexibility {
    .fullyFlexible
  }
}

@MainActor
private struct FixedSizeViewLayout {

  static func layoutThatFits(view: UIView, proposedSize: CGSize) -> LayoutNode {
    let size = view.sizeThatFits(proposedSize)
    return LayoutNode(view: view, dimensions: ElementDimensions(sanitizeSize(size)))
  }

  static func flexibility(for axis: Axis) -> Flexibility {
    .fixedSize
  }
}

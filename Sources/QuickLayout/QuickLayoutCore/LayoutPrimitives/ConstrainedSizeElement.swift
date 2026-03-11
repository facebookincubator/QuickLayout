/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

public struct ConstrainedSizeElement: Layout {

  private let child: Element
  private let maxWidth: CGFloat?
  private let maxHeight: CGFloat?

  public init(
    child: Element,
    maxWidth: CGFloat? = nil,
    maxHeight: CGFloat? = nil,
  ) {
    self.child = child
    self.maxWidth = sanitizedDimension(maxWidth)
    self.maxHeight = sanitizedDimension(maxHeight)
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    child.quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    child.quick_layoutPriority()
  }

  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    /// Clamping the proposed size to the constrained size.
    let proposedSize = CGSize(
      width: maxWidth.map { min($0, proposedSize.width) } ?? proposedSize.width,
      height: maxHeight.map { min($0, proposedSize.height) } ?? proposedSize.height,
    )
    let layout = child.quick_layoutThatFits(proposedSize)
    let childNode = LayoutNode.Child(position: .zero, layout: layout)
    let alignmentGuides = AlignmentGuidesResolver.extract(childNode)
    return LayoutNode(view: nil, size: layout.size, children: [childNode], alignmentGuides: alignmentGuides)
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    child.quick_extractViewsIntoArray(&views)
  }
}

private func sanitizedDimension(_ width: CGFloat?) -> CGFloat? {
  guard let width, width.isFinite else { return nil }
  return max(width, 0)
}

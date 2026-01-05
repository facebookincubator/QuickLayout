/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

// MARK: - AlignmentGuides

struct AlignmentGuides: Sequence {
  struct Iterator: IteratorProtocol {
    var impl: Dictionary<AnyAlignmentID, @Sendable (ElementDimensions) -> CGFloat>.Iterator?
    mutating func next() -> (key: AnyAlignmentID, value: @Sendable (ElementDimensions) -> CGFloat)? {
      impl?.next()
    }
  }

  private var value: [AnyAlignmentID: @Sendable (ElementDimensions) -> CGFloat]?

  fileprivate init() {
    value = nil
  }

  fileprivate init(_ value: [AnyAlignmentID: @Sendable (ElementDimensions) -> CGFloat]) {
    self.value = value
  }

  subscript(_ id: AnyAlignmentID) -> (@Sendable (ElementDimensions) -> CGFloat)? {
    get {
      value?[id]
    }
    set {
      value = value ?? [:]
      value?[id] = newValue
    }
  }

  func disregarding(_ id: AnyAlignmentID) -> AlignmentGuides {
    guard var copy = value else {
      return self
    }
    copy[id] = nil
    return AlignmentGuides(copy)
  }

  func makeIterator() -> Iterator {
    return Iterator(impl: value?.makeIterator())
  }
}

// MARK: - AlignmentGuidesResolver

struct AlignmentGuidesResolver {
  private static let defaultAlignmentIDs: Set<AnyAlignmentID> = [
    VerticalAlignment.top.alignmentID,
    VerticalAlignment.center.alignmentID,
    VerticalAlignment.bottom.alignmentID,
    HorizontalAlignment.leading.alignmentID,
    HorizontalAlignment.center.alignmentID,
    HorizontalAlignment.trailing.alignmentID,
  ]

  /**
   Use this alignment guide result when you are containing a single child,
   or multiple children where a single child is the primary child. Multiple
   child layouts, such as stacks or grids that contain more than one item
   should not use this result. The behavior applied will ensure that alignment
   guides are propagated, so that they can be used by a container layout if needed.
  */
  static func extract(_ child: LayoutNode.Child) -> AlignmentGuides {
    var alignmentGuides = AlignmentGuides()
    let position = child.position
    let childDimensions = child.layout.dimensions
    for (alignment, value) in child.layout.dimensions.alignmentGuides {
      alignmentGuides[alignment] = { (dimensions: ElementDimensions) -> CGFloat in
        // We need to provide alignment relative to position -- alignment guides
        // keep their originating element's reference frame. Child layout dimensions
        // are used so that alignment guides recieve the dimensions of the element
        // they're being applied to.
        switch alignment.axis {
        case .horizontal: value(childDimensions) + position.x
        case .vertical: value(childDimensions) + position.y
        }
      }
    }
    return alignmentGuides
  }

  /**
   Use this alignment guide result when you are containing multiple children.
   In this scenario, custom alignment guides will be propagated, whereas
   default alignment guides will not be. Multiple child layouts, such
   as stacks, should use this result.
  */
  static func extract(for children: [LayoutNode.Child]) -> AlignmentGuides {
    var alignmentGuideAggregation = [AnyAlignmentID: [@Sendable (ElementDimensions) -> CGFloat]]()

    /// Using indexed for loop and capturing CGPoint position into the block makes the function ~2x faster.
    for i in 0..<children.count {
      for (alignment, value) in children[i].layout.dimensions.alignmentGuides {
        // Don't propagate default alignment guides
        guard !AlignmentGuidesResolver.defaultAlignmentIDs.contains(alignment) else { continue }
        let position = children[i].position
        let value = value(children[i].layout.dimensions)
        alignmentGuideAggregation[alignment, default: []].append { (dimensions: ElementDimensions) -> CGFloat in
          switch alignment.axis {
          case .horizontal: value + position.x
          case .vertical: value + position.y
          }
        }
      }
    }
    return AlignmentGuides(
      alignmentGuideAggregation.compactMapValues { alignmentArray in
        guard alignmentArray.count > 0 else { return nil }
        return { dimensions in
          // Take the average of all alignment values
          return alignmentArray.reduce(0) { $0 + $1(dimensions) } / CGFloat(alignmentArray.count)
        }
      })
  }

  /**
   Use this alignment guide result when you are creating a leaf layout
   node that has no children.
  */
  static func none() -> AlignmentGuides {
    return AlignmentGuides()
  }
}

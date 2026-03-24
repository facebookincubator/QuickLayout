/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

@inline(__always)
// Substracts the value. If the result is negative, it returns zero.
private func substract(from main: CGFloat, _ value: CGFloat) -> CGFloat {
  max(0.0, main - value)
}

@inline(__always)
private func layoutGroup(indices: [Int], layouts: inout [LayoutNode], main: CGFloat, cross: CGFloat, mainAxis: Axis, children: [Element], stackItems: inout [StackItem]) -> CGFloat {
  var group = indices
  let groupCount = indices.count
  let groupProposedSize = CGSize(main: main, cross: cross, mainAxis: mainAxis)

  if groupCount == 1 {
    /// Measure a single child group immediately and only once.
    /// This optimization resolves an issue where a lone child within a group was measured twice due to rounding discrepancies.
    /// For instance, when the `groupProposedSize.width` is 233.32426488399506 but the child's width is 233.33333333333334,
    /// the algorithm previously remeasured the child unnecessarily.
    let index = indices[0]
    layouts[index] = children[index].quick_layoutThatFits(groupProposedSize)
    return substract(from: main, layouts[index].size.main(for: mainAxis))
  }

  for index in group {
    let item = stackItems[index]
    if item.premeasure {
      let layout = children[index].quick_layoutThatFits(groupProposedSize)
      stackItems[index].premeasuredMain = layout.size.main(for: mainAxis)
      layouts[index] = layout
    }
  }
  group.sort { stackItems[$0].premeasuredMain < stackItems[$1].premeasuredMain }

  var groupAvailableMain = main
  var numChildrenToLayout = groupCount
  for index in group {
    let item = stackItems[index]
    let itemAvailableMain = groupAvailableMain / CGFloat(numChildrenToLayout) // Divide the remaining available space on the main axis equally between all children
    if !item.premeasure {
      layouts[index] = children[index].quick_layoutThatFits(CGSize(main: itemAvailableMain, cross: cross, mainAxis: mainAxis))
    } else if item.premeasure && Fuzzy.compare(item.premeasuredMain, greaterThan: itemAvailableMain) {
      /// If we are here it's a double measurement.
      layouts[index] = children[index].quick_layoutThatFits(CGSize(main: itemAvailableMain, cross: cross, mainAxis: mainAxis))
    }
    groupAvailableMain = substract(from: groupAvailableMain, layouts[index].size.main(for: mainAxis))
    numChildrenToLayout -= 1
  }
  return groupAvailableMain
}

@inline(__always)
private func shouldRemeasure(_ node: LayoutNode, children: [Element], mainAxis: Axis) -> Bool {
  let count = min(children.count, node.children.count)
  guard count > 0 else { return false }
  let firstSize: CGFloat = node.children.first?.layout.size.cross(for: mainAxis) ?? -1
  for index in (0...count - 1) {
    if firstSize != node.children[index].layout.size.cross(for: mainAxis) && !children[index].quickInternal_isSpacer() {
      return true
    }
  }
  return false
}

@inline(__always)
private func newCrossSizeForRemeasure(_ node: LayoutNode, mainAxis: Axis) -> CGFloat {
  var newCrossSizeForRemeasure: CGFloat = node.children.first?.layout.size.cross(for: mainAxis) ?? 0
  for child in node.children {
    newCrossSizeForRemeasure = max(newCrossSizeForRemeasure, child.layout.size.cross(for: mainAxis))
  }
  return newCrossSizeForRemeasure
}

func computeStackLayout(children: [Element], alignment: AnyAlignmentID, mainAxis: Axis, spacing: CGFloat, proposedSize: CGSize, idealLayout: Bool) -> LayoutNode {
  if idealLayout {
    var newProposedSize = proposedSize
    let originalCross = newProposedSize.cross(for: mainAxis)
    newProposedSize = newProposedSize.replaceCross(with: .infinity, mainAxis: mainAxis)
    let layout = computeStackLayout(children: children, alignment: alignment, mainAxis: mainAxis, spacing: spacing, proposedSize: newProposedSize)
    if !shouldRemeasure(layout, children: children, mainAxis: mainAxis) && Fuzzy.compare(layout.size.cross(for: mainAxis), lessThanOrEqual: originalCross) {
      /// If all children have the same cross size, it's the ideal layout.
      return layout
    }
    let newCross = newCrossSizeForRemeasure(layout, mainAxis: mainAxis)
    let newSize = CGSize(main: newProposedSize.main(for: mainAxis), cross: min(newCross, originalCross), mainAxis: mainAxis)
    return computeStackLayout(children: children, alignment: alignment, mainAxis: mainAxis, spacing: spacing, proposedSize: newSize)
  } else {
    return computeStackLayout(children: children, alignment: alignment, mainAxis: mainAxis, spacing: spacing, proposedSize: proposedSize)
  }
}

func computeStackLayout(children: [Element], alignment: AnyAlignmentID, mainAxis: Axis, spacing: CGFloat, proposedSize: CGSize) -> LayoutNode {
  let childrenCount = children.count

  if childrenCount == 0 {
    return LayoutNode.empty
  }

  if childrenCount == 1 {
    /// This is a special case to avoid unnecessary calculations.
    /// The stack measures the single element and acquires its size.
    let childLayout = children[0].quick_layoutThatFits(proposedSize)
    let childNode = LayoutNode.Child(position: .zero, layout: childLayout)
    return LayoutNode(view: nil, size: childLayout.size, children: [childNode], alignmentGuides: AlignmentGuidesResolver.extract(childNode))
  }

  var spacingAfter: [CGFloat]?
  if spacing != 0 {
    spacingAfter = [CGFloat](repeating: 0.0, count: childrenCount)
  }
  var lastNonZeroElementIndex = -1

  let main = proposedSize.main(for: mainAxis)
  let cross = proposedSize.cross(for: mainAxis)
  var stackAvailableMain = main

  // Groups children by their layout priority. Children with the same priority are sorted by their premeasured main size.
  // Fixed size children are not grouped, they are measured immediately.
  var groupedIndices = [CGFloat: [Int]]()
  var layouts = [LayoutNode]()
  var stackItems = [StackItem]()

  layouts.reserveCapacity(childrenCount)
  stackItems.reserveCapacity(childrenCount)

  for (index, child) in children.enumerated() {
    let mainAxisFlexibility = child.quick_flexibility(for: mainAxis)
    let sizedToZero: Bool
    switch mainAxisFlexibility {
    case .fixedSize:
      let size = CGSize(main: stackAvailableMain, cross: cross, mainAxis: mainAxis)
      let layout = child.quick_layoutThatFits(size)
      let item = StackItem.empty
      sizedToZero = layout.size.height == 0 && layout.size.width == 0

      /// Subtract the total amount of spacing between children from the space available on the main axis
      stackAvailableMain = substract(from: stackAvailableMain, layout.size.main(for: mainAxis))
      layouts.append(layout)
      stackItems.append(item)
    case .partial, .fullyFlexible:
      /// The spacing will be added even if the child is sized to zero. It's not ideal, but it could only be fixed with a double measurement pass, which I want to avoid.
      sizedToZero = false
      let layoutPriority = child.quick_layoutPriority()
      let item = StackItem(
        premeasure: mainAxisFlexibility == .partial,
        premeasuredMain: mainAxisFlexibility == .fullyFlexible ? .infinity : 0
      )
      layouts.append(LayoutNode.empty)
      stackItems.append(item)
      groupedIndices[layoutPriority, default: [Int]()].append(index)
    }

    if spacing != 0.0 {
      /// The spacing is added only between two non Spacer elements if they are not pre-sized to zero.
      ///
      /// If a Spacer separates two elements, no spacing is added. See examples below
      /// [Element1, Spacer(), Element2]
      /// [Element1, Spacer(x), Spacer(), Element2]
      ///
      /// If two elements are separated by zero sized elements, such as EmptyLayout or empty stack, only one spacing is added
      /// [Element1, EmptyLayout(), Element2] -> [Element1, spacing, {0,0}, Element2]
      /// [Element1, EmptyLayout(), EmptyLayout(), Element2] -> [Element1, spacing, {0,0}, {0,0}, Element2]
      /// [Element1, HStack {}, Element2] -> [Element1, spacing, {0,0}, Element2]
      let isCurrentChildSpacer = child.quickInternal_isSpacer()
      if lastNonZeroElementIndex >= 0 {
        let shouldInsertSpacing = !sizedToZero && !isCurrentChildSpacer && !children[lastNonZeroElementIndex].quickInternal_isSpacer()
        let spacingToInsert = shouldInsertSpacing ? spacing : 0.0
        spacingAfter![lastNonZeroElementIndex] = spacingToInsert // swiftlint:disable:this force_unwrapping
        stackAvailableMain = substract(from: stackAvailableMain, spacingToInsert)
      }
      if isCurrentChildSpacer || !sizedToZero {
        lastNonZeroElementIndex = index
      }
    }
  }

  for key in groupedIndices.keys.sorted(by: >) {
    if let group = groupedIndices[key] {
      stackAvailableMain = layoutGroup(indices: group, layouts: &layouts, main: stackAvailableMain, cross: cross, mainAxis: mainAxis, children: children, stackItems: &stackItems)
    }
  }

  let rtlLayout = LayoutContext.layoutDirection == .rightToLeft && mainAxis == .horizontal
  let range = rtlLayout ? stride(from: childrenCount - 1, through: 0, by: -1) : stride(from: 0, through: childrenCount - 1, by: 1)

  var maxAlignmentGuideLength = 0.0
  for index in range {
    maxAlignmentGuideLength = max(maxAlignmentGuideLength, layouts[index].dimensions[alignment])
  }

  var caret = 0.0 // Calculate positions on the main axis starting with zero and then adding the main size of each child as well as spacing
  var resultFrame = CGRect.zero // Calculate the size of the whole stack as the union of all children frames
  var childNodes: [LayoutNode.Child] = range.map { index in
    let layout = layouts[index]
    let mainAxisPos = caret

    let spacing: CGFloat
    if rtlLayout {
      spacing = index > 0 ? spacingAfter?[index - 1] ?? 0.0 : 0.0
    } else {
      spacing = spacingAfter?[index] ?? 0.0
    }
    caret += layout.size.main(for: mainAxis) + spacing

    // Position on the cross axis is the difference between the length of the alignment guide for a particular child and the maximum length. The child with the maximum length of the alignment guide will thus be placed flush with the start edge of the cross axis
    let alignmentGuideLength = layout.dimensions[alignment]
    let crossAxisPos = maxAlignmentGuideLength - alignmentGuideLength
    let position = roundToPixelGrid(CGPoint(main: mainAxisPos, cross: crossAxisPos, mainAxis: mainAxis))

    let childSize = layout.size
    resultFrame = resultFrame.union(CGRect(origin: position, size: childSize))

    return LayoutNode.Child(position: position, layout: layout)
  }

  if rtlLayout {
    childNodes.reverse()
  }

  let stackSize = CGSize(width: roundPositionToPixelGrid(resultFrame.width), height: roundPositionToPixelGrid(resultFrame.height))
  return LayoutNode(view: nil, size: stackSize, children: childNodes, alignmentGuides: AlignmentGuidesResolver.extract(for: childNodes))
}

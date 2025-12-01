/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@_exported import FastResultBuilder
@_exported import QuickLayoutCore
import UIKit

/// Arranges its elements in a horizontal line. Spacing is added between each pair of elements.
/// If spacing is 0, the elements are stacked without space between them.
/// If there is a Spacer(x) or Spacer() between two views, the "spacing" parameter will be ignored for those two views.
public func HStack(
  alignment: VerticalAlignment = .center,
  spacing: CGFloat = 0,
  @FastArrayBuilder<Element> children: () -> [Element]
) -> StackElement {
  StackElement.horizontalStack(children: children(), spacing: spacing, alignment: alignment)
}

/// Arranges its elements in a vertical line. Spacing is added between each pair of elements.
/// If spacing is 0, the elements are stacked without space between them.
/// If there is a Spacer(x) or Spacer() between two views, the "spacing" parameter will be ignored for those two views.
public func VStack(
  alignment: HorizontalAlignment = .center,
  spacing: CGFloat = 0,
  @FastArrayBuilder<Element> children: () -> [Element]
) -> StackElement {
  StackElement.verticalStack(children: children(), spacing: spacing, alignment: alignment)
}

/// Overlays its elements, aligning them in both axes.
/// ZStack proposes each child the parent's size, takes the size of the largest child, and then aligns each child within that size.
/// See also .overlay modifier.
public func ZStack(
  alignment: Alignment = .center,
  @FastArrayBuilder<Element> children: () -> [Element]
) -> Element & Layout {
  ZStackElement(children: children(), alignment: alignment)
}

/// Arranges its elements in a horizontal flow layout, wrapping to a new line when the current line exceeds the bounding space.
public func HFlow(
  itemAlignment: VerticalAlignment = .center,
  lineAlignment: HorizontalAlignment = .center,
  itemSpacing: CGFloat = 0,
  lineSpacing: CGFloat = 0,
  @FastArrayBuilder<Element> children: () -> [Element]
) -> Element & Layout {
  FlowElement(children: children(), mainAxis: .horizontal, itemSpacing: itemSpacing, lineSpacing: lineSpacing, itemAlignmentID: itemAlignment.alignmentID, lineAlignmentID: lineAlignment.alignmentID)
}

/// Arranges its elements in a vertical flow layout, wrapping to a new column when the current column exceeds the bounding space.
/// `itemSpacing` parameter controls the spacing between items on the same column.
/// `lineSpacing` parameter controls the spacing between columns.
/// `itemAlignment` parameter aligns items horizontally within their column.
/// `lineAlignment` parameter aligns columns vertically within the overall layout.
public func VFlow(
  itemAlignment: HorizontalAlignment = .center,
  lineAlignment: VerticalAlignment = .center,
  itemSpacing: CGFloat = 0,
  lineSpacing: CGFloat = 0,
  @FastArrayBuilder<Element> children: () -> [Element]
) -> Element & Layout {
  FlowElement(children: children(), mainAxis: .vertical, itemSpacing: itemSpacing, lineSpacing: lineSpacing, itemAlignmentID: itemAlignment.alignmentID, lineAlignmentID: lineAlignment.alignmentID)
}

/// Arranges its elements in a two-dimensional grid with rows and columns.
/// `horizontalSpacing` parameter controls the spacing between columns.
/// `verticalSpacing` parameter controls the spacing between rows.
/// `alignment` parameter aligns elements within their cells.
/// Each row can specify its own vertical alignment, and individual cells can override alignment using gridCellAnchor modifier.
public func Grid(
  alignment: Alignment = .center,
  horizontalSpacing: CGFloat = 0,
  verticalSpacing: CGFloat = 0,
  @FastArrayBuilder<GridRowElement> rows: () -> [GridRowElement] = { [] }
) -> Element & Layout {
  GridElement(rows: rows(), alignment: alignment, horizontalSpacing: horizontalSpacing, verticalSpacing: verticalSpacing)
}

/// Represents a single row in a Grid layout.
/// Each GridRow contains a horizontal collection of elements that form the cells in that row.
/// `alignment` parameter controls the vertical alignment of elements within a specific row.
public func GridRow(
  alignment: VerticalAlignment? = nil,
  @FastArrayBuilder<Element> children: () -> [Element]
) -> GridRowElement {
  GridRowElement(children: children(), alignment: alignment)
}

/// A flexible space that expands along the main axis of its containing stack.
public func Spacer() -> Element {
  SpacerElement()
}

/// A fixed length spacer. The length is applied only for the main axis of its containing stack.
public func Spacer(_ length: CGFloat) -> Element {
  SpacerElement(length: length)
}

public func Spacer(minLength: CGFloat) -> FastExpression {
  BlockExpression(expressions: [ValueExpression<Element>(value: Spacer()), ValueExpression<Element>(value: SpacerElement(length: minLength))])
}

/// Null object pattern. Sizes to zero.
public func EmptyLayout() -> Element & Layout {
  EmptyElement()
}

public extension Element {

  /// Constrains the elements’s dimensions to an aspect ratio specified by a CGSize.
  /// If this view is resizable, it uses aspectRatio as its own aspect ratio.
  func aspectRatio(_ ratio: CGSize, contentMode: ContentMode = .fit) -> Element & Layout {
    AspectRatioElement(child: self, aspectRatio: ratio.width / ratio.height, contentMode: contentMode)
  }

  /// Adds the desired amount of space to the edges of this element.
  /// The leading and trailing margins are applied appropriately to the left or right margins based on the current layout direction.
  /// For example, the leading margin is applied to the right edge of the view in right-to-left layouts.
  func padding(_ edges: EdgeSet = .all, _ length: CGFloat) -> Element & Layout {
    PaddingElement(child: self, edges: edges, length: length)
  }

  /// Adds the desired amount of space to the edges of this element.
  /// The leading and trailing margins are applied appropriately to the left or right margins based on the current layout direction.
  /// For example, the leading margin is applied to the right edge of the view in right-to-left layouts.
  func padding(_ insets: EdgeInsets) -> Element & Layout {
    PaddingElement(child: self, insets: insets)
  }

  /// Adds the desired amount of space to all edges of this element.
  func padding(_ length: CGFloat) -> Element & Layout {
    PaddingElement(child: self, edges: .all, length: length)
  }

  func padding(ignoringLayoutDirection insets: UIEdgeInsets) -> Element & Layout {
    PaddingElement(child: self, insets: insets)
  }

  /// Offsets the child element by the specified amount.
  func offset(x: CGFloat = 0, y: CGFloat = 0) -> Element & Layout {
    OffsetElement(child: self, offset: CGPoint(x: x, y: y))
  }

  /// Fixed Frame Modifier
  /// Positions the child element within an invisible container with the specified size.
  /// The modifier doesn’t change the size of its child element but acts more like a “picture frame” by letting the child be any size it wants and only positioning it inside its own bounds.
  /// If you want to "assign" a size to the child view, use the view.resizable().frame(width: l1, height: l2) modifier.
  /// If you omit a constraint (or pass nil), the frame will use the sizing behavior of its child element for that axis.
  /// When using this method, you must provide at least one size constraint.
  ///
  /// Negative, nan, and infinite values are ignored.
  func frame(
    width: CGFloat? = nil,
    height: CGFloat? = nil,
    alignment: Alignment = .center
  ) -> Element & Layout {
    FixedFrameElement(
      child: self,
      width: width,
      height: height,
      alignment: alignment
    )
  }

  /// Flexible Frame Modifier
  /// Positions the child element inside an invisible, flexible container.
  /// The modifier doesn’t change the size of its child element but acts more like a “picture frame” by letting the child be any size it wants and only positioning it inside its own bounds.
  /// If you omit a constraint (or pass nil), the frame will use the sizing behavior of its child element for that axis.
  /// When using this method, you must provide at least one size constraint.
  func frame(
    minWidth: CGFloat? = nil,
    maxWidth: CGFloat? = nil,
    minHeight: CGFloat? = nil,
    maxHeight: CGFloat? = nil,
    alignment: Alignment = .center
  ) -> Element & Layout {
    FlexibleFrameElement(
      child: self,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      alignment: alignment
    )
  }

  /// Fixed Size Modifier
  /// Replaces the proposed size of the child with the infinity.
  func fixedSize(axis: AxisSet = [.horizontal, .vertical]) -> Element & Layout {
    FixedSizeElement(child: self, horizontal: axis.contains(.horizontal), vertical: axis.contains(.vertical))
  }

  /// Sets the priority by which a parent V/HStack should allocate space to this child.
  /// A view's default priority is 0, which distributes available space evenly to all sibling views.
  /// Set a higher priority to measure the view first with a larger portion of available space.
  func layoutPriority(_ priority: CGFloat) -> Element {
    LayoutPriorityElement(child: self, layoutPriority: priority)
  }

  /// Overrides the default layout direction.
  /// Doesn't affect the layout direction of child views.
  func layoutDirection(_ direction: LayoutDirection) -> Element & Layout {
    LayoutDirectionElement(child: self, layoutDirection: direction)
  }

  /// Positions the content view within the frame of the target view.
  /// The modifier measures the target view, proposes the target view's size to the content view, and then aligns it within the frame of the target view.
  /// See also ZStack.
  func overlay(alignment: Alignment = .center, @LayoutBuilder content: () -> Element?) -> Element & Layout {
    LayeringElement(
      target: self,
      layer: content() ?? EmptyLayout(),
      type: .overlay,
      alignment: alignment
    )
  }

  /// Positions the content view within the frame of the target view.
  /// The modifier measures the target view, proposes the target view's size to the content view, and then aligns it within the frame of the target view.
  /// See also ZStack.
  func background(alignment: Alignment = .center, @LayoutBuilder content: () -> Element?) -> Element & Layout {
    LayeringElement(
      target: self,
      layer: content() ?? EmptyLayout(),
      type: .background,
      alignment: alignment
    )
  }

  /// When the specified horizontal alignment is being applied, the child
  /// element will be positioned according to the computed alignment value.
  func alignmentGuide(_ horizontalAlignment: HorizontalAlignment, computeValue: @escaping @Sendable (ViewDimensions) -> CGFloat) -> Element & Layout {
    AlignmentGuideElement(child: self, horizontalAlignment: horizontalAlignment, computeValue: computeValue)
  }

  /// When the specified vertical alignment is being applied, the child
  /// element will be positioned according to the computed alignment value.
  func alignmentGuide(_ verticalAlignment: VerticalAlignment, computeValue: @escaping @Sendable (ViewDimensions) -> CGFloat) -> Element & Layout {
    AlignmentGuideElement(child: self, verticalAlignment: verticalAlignment, computeValue: computeValue)
  }

  /// Grid cell Anchor Modifier
  /// Positions the child view within the cell of the grid.
  /// The modifier doesn’t change the size of its child directly but lets the child be
  /// any size it wants and only positioning it inside its own bounds.
  /// The modifier will always override the alignment set by the row or column.
  func gridCellAnchor(_ alignment: Alignment = .center) -> Element & Layout {
    GridCellAnchorElement(child: self, alignment: alignment)
  }

  func gridCellAnchor(_ unitPoint: UnitPoint) -> Element & Layout {
    GridCellAnchorElement(child: self, unitPoint: unitPoint)
  }

  /// Grid Column Alignment Modifier
  /// Overrides the default horizontal alignment of a grid column.
  /// The alignment will be applied to all elements in the same column as this element.
  func gridColumnAlignment(_ alignment: HorizontalAlignment = .center) -> Element & Layout {
    GridColumnAlignmentElement(child: self, alignment: alignment)
  }
}

public extension LeafElement {

  /// Makes the view ignore its intrinsic size (size returned by sizeThatFits) so it becomes fully flexible along both axes.
  /// If only one axis is specified, the target view intrinsic size is preserved along the other axis.
  func resizable(axis: AxisSet = [.horizontal, .vertical]) -> Element & Layout {
    ResizableElement(child: self, axis: axis)
  }

  /// Measures the intrinsic size of the view and then adds the additional size.
  /// Nans and infinite values are ignored.
  func expand(by size: CGSize) -> Element & Layout {
    ExpandableElement(child: self, size: size)
  }
}

extension StackElement {

  /// Ideal Layout Modifier
  /// If enabled, the stack use the ideal layout algorithm to make children have equal size along the cross axis.
  public func idealLayout(_ enabled: Bool = true) -> StackElement {
    StackElement(
      children: children,
      mainAxis: mainAxis,
      spacing: spacing,
      alignmentID: alignmentID,
      idealLayout: enabled
    )
  }
}

extension UIView {

  /// Adds the given views as subviews of this view.
  public func addSubviews(@FastArrayBuilder<UIView> views: () -> [UIView]) {
    let viewList = views
    for v in viewList() {
      addSubview(v)
    }
  }
}

public func ForEach(_ list: [Element]) -> FastExpression {
  BlockExpression(expressions: list.map { ValueExpression<Element>(value: $0) })
}

public func ForEach(_ list: [Element], map: (Element) -> Element) -> FastExpression {
  BlockExpression(expressions: list.map { ValueExpression<Element>(value: map($0)) })
}

public func ForEach(_ list: [UIView], map: (UIView) -> Element) -> FastExpression {
  BlockExpression(expressions: list.map { ValueExpression<Element>(value: map($0)) })
}

public typealias Alignment = QuickLayoutCore.Alignment
public typealias AlignmentID = QuickLayoutCore.AlignmentID
public typealias Axis = QuickLayoutCore.Axis
public typealias ContentMode = QuickLayoutCore.ContentMode
public typealias EdgeInsets = QuickLayoutCore.EdgeInsets
public typealias Element = QuickLayoutCore.Element
public typealias LeafElement = QuickLayoutCore.LeafElement
public typealias Flexibility = QuickLayoutCore.Flexibility
public typealias HorizontalAlignment = QuickLayoutCore.HorizontalAlignment
public typealias Layout = QuickLayoutCore.Layout
public typealias LayoutDirection = QuickLayoutCore.LayoutDirection
public typealias VerticalAlignment = QuickLayoutCore.VerticalAlignment
public typealias ViewDimensions = QuickLayoutCore.ElementDimensions
public typealias StackElement = QuickLayoutCore.StackElement

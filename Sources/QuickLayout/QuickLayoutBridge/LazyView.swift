/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutCore

public struct LazyView<ViewType> {
  // MARK: - Setup
  private final class DeferredView {
    private enum State {
      case deferred(_ initializer: () -> ViewType)
      case resolved(value: ViewType)
    }

    private var state: State

    init(_ initializer: @escaping () -> ViewType) {
      self.state = .deferred(initializer)
    }

    var resolved: ViewType {
      switch state {
      case .deferred(let initializer):
        let result = initializer()
        state = .resolved(value: result)
        return result
      case .resolved(let value):
        return value
      }
    }

    var ifResolved: ViewType? {
      switch state {
      case .deferred:
        return nil
      case .resolved(let value):
        return value
      }
    }

    var isResolved: Bool {
      switch state {
      case .deferred:
        return false
      case .resolved:
        return true
      }
    }
  }

  private let view: DeferredView

  // MARK: - API

  public init(_ view: @escaping () -> ViewType) {
    self.view = DeferredView(view)
  }

  public var ifLoaded: ViewType? {
    view.ifResolved
  }

  public var isLoaded: Bool {
    view.isResolved
  }

  @discardableResult public func loadIfNeeded() -> ViewType {
    view.resolved
  }
}

extension LazyView: Element where ViewType: Element {
  public func quick_layoutThatFits(_ proposedSize: CGSize) -> LayoutNode {
    loadIfNeeded().quick_layoutThatFits(proposedSize)
  }

  public func quick_flexibility(for axis: Axis) -> Flexibility {
    loadIfNeeded().quick_flexibility(for: axis)
  }

  public func quick_layoutPriority() -> CGFloat {
    loadIfNeeded().quick_layoutPriority()
  }

  public func quick_extractViewsIntoArray(_ views: inout [UIView]) {
    loadIfNeeded().quick_extractViewsIntoArray(&views)
  }
}

extension LazyView: LeafElement where ViewType: LeafElement {
  public func backingView() -> UIView? {
    loadIfNeeded().backingView()
  }
}

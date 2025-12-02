/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutCore
@_exported import UIKit

@MainActor
public protocol HasBody {
  @LayoutBuilder var body: Layout { get }
}

extension HasBody where Self: UIView {
  /// Returns the body size if isBodyEnabled is true, otherwise nil.
  public func bodySizeThatFits(_ size: CGSize) -> CGSize? {
    return _QuickLayoutViewImplementation.sizeThatFits(self, size: size)
  }
}

@MainActor @objc(QLBodyCoordinationExperiments)
public class BodyCoordinationExperiments: NSObject {
  @objc static public var preventUnusedCollectionViewCellSizing: Bool = true
}

// MARK: - Public

extension UIView {

  @objc(quick_bodyContainerView) /// Provide unique name for ObjC runtime to avoid method name collision.
  open var bodyContainerView: UIView {
    return self
  }

  @objc(quick_isBodyEnabled) /// Provide unique name for ObjC runtime to avoid method name collision.
  open var isBodyEnabled: Bool {
    return true
  }

  @objc(quick_isBodySizingEnabled) /// Provide unique name for ObjC runtime to avoid method name collision.
  internal var isBodySizingEnabled: Bool {
    return true
  }

  @objc(quick_isCachingEnabled) /// Provide unique name for ObjC runtime to avoid method name collision.
  open var isCachingEnabled: Bool {
    return false
  }

}

extension UICollectionViewCell {
  override open var bodyContainerView: UIView {
    return contentView
  }
  override var isBodySizingEnabled: Bool {
    guard BodyCoordinationExperiments.preventUnusedCollectionViewCellSizing else { return true }
    // Disable self sizing if the collection view layout will request sizing info unnecessarily.
    // When the preferred attribute selector is overriden from the base class, we need to provide
    // sizing info as this means the layout may need the sizing. UITableView does not have the same
    // problem, this is specific to UICollectionView.
    let preferredFittingSelector = #selector(UICollectionViewLayout.shouldInvalidateLayout(forPreferredLayoutAttributes:withOriginalAttributes:))
    guard let collectionView = superview as? UICollectionView else { return true }
    return collectionView.collectionViewLayout.method(for: preferredFittingSelector) != UICollectionViewLayout.instanceMethod(for: preferredFittingSelector)
  }
}

extension UITableViewCell {
  override open var bodyContainerView: UIView {
    return contentView
  }
}

extension UITableViewHeaderFooterView {
  override open var bodyContainerView: UIView {
    return contentView
  }
}

extension UIVisualEffectView {
  override open var bodyContainerView: UIView {
    return contentView
  }
}

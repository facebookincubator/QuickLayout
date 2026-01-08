/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

private let appearanceAnimationKey = "BodyAppearanceCoordinator-appearance"
private let disappearanceAnimationKey = "BodyAppearanceCoordinator-disappearance"
private let disappearanceAnimationIDKey = "BodyAppearanceCoordinator-disappearance-id"

@MainActor
final class BodyAppearanceCoordinator: NSObject {
  private var disappearanceAnimationID: Int = 0
  private var appearingViews: Set<UIView> = []
  private var activeViews: Set<UIView> = []
  private var appearingViewAnimationKeys: [UIView: Set<String>] = [:]
  private var disappearingViewAnimations: [Int: Weak<UIView>] = [:]
  private var disableViewAppearanceAnimations: Bool = false
  private weak var targetWindow: UIWindow?

  // MARK: - API

  func coordinateMove(to newWindow: UIWindow?) {
    targetWindow = newWindow
    if newWindow != nil {
      disableViewAppearanceAnimations = true
      // When moving window, we don't want to animate view appearance.
      // The animations applied by this class are intended for transitions
      // between onscreen view states. Applying animations as the body
      // itself moves on and offscreen is not intended; these animations
      // are external to the body and applying additional animations
      // would not be expected.
      DispatchQueue.main.async { [weak self] in
        guard self?.targetWindow == newWindow else { return }
        self?.disableViewAppearanceAnimations = false
      }
    } else {
      disableViewAppearanceAnimations = false
    }
  }

  func coordinateAppearance(of view: UIView, in superview: UIView, index: Int) {
    appearingViews.insert(view)
    activeViews.insert(view)
    superview.insertSubview(view, at: index)
    animateAppearanceIfNeeded(for: view)
  }

  func coordinateDisappearance(of view: UIView) {
    appearingViews.remove(view)
    activeViews.remove(view)
    performDisappearanceWithAnimationIfNeeded(for: view)
  }

  func beginViewAppearanceUpdates() {
    appearingViewAnimationKeys = appearingViews.reduce(into: [:]) { partialResult, view in
      partialResult[view] = view.animationKeys
    }
  }

  func commitViewAppearanceUpdates() {
    for (view, existingAnimationKeys) in appearingViewAnimationKeys {
      let disallowedAnimationKeys = view.animationKeys.subtracting(existingAnimationKeys)
      view.removeAnimations(for: disallowedAnimationKeys)
    }
    appearingViews.removeAll()
    appearingViewAnimationKeys.removeAll()
  }

  // MARK: - CAAnimationDelegate

  func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
    guard let animationID = animation.value(forKey: disappearanceAnimationIDKey) as? Int else { return }
    defer { disappearingViewAnimations[animationID] = nil }
    guard let view = disappearingViewAnimations[animationID]?.value else { return }
    view.layer.removeAnimation(forKey: disappearanceAnimationKey)
    guard !activeViews.contains(view) else { return }
    view.removeFromSuperview()
  }

  // MARK: - Private

  private func animateAppearanceIfNeeded(for view: UIView) {
    guard UIView.inheritedAnimationDuration > 0 && !disableViewAppearanceAnimations else { return }
    let animation = buildOpacityAnimation(initialOpacity: 0, targetOpacity: view.alpha)
    view.layer.add(animation, forKey: appearanceAnimationKey)
  }

  private func performDisappearanceWithAnimationIfNeeded(for view: UIView) {
    guard UIView.inheritedAnimationDuration > 0 else {
      view.removeFromSuperview()
      return
    }
    let animation = buildOpacityAnimation(initialOpacity: view.alpha, targetOpacity: 0)
    animation.delegate = self
    animation.setValue(disappearanceAnimationID, forKey: disappearanceAnimationIDKey)
    disappearingViewAnimations[disappearanceAnimationID] = Weak(value: view)
    view.layer.add(animation, forKey: disappearanceAnimationKey)
    disappearanceAnimationID += 1
  }

  private func buildOpacityAnimation(initialOpacity: CGFloat, targetOpacity: CGFloat) -> CABasicAnimation {
    let animation = CABasicAnimation(keyPath: "opacity")
    animation.duration = UIView.inheritedAnimationDuration
    animation.fillMode = .forwards
    animation.isRemovedOnCompletion = false
    animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    animation.fromValue = initialOpacity
    animation.toValue = targetOpacity
    return animation
  }
}

fileprivate extension UIView {
  var animationKeys: Set<String> {
    return Set(layer.animationKeys() ?? [])
  }

  func removeAnimations(for animationKeys: Set<String>) {
    animationKeys.forEach { layer.removeAnimation(forKey: $0) }
  }
}

#if compiler(>=6)
extension BodyAppearanceCoordinator: @preconcurrency CAAnimationDelegate {}
#else
extension BodyAppearanceCoordinator: CAAnimationDelegate {}
#endif

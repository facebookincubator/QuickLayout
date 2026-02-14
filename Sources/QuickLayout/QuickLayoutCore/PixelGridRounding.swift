/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation
import UIKit

private struct ScreenScale {
  static let value: CGFloat = {
    var scale: CGFloat = 1.0
    #if !os(visionOS)
    if Thread.isMainThread {
      MainActor.assumeIsolated { // patternlint-disable-line swift-mainactor-assumeisolated
        scale = UIScreen.main.scale
      }
    } else {
      DispatchQueue.main.sync {
        scale = UIScreen.main.scale
      }
    }
    #endif
    return scale
  }()
}

private let _tolerance = 0.0001

private enum ValueType {
  /// Rounding rule for position. The rounding based on "school book math" with extra rounding tolerance. The value maybe rounded down.
  case position

  /// Rounding rule for size. The value is never rounded down.
  case size
}

@inline(__always)
func roundPositionToPixelGrid(_ value: CGFloat, screenScale: CGFloat = ScreenScale.value) -> CGFloat {
  round(value, valueType: .position, screenScale: screenScale)
}

/// Never rounds down.
@inline(__always)
func roundSizeToPixelGrid(_ value: CGFloat, screenScale: CGFloat = ScreenScale.value) -> CGFloat {
  round(value, valueType: .size, screenScale: screenScale)
}

@inline(__always)
func roundToPixelGrid(_ p: CGPoint) -> CGPoint {
  let screenScale = ScreenScale.value
  return CGPoint(
    x: round(p.x, valueType: .position, screenScale: screenScale),
    y: round(p.y, valueType: .position, screenScale: screenScale)
  )
}

@inline(__always)
func roundToPixelGrid(_ s: CGSize) -> CGSize {
  let screenScale = ScreenScale.value
  return CGSize(
    width: round(s.width, valueType: .size, screenScale: screenScale),
    height: round(s.height, valueType: .size, screenScale: screenScale)
  )
}

private func round(_ value: CGFloat, valueType: ValueType, screenScale: CGFloat) -> CGFloat {
  let modfValue = modf(value)
  let integerPart = modfValue.0
  let fractionalPart = modfValue.1
  if -_tolerance <= fractionalPart && fractionalPart <= _tolerance {
    // If fractional part is 0, then no need to round.
    return integerPart
  }
  return integerPart + roundFraction(fractionalPart, valueType: valueType, screenScale: screenScale)
}

/// Usually rounding is done with ((v * screenScale).rounded() / screenScale), but this method rounds value such as 1.249999 to 1.5 instead of 1.
@inline(__always)
private func roundFraction(_ value: CGFloat, valueType: ValueType, screenScale: CGFloat) -> CGFloat {
  let rounding = value > 0 ? _tolerance : -_tolerance
  switch valueType {
  case .position: return (value * screenScale + rounding).rounded(.toNearestOrAwayFromZero) / screenScale
  /// Adding rounding so value like 1.249999 is rounded to 1.5 instead of 1.
  case .size: return (value * screenScale).rounded(.awayFromZero) / screenScale // Using awayFromZero to avoid rounding down.
  }
}

/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import Foundation

/// Fuzzy comparisons for CGFloats, allowing for a tolerance based equality check and inequality check.
/// Note that it uses the default tolerance of 0.0001, as it's sufficient for pixel value comparison.
/// However, if used for other purposes, it's recommended to pass smaller tolerance or use CGFloat.ulp.
/// The following values will be treated as equal with the default tolerance:
/// a = 1.00001
/// b = 1.000011
/// or
/// a 58.666666666666664
/// b 58.66666666666666
///
struct Fuzzy {

  @inlinable
  static func compare<T: FloatingPoint>(_ this: T, equalTo other: T, tolerance: T = T.defaultTolerance) -> Bool {
    if this.isNaN || other.isNaN { return false }
    if this == other { return true }
    if this.isInfinite || other.isInfinite { return this == other }
    return abs(this - other) <= tolerance
  }

  @inlinable
  static func compare<T: FloatingPoint>(_ this: T, lessThan other: T, tolerance: T = T.defaultTolerance) -> Bool {
    this < other && !Fuzzy.compare(this, equalTo: other, tolerance: tolerance)
  }

  @inlinable
  static func compare<T: FloatingPoint>(_ this: T, greaterThan other: T, tolerance: T = T.defaultTolerance) -> Bool {
    this > other && !Fuzzy.compare(this, equalTo: other, tolerance: tolerance)
  }

  @inlinable
  static func compare<T: FloatingPoint>(_ this: T, lessThanOrEqual other: T, tolerance: T = T.defaultTolerance) -> Bool {
    this < other || Fuzzy.compare(this, equalTo: other, tolerance: tolerance)
  }

  @inlinable
  static func compare<T: FloatingPoint>(_ this: T, greaterThanOrEqual other: T, tolerance: T = T.defaultTolerance) -> Bool {
    this > other || Fuzzy.compare(this, equalTo: other, tolerance: tolerance)
  }
}

private extension FloatingPoint {
  // The default tolerance is 0.0001
  static var defaultTolerance: Self { Self(1) / Self(10000) }
}

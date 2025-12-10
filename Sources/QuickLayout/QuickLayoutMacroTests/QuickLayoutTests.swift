/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(QuickLayoutMacro)
@testable import QuickLayoutMacro

// patternlint-disable meta-subclass-view

let testMacros: [String: Macro.Type] = [
  "QuickLayout": QuickLayout.self,
  "_QuickLayoutInjection": QuickLayoutInjection.self,
]

class QuickLayoutTests: XCTestCase {
  func testBasicMacroExpansion() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testApplicableMethodsDeferToProvidedImplementation() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }

        public func sizeThatFits(_ size: CGSize) -> CGSize {
          return uniqueSizeValue
        }

        public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
          return uniqueFlexibilityValue
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          public func sizeThatFits(_ size: CGSize) -> CGSize {
            return uniqueSizeValue
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return uniqueFlexibilityValue
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testApplicableMethodsInjectQuickLayoutBridgeementation() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }

        public override func willMove(toWindow newWindow: UIWindow?) {
          super.willMove(toWindow: newWindow)
          someUniqueWillMoveToWindowLogic()
        }

        public override func layoutSubviews() {
          super.layoutSubviews()
          someUniqueLayoutSubviewsLogic()
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
            someUniqueWillMoveToWindowLogic()
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
            someUniqueLayoutSubviewsLogic()
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testTypeScopedFunctionsDoNotConflict() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }

        static func sizeThatFits(_ size: CGSize) -> CGSize {
          return uniqueSizeValue
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          static func sizeThatFits(_ size: CGSize) -> CGSize {
            return uniqueSizeValue
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testOverloadedFunctionsDoNotConflict() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }

        func sizeThatFits(_ size: CGSize) -> NotACGSize {
          return uniqueSizeValue
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          func sizeThatFits(_ size: CGSize) -> NotACGSize {
            return uniqueSizeValue
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testParameterMismatchedFunctionsDoNotConflict() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }

        func sizeThatFits(_ notASize: NotACGSize) -> CGSize {
          return uniqueSizeValue
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          func sizeThatFits(_ notASize: NotACGSize) -> CGSize {
            return uniqueSizeValue
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testLayoutBuilderAttributeNotAddedIfPresent() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        @LayoutBuilder
        var body: Layout {
          EmptyLayout()
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testLayoutBuilderAttributeOnlyAddedToBody() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }

        var notBody: Layout {
          EmptyLayout()
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: Layout {
            EmptyLayout()
          }

          var notBody: Layout {
            EmptyLayout()
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }

  func testLayoutBuilderAttributeAppliesToAnyLayout() throws {
    assertMacroExpansion(
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: any Layout {
          EmptyLayout()
        }
      }
      """#,
      expandedSource:
        #"""
        class TestView: UIView {
          @LayoutBuilder
          var body: any Layout {
            EmptyLayout()
          }

          public override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
          }

          public override func layoutSubviews() {
            super.layoutSubviews()
            _QuickLayoutViewImplementation.layoutSubviews(self)
          }

          public override func sizeThatFits(_ size: CGSize) -> CGSize {
            return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
          }

          public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> Flexibility {
            return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
          }
        }

        extension TestView: HasBody {
        }
        """#,
      macros: testMacros,
      indentationWidth: .spaces(2)
    )
  }
}
#endif

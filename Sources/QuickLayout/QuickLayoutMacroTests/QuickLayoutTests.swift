/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroTesting
#if canImport(QuickLayoutMacro)
@testable import QuickLayoutMacro

// patternlint-disable meta-subclass-view

class QuickLayoutTests: XCTestCase {
  override func invokeTest() {
    withMacroTesting(
      record: .failed,
      macros: [
        "QuickLayout": QuickLayout.self,
        "_QuickLayoutInjection": QuickLayoutInjection.self,
      ]
    ) {
      super.invokeTest()
    }
  }

  func testBasicMacroExpansion() throws {
    assertMacro {
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: Layout {
          EmptyLayout()
        }
      }
      """#
    } expansion: {
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
      """#
    }
  }

  func testApplicableMethodsDeferToProvidedImplementation() throws {
    assertMacro {
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
      """#
    } expansion: {
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
      """#
    }
  }

  func testApplicableMethodsInjectQuickLayoutBridgeementation() throws {
#if compiler(>=6)
    assertMacro {
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
      """#
    } expansion: {
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
      """#
    }
#else
    assertMacro {
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
      """#
    } diagnostics: {
     """
     @QuickLayout
     class TestView: UIView {
       var body: Layout {
         EmptyLayout()
       }

       public override func willMove(toWindow newWindow: UIWindow?) {
       ╰─ 🛑 方法 'willMove' 缺少必要的实现调用。在 Swift 6.0 以下，你必须手动添加以下调用：
     _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
         super.willMove(toWindow: newWindow)
         someUniqueWillMoveToWindowLogic()
       }

       public override func layoutSubviews() {
       ╰─ 🛑 方法 'layoutSubviews' 缺少必要的实现调用。在 Swift 6.0 以下，你必须手动添加以下调用：
     _QuickLayoutViewImplementation.layoutSubviews(self)
         super.layoutSubviews()
         someUniqueLayoutSubviewsLogic()
       }
     }
     """
    }
    assertMacro {
      #"""
      @QuickLayout
      class TestView: UIView {
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
      }
      """#
    } expansion: {
     """
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
     """
    }
#endif
  }

  func testTypeScopedFunctionsDoNotConflict() throws {
    assertMacro {
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
      """#
    } expansion: {
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
      """#
    }
  }

  func testOverloadedFunctionsDoNotConflict() throws {
    assertMacro {
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
      """#
    } expansion: {
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
      """#
    }
  }

  func testParameterMismatchedFunctionsDoNotConflict() throws {
    assertMacro {
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
      """#
    } expansion: {
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
      """#
    }
  }

  func testLayoutBuilderAttributeNotAddedIfPresent() throws {
    assertMacro {
      #"""
      @QuickLayout
      class TestView: UIView {
        @LayoutBuilder
        var body: Layout {
          EmptyLayout()
        }
      }
      """#
    } expansion: {
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
      """#
    }
  }

  func testLayoutBuilderAttributeOnlyAddedToBody() throws {
    assertMacro {
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
      """#
    } expansion: {
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
      """#
    }
  }

  func testLayoutBuilderAttributeAppliesToAnyLayout() throws {
    assertMacro {
      #"""
      @QuickLayout
      class TestView: UIView {
        var body: any Layout {
          EmptyLayout()
        }
      }
      """#
    } expansion: {
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
      """#
    }
  }
}
#endif

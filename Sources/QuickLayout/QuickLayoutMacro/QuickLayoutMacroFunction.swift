/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntax

/**
 Defines the functions that the @QuickLayout macro interacts with.
*/
enum QuickLayoutMacroFunction: CaseIterable {

  /**
   Defines how functions handle collisions with existing implementations.
  */
  enum CollisionBehavior {
    case injectIntoProvidedDefinition(_ impl: (FunctionDeclSyntax) -> String)
    case deferToProvidedDefinition
  }

  case willMoveToWindow
  case layoutSubviews
  case sizeThatFits
  case quick_flexibility
}

/**
 Defines behavior and attributes for each QuickLayoutMacroFunction case.
*/
extension QuickLayoutMacroFunction {
  var identity: QuickLayoutFunctionIdentity {
    switch self {
    case .willMoveToWindow:
      .init(scope: .instance, name: "willMove", parameters: [(externalName: "toWindow", type: "UIWindow?")], returnType: "Void")
    case .layoutSubviews:
      .init(scope: .instance, name: "layoutSubviews", parameters: [], returnType: "Void")
    case .sizeThatFits:
      .init(scope: .instance, name: "sizeThatFits", parameters: [(externalName: nil, type: "CGSize")], returnType: "CGSize")
    case .quick_flexibility:
      .init(scope: .instance, name: "quick_flexibility", parameters: [(externalName: "for", type: "Axis")], returnType: "Flexibility")
    }
  }

  var standaloneImplementation: String {
    switch self {
    case .willMoveToWindow:
      """

      public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        _QuickLayoutViewImplementation.willMove(self, toWindow: newWindow)
      }

      """
    case .layoutSubviews:
      """

      public override func layoutSubviews() {
        super.layoutSubviews()
        _QuickLayoutViewImplementation.layoutSubviews(self)
      }

      """
    case .sizeThatFits:
      """

      public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return _QuickLayoutViewImplementation.sizeThatFits(self, size: size) ?? super.sizeThatFits(size)
      }

      """
    case .quick_flexibility:
      """

      public override func quick_flexibility(for axis: QuickLayoutCore.Axis) -> QuickLayoutCore.Flexibility {
        return _QuickLayoutViewImplementation.quick_flexibility(self, for: axis) ?? super.quick_flexibility(for: axis)
      }

      """
    }
  }

  var collisionBehavior: CollisionBehavior {
    switch self {
    case .willMoveToWindow:
      .injectIntoProvidedDefinition { functionSyntax in
        let windowParameterName = functionSyntax.parameterName(at: 0)
        return "_QuickLayoutViewImplementation.willMove(self, toWindow: \(windowParameterName))"
      }
    case .layoutSubviews:
      .injectIntoProvidedDefinition { _ in
        return "_QuickLayoutViewImplementation.layoutSubviews(self)"
      }
    case .sizeThatFits: .deferToProvidedDefinition
    case .quick_flexibility: .deferToProvidedDefinition
    }
  }
}

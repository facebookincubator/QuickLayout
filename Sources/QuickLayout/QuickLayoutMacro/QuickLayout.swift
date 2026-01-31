/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntax
import SwiftSyntaxMacros

public struct QuickLayout: ExtensionMacro, MemberMacro, MemberAttributeMacro {
  // MARK: - ExtensionMacro

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let accessPrefix: String
    if let modifier = declaration.accessModifier {
      accessPrefix = "\(modifier) "
    } else {
      accessPrefix = ""
    }
    let declSyntax: DeclSyntax =
      """
      \(raw: accessPrefix)extension \(type.trimmed): HasBody {}
      """
    guard let extensionSyntax = declSyntax.as(ExtensionDeclSyntax.self) else {
      return []
    }
    return [extensionSyntax]
  }

  // MARK: - MemberMacro

  public static func expansion(
    of node: SwiftSyntax.AttributeSyntax,
    providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax,
    in context: some SwiftSyntaxMacros.MacroExpansionContext
  ) throws -> [SwiftSyntax.DeclSyntax] {
    let memberFunctions = declaration.memberFunctions.map { $0.identity }
    var memberSyntax: String = ""
    for macroFunction in QuickLayoutMacroFunction.allCases {
      guard !memberFunctions.contains(macroFunction.identity) else {
        continue
      }
      memberSyntax += macroFunction.standaloneImplementation
    }
    return [DeclSyntax(stringLiteral: memberSyntax)]
  }

  // MARK: - MemberAttributeMacro

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingAttributesFor member: some DeclSyntaxProtocol,
    in context: some MacroExpansionContext
  ) throws -> [AttributeSyntax] {
    if let memberFunction = member.function {
      for macroFunction in QuickLayoutMacroFunction.allCases {
        guard macroFunction.identity == memberFunction.identity else {
          continue
        }
        switch macroFunction.collisionBehavior {
        case .deferToProvidedDefinition:
          continue
        case .injectIntoProvidedDefinition(let impl):
          return ["@_QuickLayoutInjection(\"\(raw: impl(memberFunction))\")"]
        }
      }
    } else if let memberVariable = member.variable {
      for macroVariable in QuickLayoutMacroVariable.allCases {
        guard macroVariable.identity == memberVariable.identity else {
          continue
        }
        switch macroVariable.memberBehavior {
        case .prependLayoutBuilderAttribute:
          guard !memberVariable.modifierNames.contains("LayoutBuilder") else {
            continue
          }
          return ["@LayoutBuilder"]
        }
      }
    }
    return []
  }
}

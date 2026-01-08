/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntax
import SwiftSyntaxMacros
import SwiftDiagnostics
import Foundation

enum QuickLayoutDiagnostic: DiagnosticMessage {
  case missingRequiredImplementation(functionName: String, requiredCall: String)

  var message: String {
    switch self {
    case .missingRequiredImplementation(let functionName, let requiredCall):
      return "Method '\(functionName)' is missing required implementation call. Below Swift 6.0, you must manually add the following call:\n\(requiredCall)"
    }
  }

  var diagnosticID: MessageID {
    MessageID(domain: "QuickLayout", id: "missingRequiredImplementation")
  }

  var severity: DiagnosticSeverity {
    .error
  }
}

public struct QuickLayout: ExtensionMacro, MemberMacro, MemberAttributeMacro {
  // MARK: - ExtensionMacro

  public static func expansion(
    of node: AttributeSyntax,
    attachedTo declaration: some DeclGroupSyntax,
    providingExtensionsOf type: some TypeSyntaxProtocol,
    conformingTo protocols: [TypeSyntax],
    in context: some MacroExpansionContext
  ) throws -> [ExtensionDeclSyntax] {
    let declSyntax: DeclSyntax =
      """
      extension \(type.trimmed): HasBody {}
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
#if compiler(>=6)
          return ["@_QuickLayoutInjection(\"\(raw: impl(memberFunction))\")"]
#else
          // 在 Swift 6.0 以下，检查方法体中是否已包含必要的实现调用
          let requiredCall = impl(memberFunction)
          let functionBody = memberFunction.body?.statements.description ?? ""

          // 检查方法体中是否包含必要的调用
          if (functionBody as NSString).contains(requiredCall) {
            // 已经包含必要的实现，跳过
            continue
          } else {
            // 缺少必要的实现，抛出诊断错误
            let diagnostic = Diagnostic(
              node: memberFunction,
              message: QuickLayoutDiagnostic.missingRequiredImplementation(
                functionName: memberFunction.name.text,
                requiredCall: requiredCall
              )
            )
            context.diagnose(diagnostic)
            continue
          }
#endif
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

/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import SwiftSyntax
import SwiftSyntaxMacros

private let accessModifierNames: Set<String> = ["public", "private", "internal", "fileprivate"]

extension DeclGroupSyntax {
  var memberFunctions: [FunctionDeclSyntax] {
    return memberBlock.members.compactMap {
      $0.decl.function
    }
  }

  var accessModifier: String? {
    let modifiers: DeclModifierListSyntax?
    switch self {
    case let decl as ClassDeclSyntax:
      modifiers = decl.modifiers
    case let decl as StructDeclSyntax:
      modifiers = decl.modifiers
    case let decl as EnumDeclSyntax:
      modifiers = decl.modifiers
    case let decl as ActorDeclSyntax:
      modifiers = decl.modifiers
    default:
      modifiers = nil
    }
    guard let modifiers else { return nil }
    return modifiers.lazy
      .map { $0.name.text }
      .first { accessModifierNames.contains($0) }
  }
}

extension DeclSyntaxProtocol {
  var function: FunctionDeclSyntax? {
    return self.as(FunctionDeclSyntax.self)
  }

  var variable: VariableDeclSyntax? {
    return self.as(VariableDeclSyntax.self)
  }
}

extension FunctionDeclSyntax {
  func parameterName(at index: Int) -> String {
    let paramaterSyntax = signature.parameterClause.parameters.map { $0 }[index]
    return paramaterSyntax.internalName.text
  }

  var identity: QuickLayoutFunctionIdentity {
    let isScopedToType = modifiers.contains {
      $0.name.text == "static" || $0.name.text == "class"
    }
    let parameters = signature.parameterClause.parameters.map {
      (externalName: $0.externalName.text == "_" ? nil : $0.externalName.text, type: $0.type.description)
    }
    let returnType = signature.returnClause?.type.description ?? "Void"
    let scope: QuickLayoutFunctionIdentity.Scope = isScopedToType ? .type : .instance
    return QuickLayoutFunctionIdentity(scope: scope, name: name.text, parameters: parameters, returnType: returnType)
  }

  var defaultSuperCall: String {
    var parameterSyntax = ""
    for (index, parameter) in signature.parameterClause.parameters.enumerated() {
      if parameter.firstName.text == "_" {
        parameterSyntax += parameter.internalName.text
      } else {
        parameterSyntax += "\(parameter.firstName.text): \(parameter.internalName.text)"
      }
      if index != signature.parameterClause.parameters.count - 1 {
        parameterSyntax += ", "
      }
    }
    return "super.\(name)(\(parameterSyntax))"
  }
}

extension VariableDeclSyntax {
  var identity: QuickLayoutVariableIdentity {
    let isScopedToType = modifiers.contains {
      $0.name.text == "static" || $0.name.text == "class"
    }
    let returnType = returnTypeAnnotation?.type.description ?? "Void"
    let scope: QuickLayoutVariableIdentity.Scope = isScopedToType ? .type : .instance
    return QuickLayoutVariableIdentity(scope: scope, name: name?.text ?? "none", returnType: returnType)
  }

  var returnTypeAnnotation: TypeAnnotationSyntax? {
    bindings.first?.typeAnnotation
  }

  var name: TokenSyntax? {
    bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier
  }

  var modifierNames: [String] {
    attributes.compactMap {
      guard let attribute = $0.as(AttributeSyntax.self) else { return nil }
      guard let value = attribute.attributeName.as(IdentifierTypeSyntax.self) else { return nil }
      return value.name.text
    }
  }
}

extension FunctionParameterSyntax {
  var internalName: TokenSyntax {
    return secondName ?? firstName
  }

  var externalName: TokenSyntax {
    return firstName
  }
}

extension String {
  var trimmingWhitespaceAndNewlines: String {
    drop(while: { $0.isNewline || $0.isWhitespace })
      .reversed()
      .drop(while: { $0.isNewline || $0.isWhitespace })
      .reversed()
      .map { String($0) }
      .joined()
  }
}

func normalize(type: String) -> String {
  let characters = type.trimmingWhitespaceAndNewlines.map {
    String($0)
  }
  return characters.reduce(into: "") { aggregate, character in
    if character == "." || character == " " {
      aggregate = ""
    } else {
      aggregate.append(character)
    }
  }
}

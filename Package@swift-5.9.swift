// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import CompilerPluginSupport
import PackageDescription

#if os(iOS) || !os(macOS)
var QuickLayoutDependencies: [Target.Dependency] = [
  "QuickLayoutMacro",
  "QuickLayoutBridge",
]
#else
var QuickLayoutDependencies: [Target.Dependency] = [
  "QuickLayoutMacro",
]
#endif

var targets: [Target] = [
  .target(
    name: "QuickLayout",
    dependencies: QuickLayoutDependencies,
    path: "Sources/QuickLayout/QuickLayout",
    exclude: [
      "__showcase__/"
    ]
  ),
  .macro(
    name: "QuickLayoutMacro",
    dependencies: [
      .swiftSyntaxMacros,
      .swiftCompilerPlugin,
    ],
    path: "Sources/QuickLayout/QuickLayoutMacro"
  ),
  .target(
    name: "FastResultBuilder",
    path: "Sources/FastResultBuilder/FastResultBuilder",
    exclude: [
      "__tests__/"
    ]
  ),
  .testTarget(
    name: "QuickLayoutMacroTests",
    dependencies: [
      "QuickLayoutMacro",
      .swiftSyntaxMacrosTestSupport,
      .macroTesting,
    ],
    path: "Sources/QuickLayout/QuickLayoutMacroTests"
  ),
]

var products: [Product] = [
    .library(
      name: "QuickLayout",
      targets: ["QuickLayout"]
    ),
    .library(
      name: "FastResultBuilder",
      targets: ["FastResultBuilder"]
    ),
]

// iOS-only targets
#if os(iOS) || !os(macOS)
targets += [
  .target(
    name: "QuickLayoutCore",
    path: "Sources/QuickLayout/QuickLayoutCore"
  ),
  .target(
    name: "QuickLayoutBridge",
    dependencies: ["FastResultBuilder", "QuickLayoutCore"],
    path: "Sources/QuickLayout/QuickLayoutBridge",
    exclude: [
      "__server_snapshot_tests__",
      "__tests__",
    ]
  ),
]

products += [
    .library(
      name: "QuickLayoutCore",
      targets: ["QuickLayoutCore"]
    ),
    .library(
      name: "QuickLayoutBridge",
      targets: ["QuickLayoutBridge"]
    ),
]
#endif

let package = Package(
  name: "QuickLayout",
  platforms: [
    .iOS(.v15),
    .macOS(.v10_15),
  ],
  products: products,
  dependencies: [
    .package(url: "https://github.com/apple/swift-syntax.git", from: "602.0.0"),
    .package(url: "https://github.com/pointfreeco/swift-macro-testing.git", from: "0.6.4"),
  ],
  targets: targets
)

extension Target.Dependency {
  // swift-syntax
  static let swiftSyntax = Self.product(name: "SwiftSyntax", package: "swift-syntax")
  static let swiftSyntaxMacros = Self.product(name: "SwiftSyntaxMacros", package: "swift-syntax")
  static let swiftCompilerPlugin = Self.product(name: "SwiftCompilerPlugin", package: "swift-syntax")
  static let swiftSyntaxBuilder = Self.product(name: "SwiftSyntaxBuilder", package: "swift-syntax")
  static let swiftParserDiagnostics = Self.product(name: "SwiftParserDiagnostics", package: "swift-syntax")
  static let swiftSyntaxMacrosTestSupport = Self.product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
  // swift-macro-testing
  static let macroTesting = Self.product(name: "MacroTesting", package: "swift-macro-testing")
}

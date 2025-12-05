/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

/**
 @QuickLayout is the recommended way to use QuickLayout. Adding it to a view will require that
 you define a `body` var that returns the layout of your view. @QuickLayout views do not require
 manual addition or removal of views, this is handled automatically (the body implicitly defines the
 views that should be present on the view hierarchy). Layout and sizing are also handled automatically;
 the only requirement is a body definition.
*/
@attached(member, names: named(willMove(toWindow:)), named(layoutSubviews), named(sizeThatFits), named(quick_flexibility(for:)))
@attached(memberAttribute)
@attached(extension, conformances: HasBody)
public macro QuickLayout() = #externalMacro(module: "QuickLayoutMacro", type: "QuickLayout")

#if compiler(>=6)
/**
 This macro is an implementation detail of @QuickLayout. It is not intended to be used directly.
*/
@attached(body)
public macro _QuickLayoutInjection(_ value: String) = #externalMacro(module: "QuickLayoutMacro", type: "QuickLayoutInjection")
#endif

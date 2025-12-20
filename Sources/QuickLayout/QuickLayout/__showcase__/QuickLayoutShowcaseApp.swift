/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout
import SwiftUI

@main
struct QuickLayoutShowcaseApp: App {

  var body: some Scene {
    WindowGroup {
      // "No seriously, I need to debug my Declarative Layout view and i need an app that loads it!"
      //
      // Ok, ok, In that case use our ShowcaseViewRepresentable and pass to it your DeclarativeLayout View
      // and replace the ShowcaseApp() like this:
      //
      //  ShowcaseViewRepresentable(MyView.self)
      //
      ShowcaseApp()
    }
  }
}

struct ShowcaseApp: View {
  private let showcases = [
    SCSection(
      "Hello World",
      [
        HelloWorldView.self
      ]),
    SCSection(
      "State Management View",
      [
        StateManagementView.self
      ]),
    SCSection(
      "Animations",
      [
        UpdatingWithAnimationView.self
      ]),
    SCSection(
      "Alignment",
      [
        AlignmentGuidesView.self,
        CustomAlignmentView.self,
        EmojiAlignmentView.self,
        FirstLabelAlignmentView.self,
        FruitSelectorView.self,
      ]),
    SCSection(
      "Advance Sizing",
      [
        AdvanceSizingContainerView.self,
        AdvanceSizingView.self,
      ]),
    SCSection(
      "Lazy View",
      [
        LazyInstantiationView.self
      ]),
    SCSection(
      "Mobile Config Migration View",
      [
        MobileConfigMigrationView.self
      ]),
    SCSection(
      "Layout Containers",
      [
        GridLayoutExampleView.self
      ]),
  ]

  var body: some View {
    NavigationView {
      List {
        VStack(alignment: .leading, spacing: 10) {
          Text("QuickLayout Demo")
            .font(.largeTitle)
            .fontWeight(.bold)
          Text("Explore all major QuickLayout features in this interactive demo app or instantly preview your changes using Xcode Preview.")
            .font(.body)
        }
        .multilineTextAlignment(.leading)
        .listRowSeparator(.hidden)

        ForEach(showcases) { section in
          Section(section.title) {
            ForEach(section.showscases) { showcase in
              NavigationLink(destination: showcase.view()) {
                Text(showcase.label)
              }
              .listRowSeparator(.hidden)
            }
          }
        }
      }
      .listStyle(.plain)
    }
  }
}

private struct ShowcaseViewRepresentable: UIViewRepresentable {

  let view: UIView.Type

  init(_ viewType: UIView.Type) {
    self.view = viewType
  }

  func makeUIView(context: Context) -> some UIView {
    view.init() as UIView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
  }
}

private struct SCShowcase: Identifiable, Hashable {
  let id = UUID()

  let viewType: UIView.Type
  let label: String

  init(viewType: UIView.Type) {
    self.viewType = viewType
    self.label = String(describing: viewType).splittingCamelCase()
  }

  @MainActor
  func view() -> some View {
    ShowcaseViewRepresentable(viewType)
  }

  static func == (lhs: SCShowcase, rhs: SCShowcase) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

private extension String {
  func splittingCamelCase() -> String {
    let stripped = self.hasSuffix("View") ? String(self.dropLast(4)) : self

    // Split by uppercase letters
    let words = stripped.reduce("") { result, char in
      guard !result.isEmpty else { return String(char) }
      return char.isUppercase ? result + " " + String(char) : result + String(char)
    }

    // Filter out single capital letters (abbreviations)
    let filtered = words.split(separator: " ")
      .filter { $0.count > 1 || $0.first?.isUppercase == false }
      .joined(separator: " ")

    return String(filtered).trimmingCharacters(in: .whitespaces)
  }
}

private struct SCSection: Identifiable, Hashable {
  let id = UUID()
  let showscases: [SCShowcase]
  let title: String

  init(_ title: String, _ showcases: [UIView.Type]) {
    self.title = title
    self.showscases = showcases.map { SCShowcase(viewType: $0) }
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  ShowcaseApp()
}

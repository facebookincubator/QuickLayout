<img src='Sources/QuickLayout/docs/static/img/main-banner.png' />

QuickLayout is a declarative layout library for iOS, designed to work seamlessly with UIKit. It is lightning-fast, incredibly simple to use, and offers a powerful set of modern layout primitives.

QuickLayout's API will feel natural to many iOS engineers. With a small and well tested codebase, it is production ready and the recommended declarative layout solution for Instagram.

### Code Sample

```swift
import QuickLayout

@QuickLayout
class MyCellView: UIView {

  let titleLabel = UILabel()
  let subtitleLabel = UILabel()

  var body: Layout {
    HStack {
      VStack(alignment: .leading) {
        titleLabel
        Spacer(4)
        subtitleLabel
      }
      Spacer()
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
  }
}
```

Above is a fully functional view. Subviews are managed automatically, layout is performed at the correct time, and sizeThatFits returns an accurate value.

### Features

- ⭐️ **Lightning-Fast**: Custom layout engine for blazing fast performance—no Auto Layout or Flexbox overhead.
- 🧩 **Modern Layout Primitives**: Includes `HStack`, `VStack`, `ZStack`, `Grid`, and `Flow` as lightweight, pure Swift structs that don’t add extra views.
- 🚀 **Easy Integration**: Simple @QuickLayout macro for fast setup and automatic subview management.
- 🧵 **Thread-Safe**: [With some caveats](https://facebookincubator.github.io/QuickLayout/concepts/thread-safety/), our API can be used concurrently and off the main thread.

### Superior Performance over Auto Layout

QuickLayout achieves lightning-fast performance by using a custom-built layout engine that completely avoids Auto Layout and Flexbox, eliminating the overhead of constraint solving and the risk of constraint errors. Instead, QuickLayout provides a declarative API with lightweight layout primitives implemented as pure Swift structs that do not add extra views to the view hierarchy. This results in lower memory usage and faster layout calculations.

In benchmarks, QuickLayout is up to 3× faster and 4× more memory efficient than UIStackViews built with Auto Layout. By eliminating constraint solving and extra container views, QuickLayout delivers consistently high performance and a smaller memory footprint, making it ideal for demanding app surfaces.

For a comprehensive overview of all features, usage examples, and best practices, check out the [**QuickLayout Handbook**](https://facebookincubator.github.io/QuickLayout/).

## Quickstart

QuickLayout is a declarative layout library built to be used with regular UIViews. It can coexist with manual layout methods, allowing for gradual adoption.

### Stacks

At the heart of QuickLayout are Stacks:
- VStack layouts child elements vertically,
- HStack positions child elements horizontally.

For example, to make the following layout (image below), you can use VStack with leading alignment and spacing of four points:

<img width="150" src='Sources/QuickLayout/docs/static/img/quickstart/img1.png' />

```swift
let label1 = UILabel(text: "Kylee Lessie")
let label2 = UILabel(text: "Developer")

var body: Layout {
  VStack(alignment: .leading, spacing: 4) {
    label1
    label2
  }
}
```

You can nest Stacks as many times as you wish. For instance, you can add an icon to the left of two labels by using HStack:

<img width="150" src='Sources/QuickLayout/docs/static/img/quickstart/img2.png' />

```swift
let avatarView = UIImage(image: avatarIcon)
let label1 = UILabel(text: "Kylee Lessie")
let label2 = UILabel(text: "Developer")

var body: Layout {
  HStack(spacing: 8) {
    avatarView
    VStack(alignment: .leading, spacing: 4) {
      label1
      label2
    }
  }
}
```

### Alignment in Stacks

The alignment property in stacks does not position the stack within its parent; instead, it controls the alignment of the child elements inside the stack.

The alignment property of a VStack only applies to the horizontal alignment of the contained views. Similarly, the alignment property for an HStack only controls the vertical alignment.

<img width="800" src='Sources/QuickLayout/docs/static/img/quickstart/img3.png' />

### Flexible Spacer

A flexible Spacer is an adaptive element that expands as much as possible. For example, when placed within an HStack, a spacer expands horizontally as much as the stack allows, moving sibling views out of the way within the stack’s size limits.

<img width="400" src='Sources/QuickLayout/docs/static/img/quickstart/img4.png' />

```swift
var body: Layout {
  HStack {
    view1
    Spacer()
  }
}
```

<img width="400" src='Sources/QuickLayout/docs/static/img/quickstart/img5.png' />

```swift
var body: Layout {
  HStack {
    view1
    Spacer()
    view2
  }
}
```

<img width="400" src='Sources/QuickLayout/docs/static/img/quickstart/img6.png' />

```swift
var body: Layout {
  HStack {
    Spacer()
    view1
  }
}
```

### Fixed spacer and Spacing

<img width="400" src='Sources/QuickLayout/docs/static/img/quickstart/img7.png' />

A fixed space between views can be specified with a Spacer as in the snippet below:


```swift
var body: Layout {
  HStack {
    view1
    Spacer(8)
    view2
    Spacer(8)
    view3
  }
}
```
You can achieve the same fixed spacing between views using the Stack's spacing parameter:

```swift
var body: Layout {
  HStack(spacing: 8) {
    view1
    view2
    view3
  }
}
```

### Padding

A padding can be added to any view or layout element:

```swift
var body: Layout {
  HStack(spacing: 8) {
    view1
    view2
    view3
  }
  .padding(.horizontal, 16)
}
```

### Frame

The frame does not directly change the size of the target view, but it acts like a "picture frame" by suggesting the child its size and positioning it inside its bounds. For example, if the UIImageView in the following layout has an icon that is 10x10 points in size, the icon will be surrounded by 45 points of empty space on each side. However, if the icon has a size of 90x90 points, it will be surrounded only by 5 points of empty space on each side.

```swift
var body: Layout {
  imageView
    .frame(width: 100, height: 100)
}
```

To make UIImageView acquire the size of the frame, it needs to be wrapped into resizable modifier:

```swift
var body: Layout {
  imageView
    .resizable()
    .frame(width: 100, height: 100)
}
```

## Learn More
For full documentation, visit the [**QuickLayout Handbook**](https://facebookincubator.github.io/QuickLayout/).

## Installation
Use Swift Package Manager. Link and import QuickLayout target.

## Credits

- [Constantine Fry](https://github.com/constantine-fry) — Concept, architecture, layout and API design
- [Jordan Smith](https://github.com/jordansmithnz) — @QuickLayout macro and API design, body API and automatic subview management
- [Fabio Milano](https://github.com/fabiomassimo) — Demo showcase, BUCK support
- [Jordan Smith](https://github.com/jordansmithnz) & [Fabio Milano](https://github.com/fabiomassimo) — Instagram adoption
- [Andrey Mishanin](https://github.com/Andrey-Mishanin) & [Constantine Fry](https://github.com/constantine-fry) — Stack Layout
- [Constantine Fry](https://github.com/constantine-fry) & [Saadh Zahid](https://github.com/saadhzahid) — Flow and Grid Layout
- [Jordan Smith](https://github.com/jordansmithnz) — Custom alignment and alignment guides
- [Thong Nguyen](https://github.com/tumtumtum) — Fast Result Builder

## Special Thanks

To **Scott James Remnant** of [netsplit.com](https://netsplit.com/swiftui/) and **Javier** of [SwiftUI Labs](https://swiftui-lab.com/) for their research and articles on SwiftUI.

To **Chris Eidhof**, **Daniel Eggert**, and **Florian Kugler** of [objc.io](https://www.objc.io) for their continued work on exploring SwiftUI layout.

To **Luc Dion** for his work on [LayoutFrameworkBenchmark](https://github.com/layoutBox/LayoutFrameworkBenchmark).

To the early adopters - **Sash Zats**, **Cory Wilhite**, **Chaoshuai Lyu**, **Steven Liu**, **Erik Kunz**, **Min Kim**, and many others - for their feedback and early adoption efforts.

## License
QuickLayout is MIT-licensed, as found in the LICENSE file.

## Legal

Copyright © Meta Platforms, Inc &#x2022; <a href="https://opensource.fb.com/legal/terms">Terms of Use</a> &#x2022; <a href="https://opensource.fb.com/legal/privacy">Privacy Policy</a>

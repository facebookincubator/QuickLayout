/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// Disabled during swift-format 6.3 rollout, feel free to remove:
// swift-format-ignore-file: OrderedImports

import XCTest

@testable import QuickLayoutCore

@MainActor
class UIKitStandardLibrarySizingBehaviourTests: XCTestCase {

  /// UIButton behaves as a fixed size view, but returns partial flexibility.
  private func runTestForButton(_ view: UIButton, name: String) {

    let expectedSize = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))

    let sizeFor0x0 = view.quick_layoutThatFits(.zero).size
    let sizeFor1x1 = view.quick_layoutThatFits(CGSize(width: 1, height: 1)).size
    let sizeFor20x10 = view.quick_layoutThatFits(CGSize(width: 20, height: 10)).size
    let sizeFor320x480 = view.quick_layoutThatFits(CGSize(width: 320, height: 480)).size
    let sizeForCGFloatMax = view.quick_layoutThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size

    XCTAssertEqual(sizeFor0x0, expectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor1x1, expectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor20x10, expectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor320x480, expectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeForCGFloatMax, expectedSize, "Size doesn't match for \(name)")

    let flexibilityX = view.quick_flexibility(for: .horizontal)
    let flexibilityY = view.quick_flexibility(for: .vertical)
    XCTAssertEqual(Flexibility.partial, flexibilityX, "Flexibility doesn't match for \(name)")
    XCTAssertEqual(Flexibility.partial, flexibilityY, "Flexibility doesn't match for \(name)")
  }

  private func runTestForLabel(_ view: UILabel, name: String) {
    view.numberOfLines = 1

    let expectedSize = view.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))

    var sizeFor0x0 = view.quick_layoutThatFits(.zero).size
    var sizeFor1x1 = view.quick_layoutThatFits(CGSize(width: 1, height: 1)).size
    var sizeFor20x10 = view.quick_layoutThatFits(CGSize(width: 20, height: 10)).size
    var sizeFor320x480 = view.quick_layoutThatFits(CGSize(width: 320, height: 480)).size
    var sizeForCGFloatMax = view.quick_layoutThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size

    XCTAssertEqual(sizeFor0x0, CGSize.zero, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor1x1, CGSize.zero, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor20x10, CGSize(width: 20, height: 10), "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor320x480, expectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeForCGFloatMax, expectedSize, "Size doesn't match for \(name)")

    var flexibilityX = view.quick_flexibility(for: .horizontal)
    var flexibilityY = view.quick_flexibility(for: .vertical)
    XCTAssertEqual(Flexibility.partial, flexibilityX, "Flexibility doesn't match for \(name)")
    XCTAssertEqual(Flexibility.partial, flexibilityY, "Flexibility doesn't match for \(name)")

    view.numberOfLines = 0

    sizeFor0x0 = view.quick_layoutThatFits(.zero).size
    sizeFor1x1 = view.quick_layoutThatFits(CGSize(width: 1, height: 1)).size
    sizeFor20x10 = view.quick_layoutThatFits(CGSize(width: 20, height: 1000)).size
    sizeFor320x480 = view.quick_layoutThatFits(CGSize(width: 320, height: 480)).size
    sizeForCGFloatMax = view.quick_layoutThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size

    XCTAssertEqual(sizeFor0x0, CGSize.zero, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor1x1, CGSize.zero, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor20x10, view.sizeThatFits(CGSize(width: 20, height: 1000)), "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor320x480, expectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeForCGFloatMax, expectedSize, "Size doesn't match for \(name)")

    flexibilityX = view.quick_flexibility(for: .horizontal)
    flexibilityY = view.quick_flexibility(for: .vertical)
    XCTAssertEqual(Flexibility.partial, flexibilityX, "Flexibility doesn't match for \(name)")
    XCTAssertEqual(Flexibility.partial, flexibilityY, "Flexibility doesn't match for \(name)")
  }

  private func runTestForFullyFlexibleView(_ view: UIView, name: String, flexibility: Flexibility = .fullyFlexible) {
    let sizeFor0x0 = view.quick_layoutThatFits(.zero).size
    let sizeFor1x1 = view.quick_layoutThatFits(CGSize(width: 1, height: 1)).size
    let sizeFor320x480 = view.quick_layoutThatFits(CGSize(width: 320, height: 480)).size
    let sizeForCGFloatMax = view.quick_layoutThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size

    XCTAssertEqual(sizeFor0x0, CGSize.zero, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor1x1, CGSize(width: 1, height: 1), "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor320x480, CGSize(width: 320, height: 480), "Size doesn't match for \(name)")
    XCTAssertEqual(sizeForCGFloatMax, CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), "Size doesn't match for \(name)")

    let flexibilityX = view.quick_flexibility(for: .horizontal)
    let flexibilityY = view.quick_flexibility(for: .vertical)
    XCTAssertEqual(flexibility, flexibilityX, "Flexibility doesn't match for \(name)")
    XCTAssertEqual(flexibility, flexibilityY, "Flexibility doesn't match for \(name)")
  }

  private func runTestForFixedSizeViews(_ view: UIView, exectedSize: CGSize, name: String) {
    let sizeFor0x0 = view.quick_layoutThatFits(.zero).size
    let sizeFor1x1 = view.quick_layoutThatFits(CGSize(width: 1, height: 1)).size
    let sizeFor320x480 = view.quick_layoutThatFits(CGSize(width: 320, height: 480)).size
    let sizeForCGFloatMax = view.quick_layoutThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size

    XCTAssertEqual(sizeFor0x0, exectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor1x1, exectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor320x480, exectedSize, "Size doesn't match for \(name)")
    XCTAssertEqual(sizeForCGFloatMax, exectedSize, "Size doesn't match for \(name)")

    let flexibilityX = view.quick_flexibility(for: .horizontal)
    let flexibilityY = view.quick_flexibility(for: .vertical)
    XCTAssertEqual(Flexibility.fixedSize, flexibilityX, "Flexibility doesn't match for \(name)")
    XCTAssertEqual(Flexibility.fixedSize, flexibilityY, "Flexibility doesn't match for \(name)")
  }

  private func runTestForHorizontallyExpandableView(_ view: UIView, height: CGFloat, name: String) {
    let sizeFor0x0 = view.quick_layoutThatFits(.zero).size
    let sizeFor1x1 = view.quick_layoutThatFits(CGSize(width: 1, height: 1)).size
    let sizeFor320x480 = view.quick_layoutThatFits(CGSize(width: 320, height: 480)).size
    let sizeForCGFloatMax = view.quick_layoutThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).size

    XCTAssertEqual(sizeFor0x0, CGSize(width: 0, height: height), "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor1x1, CGSize(width: 1, height: height), "Size doesn't match for \(name)")
    XCTAssertEqual(sizeFor320x480, CGSize(width: 320, height: height), "Size doesn't match for \(name)")
    XCTAssertEqual(sizeForCGFloatMax, CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), "Size doesn't match for \(name)")

    let flexibilityX = view.quick_flexibility(for: .horizontal)
    let flexibilityY = view.quick_flexibility(for: .vertical)
    XCTAssertEqual(Flexibility.fullyFlexible, flexibilityX, "Flexibility doesn't match for \(name)")
    XCTAssertEqual(Flexibility.fixedSize, flexibilityY, "Flexibility doesn't match for \(name)")
  }

  func testForFullyFlexibleViews() {
    let layout = UICollectionViewLayout()
    runTestForFullyFlexibleView(UIView(), name: "UIView")
    runTestForFullyFlexibleView(UIScrollView(), name: "UIScrollView")
    runTestForFullyFlexibleView(UICollectionView(frame: .zero, collectionViewLayout: layout), name: "UICollectionView")
    runTestForFullyFlexibleView(UITableView(), name: "UITableView")
    runTestForFullyFlexibleView(UITextView(), name: "UITextView")
  }

  func testForFixedSizeViews() {
    if let image = UIImage(systemName: "paperplane.fill") {
      runTestForFixedSizeViews(UIImageView(image: image), exectedSize: image.size, name: "UIImageView")
    } else {
      XCTFail("Could not find image with name 'paperplane.fill'")
    }

    let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
    if let image = UIImage(systemName: "doc.circle.fill", withConfiguration: largeConfig) {
      runTestForFixedSizeViews(UIImageView(image: image), exectedSize: image.size, name: "UIImageView")
    } else {
      XCTFail("Could not find image with name 'doc.circle.fill'")
    }
    runTestForFixedSizeViews(UISwitch(), exectedSize: UISwitch().sizeThatFits(CGSize(width: 100, height: 100)), name: "UISwitch")
    runTestForFixedSizeViews(UIStepper(), exectedSize: UIStepper().sizeThatFits(CGSize(width: 100, height: 100)), name: "UIStepper")
    runTestForFixedSizeViews(UIPageControl(), exectedSize: UIPageControl().sizeThatFits(CGSize(width: 100, height: 100)), name: "UIPageControl")
    runTestForFixedSizeViews(UIActivityIndicatorView(), exectedSize: UIActivityIndicatorView().sizeThatFits(CGSize(width: 100, height: 100)), name: "UIActivityIndicatorView")
  }

  func testForHorizontallyExpandableViews() {
    let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    runTestForHorizontallyExpandableView(UISlider(), height: UISlider().sizeThatFits(maxSize).height, name: "UISlider")
    runTestForHorizontallyExpandableView(UITextField(), height: UITextField().sizeThatFits(maxSize).height, name: "UITextField")
    runTestForHorizontallyExpandableView(UISearchBar(), height: UISearchBar().sizeThatFits(maxSize).height, name: "UISearchBar")
    runTestForHorizontallyExpandableView(UIProgressView(), height: UIProgressView().sizeThatFits(maxSize).height, name: "UIProgressView")
    runTestForHorizontallyExpandableView(UISearchTextField(), height: UISearchTextField().sizeThatFits(maxSize).height, name: "UISearchTextField")
  }

  func testLabel() {
    let label1 = UILabel()
    label1.text = "Hello World"
    runTestForLabel(label1, name: "UILabel")

    let label2 = CustomLabel()
    label2.text = "Hello World"
    runTestForLabel(label2, name: "Custom Label")

    let label3 = CustomLabelWithOverrides()
    label3.text = "Hello World"
    runTestForLabel(label3, name: "Custom Label")
    XCTAssertEqual(8, label3.sizeThatFitsCallCounter, "sizeThatFitsCallCounter doesn't match for \(name)")
  }

  func testButton() {
    let button1 = UIButton()
    button1.setTitle("Hello World", for: .normal)
    runTestForButton(button1, name: "UIButton")

    let button2 = CustomButton()
    button2.setTitle("Hello World", for: .normal)
    runTestForButton(button2, name: "Custom Button")

    let button3 = CustomButtonWithOverrides()
    button3.setTitle("Hello World", for: .normal)
    XCTAssertEqual(0, button3.sizeThatFitsCallCounter, "CustomButtonWithOverrides sizeThatFitsCallCounter doesn't match")
    runTestForButton(button3, name: "Custom Button")
    XCTAssertEqual(6, button3.sizeThatFitsCallCounter, "CustomButtonWithOverrides sizeThatFitsCallCounter doesn't match")
  }

  func testForCustomViewsWithoutSizeThatFits() {
    let layout = UICollectionViewLayout()

    runTestForFullyFlexibleView(CustomView(), name: "CustomView")
    runTestForFullyFlexibleView(CustomScrollView(), name: "CustomScrollView")
    runTestForFullyFlexibleView(CustomTableView(), name: "CustomTableView")
    runTestForFullyFlexibleView(CustomCollectionView(frame: .zero, collectionViewLayout: layout), name: "CustomCollectionView")
    runTestForFullyFlexibleView(CustomTextView(), name: "CustomTextView")

    let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
    if let image = UIImage(systemName: "doc.circle.fill", withConfiguration: largeConfig) {
      runTestForFixedSizeViews(CustomImageView(image: image), exectedSize: image.size, name: "UIImageView")
    } else {
      XCTFail("Could not find image with name 'doc.circle.fill'")
    }

    let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude)
    runTestForHorizontallyExpandableView(CustomTextField(), height: CustomTextField().sizeThatFits(maxSize).height, name: "CustomTextField")
    runTestForHorizontallyExpandableView(CustomSearchBar(), height: CustomSearchBar().sizeThatFits(maxSize).height, name: "CustomSearchBar")
    runTestForHorizontallyExpandableView(CustomSlider(), height: CustomSlider().sizeThatFits(maxSize).height, name: "CustomSlider")
    runTestForHorizontallyExpandableView(CustomProgressView(), height: CustomProgressView().sizeThatFits(maxSize).height, name: "CustomProgressView")

    runTestForFixedSizeViews(CustomSwitch(), exectedSize: CustomSwitch().sizeThatFits(CGSize(width: 100, height: 100)), name: "CustomSwitch")
    runTestForFixedSizeViews(CustomStepper(), exectedSize: CustomStepper().sizeThatFits(CGSize(width: 100, height: 100)), name: "CustomStepper")
    runTestForFixedSizeViews(CustomPageControl(), exectedSize: CustomPageControl().sizeThatFits(CGSize(width: 100, height: 100)), name: "CustomPageControl")
    runTestForFixedSizeViews(CustomActivityIndicatorView(), exectedSize: CustomActivityIndicatorView().sizeThatFits(CGSize(width: 100, height: 100)), name: "CustomActivityIndicatorView")
  }

  func testCustomFullyFlexblyViewsWithMethodOverrides() {
    let layout = UICollectionViewLayout()
    let view = CustomViewWithOverrides()
    let scrollView = CustomScrollViewWithOverrides()
    let tableView = CustomTableViewWithOverrides()
    let collectionView = CustomCollectionViewWithOverrides(frame: .zero, collectionViewLayout: layout)
    let textView = CustomTextViewWithOverrides()

    let viewCounter = view.sizeThatFitsCallCounter
    let scrollViewCounter = scrollView.sizeThatFitsCallCounter
    let tableViewCounter = tableView.sizeThatFitsCallCounter
    let collectionViewCounter = collectionView.sizeThatFitsCallCounter
    let textViewCounter = textView.sizeThatFitsCallCounter

    _ = view.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = scrollView.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = tableView.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = collectionView.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = textView.quick_layoutThatFits(CGSize(width: 10, height: 10))

    XCTAssertEqual(viewCounter + 1, view.sizeThatFitsCallCounter)
    XCTAssertEqual(scrollViewCounter + 1, scrollView.sizeThatFitsCallCounter)
    XCTAssertEqual(tableViewCounter + 1, tableView.sizeThatFitsCallCounter)
    XCTAssertEqual(collectionViewCounter + 1, collectionView.sizeThatFitsCallCounter)
    XCTAssertEqual(textViewCounter + 1, textView.sizeThatFitsCallCounter)

    XCTAssertEqual(Flexibility.partial, view.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.partial, view.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, scrollView.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fullyFlexible, scrollView.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, tableView.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fullyFlexible, tableView.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, collectionView.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fullyFlexible, collectionView.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, textView.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fullyFlexible, textView.quick_flexibility(for: .vertical))
  }

  func testCustomFixedViewsWithMethodOverrides() {
    let activityView = CustomActivityIndicatorWithOverrides()
    let stepper = CustomStepperWithOverrides()
    let switchView = CustomSwitchWithOverrides()
    let pageControl = CustomPageControlWithOverrides()

    let activityViewCounter = activityView.sizeThatFitsCallCounter
    let stepperCounter = stepper.sizeThatFitsCallCounter
    let switchViewCounter = switchView.sizeThatFitsCallCounter
    let pageControlCounter = pageControl.sizeThatFitsCallCounter

    _ = activityView.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = stepper.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = switchView.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = pageControl.quick_layoutThatFits(CGSize(width: 10, height: 10))

    XCTAssertEqual(activityViewCounter + 1, activityView.sizeThatFitsCallCounter)
    XCTAssertEqual(stepperCounter + 1, stepper.sizeThatFitsCallCounter)
    XCTAssertEqual(switchViewCounter + 1, switchView.sizeThatFitsCallCounter)
    XCTAssertEqual(pageControlCounter + 1, pageControl.sizeThatFitsCallCounter)

    XCTAssertEqual(Flexibility.fixedSize, activityView.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, activityView.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fixedSize, stepper.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, stepper.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fixedSize, switchView.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, switchView.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fixedSize, pageControl.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, pageControl.quick_flexibility(for: .vertical))
  }

  func testCustomHorizontallyExpandebleViewsWithOverrides() {
    let searchBar = CustomSearchBarWithOverrides()
    let searchTextField = CustomSearchTextFieldWithOverrides()
    let slider = CustomSliderWithOverrides()
    let progressView = CustomProgressViewWithOverrides()
    let textField = CustomTextFieldWithOverrides()

    let searchBarCounter = searchBar.sizeThatFitsCallCounter
    let searchTextFieldCounter = searchTextField.sizeThatFitsCallCounter
    let sliderCounter = slider.sizeThatFitsCallCounter
    let progressViewCounter = progressView.sizeThatFitsCallCounter
    let textFieldCounter = textField.sizeThatFitsCallCounter

    _ = searchBar.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = searchTextField.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = slider.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = progressView.quick_layoutThatFits(CGSize(width: 10, height: 10))
    _ = textField.quick_layoutThatFits(CGSize(width: 10, height: 10))

    XCTAssertEqual(searchBarCounter + 1, searchBar.sizeThatFitsCallCounter)
    XCTAssertEqual(searchTextFieldCounter + 1, searchTextField.sizeThatFitsCallCounter)
    XCTAssertEqual(sliderCounter + 1, slider.sizeThatFitsCallCounter)
    XCTAssertEqual(progressViewCounter + 1, progressView.sizeThatFitsCallCounter)
    XCTAssertEqual(textFieldCounter + 1, textField.sizeThatFitsCallCounter)

    XCTAssertEqual(Flexibility.fullyFlexible, searchBar.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, searchBar.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, searchTextField.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, searchTextField.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, slider.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, slider.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, progressView.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, progressView.quick_flexibility(for: .vertical))
    XCTAssertEqual(Flexibility.fullyFlexible, textField.quick_flexibility(for: .horizontal))
    XCTAssertEqual(Flexibility.fixedSize, textField.quick_flexibility(for: .vertical))
  }
}

/// Testing custom views, that don't have a sizeThatFits overrides.
private class CustomLabel: UILabel {}
private class CustomButton: UIButton {}
private class CustomView: UIView {}
private class CustomScrollView: UIScrollView {}
private class CustomCollectionView: UICollectionView {}
private class CustomTableView: UITableView {}
private class CustomTextView: UITextView {}
private class CustomTextField: UITextField {}
private class CustomSearchBar: UISearchBar {}
private class CustomSlider: UISlider {}
private class CustomProgressView: UIProgressView {}
private class CustomSearchTextField: UISearchTextField {}
private class CustomImageView: UIImageView {}
private class CustomSwitch: UISwitch {}
private class CustomStepper: UIStepper {}
private class CustomPageControl: UIPageControl {}
private class CustomActivityIndicatorView: UIActivityIndicatorView {}

private class CustomLabelWithOverrides: UILabel {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomButtonWithOverrides: UIButton {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomViewWithOverrides: UIView {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomScrollViewWithOverrides: UIScrollView {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomTableViewWithOverrides: UITableView {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomTextViewWithOverrides: UITextView {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomCollectionViewWithOverrides: UICollectionView {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomStepperWithOverrides: UIStepper {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomSwitchWithOverrides: UISwitch {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomPageControlWithOverrides: UIPageControl {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomActivityIndicatorWithOverrides: UIActivityIndicatorView {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomTextFieldWithOverrides: UITextField {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomSearchBarWithOverrides: UISearchBar {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomSliderWithOverrides: UISlider {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomProgressViewWithOverrides: UIProgressView {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

private class CustomSearchTextFieldWithOverrides: UISearchTextField {
  var sizeThatFitsCallCounter = 0

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    sizeThatFitsCallCounter += 1
    return super.sizeThatFits(size)
  }
}

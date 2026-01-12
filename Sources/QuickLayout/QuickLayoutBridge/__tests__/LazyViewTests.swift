/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayoutBridge
import QuickLayoutCore
import XCTest

@MainActor
final class LazyViewTests: XCTestCase {

  // MARK: - Basic Lazy Loading Tests

  func testLazyViewIsNotLoadedInitially() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      return UIView()
    }

    XCTAssertFalse(lazyView.isLoaded)
    XCTAssertNil(lazyView.ifLoaded)
    XCTAssertEqual(initializerCallCount, 0)
  }

  func testLazyViewLoadsOnAccess() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      return UIView()
    }

    let view = lazyView.loadIfNeeded()

    XCTAssertTrue(lazyView.isLoaded)
    XCTAssertNotNil(lazyView.ifLoaded)
    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(view === lazyView.ifLoaded)
  }

  func testLazyViewOnlyInitializesOnce() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      return UIView()
    }

    let view1 = lazyView.loadIfNeeded()
    let view2 = lazyView.loadIfNeeded()
    let view3 = lazyView.loadIfNeeded()

    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(view1 === view2)
    XCTAssertTrue(view2 === view3)
  }

  func testIfLoadedReturnsNilWhenNotLoaded() {
    let lazyView = LazyView { UIView() }

    XCTAssertNil(lazyView.ifLoaded)
  }

  func testIfLoadedReturnsViewWhenLoaded() {
    let lazyView = LazyView { UIView() }
    let loadedView = lazyView.loadIfNeeded()

    XCTAssertTrue(lazyView.ifLoaded === loadedView)
  }

  // MARK: - Element Conformance Tests

  func testLazyViewConformsToElement() {
    let lazyView = LazyView { UIView() }

    // LazyView<UIView> should conform to Element
    let element: any Element = lazyView
    XCTAssertNotNil(element)
  }

  func testQuickLayoutThatFitsLoadsView() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      let view = UIView()
      return view
    }

    XCTAssertEqual(initializerCallCount, 0)

    _ = lazyView.quick_layoutThatFits(CGSize(width: 100, height: 100))

    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(lazyView.isLoaded)
  }

  func testQuickFlexibilityLoadsView() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      return UIView()
    }

    XCTAssertEqual(initializerCallCount, 0)

    _ = lazyView.quick_flexibility(for: .horizontal)

    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(lazyView.isLoaded)
  }

  func testQuickLayoutPriorityLoadsView() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      return UIView()
    }

    XCTAssertEqual(initializerCallCount, 0)

    _ = lazyView.quick_layoutPriority()

    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(lazyView.isLoaded)
  }

  func testQuickExtractViewsLoadsView() {
    var initializerCallCount = 0
    let expectedView = UIView()
    let lazyView = LazyView {
      initializerCallCount += 1
      return expectedView
    }

    XCTAssertEqual(initializerCallCount, 0)

    var views: [UIView] = []
    lazyView.quick_extractViewsIntoArray(&views)

    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(lazyView.isLoaded)
    XCTAssertEqual(views.count, 1)
    XCTAssertTrue(views[0] === expectedView)
  }

  // MARK: - LeafElement Conformance Tests

  func testLazyViewConformsToLeafElement() {
    let lazyView = LazyView { UIView() }

    // LazyView<UIView> should conform to LeafElement since UIView conforms to LeafElement
    let leafElement: any LeafElement = lazyView
    XCTAssertNotNil(leafElement)
  }

  func testBackingViewLoadsView() {
    var initializerCallCount = 0
    let expectedView = UIView()
    let lazyView = LazyView {
      initializerCallCount += 1
      return expectedView
    }

    XCTAssertEqual(initializerCallCount, 0)

    let backingView = lazyView.backingView()

    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(lazyView.isLoaded)
    XCTAssertTrue(backingView === expectedView)
  }

  func testBackingViewReturnsCorrectView() {
    let expectedView = UIView()
    let lazyView = LazyView { expectedView }

    XCTAssertTrue(lazyView.backingView() === expectedView)
  }

  // MARK: - Resizable Modifier Tests (via LeafElement)

  func testLazyViewSupportsResizableModifier() {
    let lazyView = LazyView { UIView() }

    // Since LazyView conforms to LeafElement, it should support resizable()
    let resizableElement = lazyView.resizable()

    XCTAssertNotNil(resizableElement)
  }

  func testLazyViewResizableWithAxis() {
    let lazyView = LazyView { UIView() }

    let horizontalResizable = lazyView.resizable(axis: .horizontal)
    let verticalResizable = lazyView.resizable(axis: .vertical)
    let bothAxesResizable = lazyView.resizable(axis: [.horizontal, .vertical])

    XCTAssertNotNil(horizontalResizable)
    XCTAssertNotNil(verticalResizable)
    XCTAssertNotNil(bothAxesResizable)
  }

  // MARK: - Layout Integration Tests

  func testLazyViewInHStack() {
    let view1 = UIView()
    let lazyView = LazyView { UIView() }

    let layout = HStack {
      view1
      lazyView
    }

    // LazyView should not be loaded until layout is computed
    XCTAssertFalse(lazyView.isLoaded)

    // Computing layout should load the lazy view
    _ = layout.sizeThatFits(CGSize(width: 200, height: 100))

    XCTAssertTrue(lazyView.isLoaded)
  }

  func testLazyViewInVStack() {
    let view1 = UIView()
    let lazyView = LazyView { UIView() }

    let layout = VStack {
      view1
      lazyView
    }

    XCTAssertFalse(lazyView.isLoaded)

    _ = layout.sizeThatFits(CGSize(width: 100, height: 200))

    XCTAssertTrue(lazyView.isLoaded)
  }

  func testLazyViewWithFrameModifier() {
    let lazyView = LazyView { UIView() }

    let layout = HStack {
      lazyView
        .resizable()
        .frame(width: 50, height: 50)
    }

    XCTAssertFalse(lazyView.isLoaded)

    let size = layout.sizeThatFits(CGSize(width: 200, height: 200))

    XCTAssertTrue(lazyView.isLoaded)
    XCTAssertEqual(size.width, 50)
    XCTAssertEqual(size.height, 50)
  }

  func testConditionalLazyViewDoesNotLoadWhenExcluded() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      return UIView()
    }

    let showView = false

    let layout = HStack {
      if showView {
        lazyView
      }
    }

    _ = layout.sizeThatFits(CGSize(width: 200, height: 100))

    // LazyView should NOT be loaded since condition is false
    XCTAssertEqual(initializerCallCount, 0)
    XCTAssertFalse(lazyView.isLoaded)
  }

  func testConditionalLazyViewLoadsWhenIncluded() {
    var initializerCallCount = 0
    let lazyView = LazyView {
      initializerCallCount += 1
      return UIView()
    }

    let showView = true

    let layout = HStack {
      if showView {
        lazyView
      }
    }

    _ = layout.sizeThatFits(CGSize(width: 200, height: 100))

    // LazyView should be loaded since condition is true
    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertTrue(lazyView.isLoaded)
  }

  // MARK: - View Extraction Tests

  func testLazyViewExtraction() {
    let expectedView = UIView()
    let lazyView = LazyView { expectedView }

    let layout = HStack {
      lazyView
    }

    let views = layout.views()

    XCTAssertEqual(views.count, 1)
    XCTAssertTrue(views[0] === expectedView)
  }

  func testLazyViewExtractionWithMultipleViews() {
    let view1 = UIView()
    let view2 = UIView()
    let lazyView1 = LazyView { view1 }
    let lazyView2 = LazyView { view2 }

    let layout = HStack {
      lazyView1
      lazyView2
    }

    let views = layout.views()

    XCTAssertEqual(views.count, 2)
    XCTAssertTrue(views[0] === view1)
    XCTAssertTrue(views[1] === view2)
  }

  func testLazyViewExtractionWithNestedStacks() {
    let view1 = UIView()
    let view2 = UIView()
    let view3 = UIView()
    let lazyView1 = LazyView { view1 }
    let lazyView2 = LazyView { view2 }
    let lazyView3 = LazyView { view3 }

    let layout = HStack {
      lazyView1
      VStack {
        lazyView2
        lazyView3
      }
    }

    let views = layout.views()

    XCTAssertEqual(views.count, 3)
    XCTAssertTrue(views[0] === view1)
    XCTAssertTrue(views[1] === view2)
    XCTAssertTrue(views[2] === view3)
  }

  // MARK: - UIButton Tests (Common Use Case)

  func testLazyViewWithUIButton() {
    var initializerCallCount = 0
    let lazyButton = LazyView {
      initializerCallCount += 1
      let button = UIButton(type: .system)
      button.setTitle("Test", for: .normal)
      return button
    }

    XCTAssertFalse(lazyButton.isLoaded)
    XCTAssertEqual(initializerCallCount, 0)

    let button = lazyButton.loadIfNeeded()

    XCTAssertTrue(lazyButton.isLoaded)
    XCTAssertEqual(initializerCallCount, 1)
    XCTAssertEqual(button.title(for: .normal), "Test")
  }

  func testLazyButtonResizable() {
    let lazyButton = LazyView {
      UIButton(type: .system)
    }

    // UIButton is a UIView, so LazyView<UIButton> should conform to LeafElement
    let resizableElement = lazyButton.resizable()

    XCTAssertNotNil(resizableElement)
  }

  // MARK: - UILabel Tests

  func testLazyViewWithUILabel() {
    let lazyLabel = LazyView {
      let label = UILabel()
      label.text = "Hello"
      return label
    }

    XCTAssertFalse(lazyLabel.isLoaded)

    let label = lazyLabel.loadIfNeeded()

    XCTAssertTrue(lazyLabel.isLoaded)
    XCTAssertEqual(label.text, "Hello")
  }

  // MARK: - Expand Modifier Tests (via LeafElement)

  func testLazyViewSupportsExpandModifier() {
    let lazyView = LazyView { UIView() }

    // Since LazyView conforms to LeafElement, it should support expand()
    let expandedElement = lazyView.expand(by: CGSize(width: 10, height: 10))

    XCTAssertNotNil(expandedElement)
  }
}

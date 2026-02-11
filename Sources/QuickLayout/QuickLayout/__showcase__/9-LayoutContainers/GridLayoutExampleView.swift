/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import QuickLayout

/// Interactive Grid Layout Example
/// **Key concepts**:
///     - Grid and GridRow layouts
///     - Dynamic spacing controls with sliders
///     - Font size scaling with real-time updates
///     - Real-time layout updates
///     - Interactive UI elements
@QuickLayout
final class GridLayoutExampleView: UIView {

  private var horizontalSpacing: CGFloat = 8
  private var verticalSpacing: CGFloat = 8
  private var fontScale: CGFloat = 1.0

  private lazy var slider1: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 0
    slider.maximumValue = 40
    slider.value = Float(horizontalSpacing)
    slider.isContinuous = true
    slider.minimumTrackTintColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
    slider.maximumTrackTintColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    slider.thumbTintColor = UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
    slider.addTarget(self, action: #selector(horizontalSliderChanged), for: .valueChanged)
    return slider
  }()

  private lazy var slider2: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 0
    slider.maximumValue = 40
    slider.value = Float(verticalSpacing)
    slider.isContinuous = true
    slider.minimumTrackTintColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
    slider.maximumTrackTintColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    slider.thumbTintColor = UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
    slider.addTarget(self, action: #selector(verticalSliderChanged), for: .valueChanged)
    return slider
  }()

  private lazy var fontSizeSlider: UISlider = {
    let slider = UISlider()
    slider.minimumValue = 0.5
    slider.maximumValue = 2.0
    slider.value = Float(fontScale)
    slider.isContinuous = true
    slider.minimumTrackTintColor = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
    slider.maximumTrackTintColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    slider.thumbTintColor = UIColor(red: 0.1, green: 0.4, blue: 0.8, alpha: 1.0)
    slider.addTarget(self, action: #selector(fontSizeSliderChanged), for: .valueChanged)
    return slider
  }()

  // Header labels
  private let item: UILabel = {
    let label = UILabel()
    label.text = "Item"
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let itemDescription: UILabel = {
    let label = UILabel()
    label.text = "Description"
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let quantity: UILabel = {
    let label = UILabel()
    label.text = "Quantity"
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let price: UILabel = {
    let label = UILabel()
    label.text = "Price"
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  // Data rows
  private let orange: UILabel = {
    let label = UILabel()
    label.text = "🍊 Orange"
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let orangeDescription: UILabel = {
    let label = UILabel()
    label.text = "Sweet and tangy orange"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let orangeQuantity: UILabel = {
    let label = UILabel()
    label.text = "Qty: 4"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let orangePrice: UILabel = {
    let label = UILabel()
    label.text = "£1.30"
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let apple: UILabel = {
    let label = UILabel()
    label.text = "🍎 Apple"
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let appleDescription: UILabel = {
    let label = UILabel()
    label.text = "Juicy green apple"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let appleQuantity: UILabel = {
    let label = UILabel()
    label.text = "Qty: 4"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let applePrice: UILabel = {
    let label = UILabel()
    label.text = "£2.05"
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let banana: UILabel = {
    let label = UILabel()
    label.text = "🍌 Banana"
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let bananaDescription: UILabel = {
    let label = UILabel()
    label.text = "Fresh yellow bananas"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let bananaQuantity: UILabel = {
    let label = UILabel()
    label.text = "Qty: 4"
    label.font = .systemFont(ofSize: 15)
    label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let bananaPrice: UILabel = {
    let label = UILabel()
    label.text = "£1.50"
    label.font = .systemFont(ofSize: 16, weight: .semibold)
    label.textColor = UIColor(red: 0.2, green: 0.6, blue: 0.2, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private let totalPrice: UILabel = {
    let label = UILabel()
    label.text = "Total: £5.85"
    label.font = .boldSystemFont(ofSize: 18)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  // Control labels
  private var horizontalSpacingLabel: UILabel = {
    let label = UILabel()
    label.text = "↔️ Horizontal Spacing: 8"
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private var verticalSpacingLabel: UILabel = {
    let label = UILabel()
    label.text = "↕️ Vertical Spacing: 8"
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  private var fontSizeLabel: UILabel = {
    let label = UILabel()
    label.text = "🔤 Font Size: 100%"
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = UIColor(red: 0.2, green: 0.3, blue: 0.5, alpha: 1.0)
    label.numberOfLines = 0
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Actions

  @objc private func horizontalSliderChanged(_ sender: UISlider) {
    horizontalSpacing = CGFloat(sender.value)
    horizontalSpacingLabel.text = "↔️ Horizontal Spacing: \(Int(horizontalSpacing))"
    setNeedsLayout()
  }

  @objc private func verticalSliderChanged(_ sender: UISlider) {
    verticalSpacing = CGFloat(sender.value)
    verticalSpacingLabel.text = "↕️ Vertical Spacing: \(Int(verticalSpacing))"
    setNeedsLayout()
  }

  @objc private func fontSizeSliderChanged(_ sender: UISlider) {
    fontScale = CGFloat(sender.value)
    fontSizeLabel.text = "🔤 Font Size: \(Int(fontScale * 100))%"
    updateAllFontSizes()
    setNeedsLayout()
  }

  private func updateAllFontSizes() {
    // Header labels
    item.font = .boldSystemFont(ofSize: 18 * fontScale)
    itemDescription.font = .boldSystemFont(ofSize: 18 * fontScale)
    quantity.font = .boldSystemFont(ofSize: 18 * fontScale)
    price.font = .boldSystemFont(ofSize: 18 * fontScale)

    // Data rows
    orange.font = .systemFont(ofSize: 16 * fontScale, weight: .medium)
    orangeDescription.font = .systemFont(ofSize: 15 * fontScale)
    orangeQuantity.font = .systemFont(ofSize: 15 * fontScale)
    orangePrice.font = .systemFont(ofSize: 16 * fontScale, weight: .semibold)

    apple.font = .systemFont(ofSize: 16 * fontScale, weight: .medium)
    appleDescription.font = .systemFont(ofSize: 15 * fontScale)
    appleQuantity.font = .systemFont(ofSize: 15 * fontScale)
    applePrice.font = .systemFont(ofSize: 16 * fontScale, weight: .semibold)

    banana.font = .systemFont(ofSize: 16 * fontScale, weight: .medium)
    bananaDescription.font = .systemFont(ofSize: 15 * fontScale)
    bananaQuantity.font = .systemFont(ofSize: 15 * fontScale)
    bananaPrice.font = .systemFont(ofSize: 16 * fontScale, weight: .semibold)

    totalPrice.font = .boldSystemFont(ofSize: 20 * fontScale)
  }

  // MARK: - Layout

  var body: Layout {
    VStack {

      Spacer()

      Grid(
        alignment: .leading,
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing
      ) {
        GridRow {
          item
          itemDescription
          quantity
          price
        }

        GridRow {
          orange
          orangeDescription
          orangeQuantity
          orangePrice
        }

        GridRow {
          apple
          appleDescription
          appleQuantity
          applePrice
        }

        GridRow {
          banana
          bananaDescription
          bananaQuantity
          bananaPrice
        }

        GridRow {
          totalPrice
        }
      }
      .padding(.horizontal, 16)

      Spacer()

      Grid(alignment: .leading) {

        GridRow {
          horizontalSpacingLabel
            .layoutPriority(1)
          slider1
        }

        GridRow {
          verticalSpacingLabel
          slider2
        }

        GridRow {
          fontSizeLabel
          fontSizeSlider
        }
      }
      .padding(.horizontal, 16)
      .padding(.bottom, 32)
    }
  }
}

// MARK: Preview code

@available(iOS 17, *)
#Preview {
  GridLayoutExampleView()
}

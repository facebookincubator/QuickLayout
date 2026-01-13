/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

import UIKit

final class BarsListViewController: UIViewController {
  private var dataSource: UICollectionViewDiffableDataSource<Int, BarModel>?

  private lazy var layout = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 0
    layout.minimumLineSpacing = 0
    return layout
  }()

  private lazy var collectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(BarCardViewCell.self, forCellWithReuseIdentifier: BarCardViewCell.reuseIdentifier)

    collectionView.alwaysBounceVertical = true
    collectionView.isPagingEnabled = true
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.backgroundColor = .black

    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    configureDataSource()
  }

  override func loadView() {
    self.view = collectionView
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if layout.itemSize != view.bounds.size {
      layout.itemSize = view.bounds.size
    }
  }

  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Int, BarModel>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, item: BarModel) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BarCardViewCell.reuseIdentifier, for: indexPath) as? BarCardViewCell else {
        fatalError("Cannot create new cell")
      }
      cell.prepare(with: item)
      cell.delegate = self

      return cell
    }

    var snapshot = NSDiffableDataSourceSnapshot<Int, BarModel>()
    snapshot.appendSections([1])
    snapshot.appendItems(BarsStore.entries)
    dataSource?.apply(snapshot, animatingDifferences: false)
  }
}

extension BarsListViewController: BarCardViewCellDelegate {
  func didTapShareButton(_ cell: BarCardViewCell, bar: BarModel) {
    let itemsToShare: [Any] = ["Check this out!", bar.shareURL]
    let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
    activityVC.excludedActivityTypes = [.message, .airDrop]
    present(activityVC, animated: true, completion: nil)
  }
}

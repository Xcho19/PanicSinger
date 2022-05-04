//
//  MainCollectionViewController.swift
//  PanicSinger
//
//  Created by Xcho on 14.04.22.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {

    // MARK: - Model

    var cellModel = CellModel()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.setCollectionViewLayout(layout(), animated: false)
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 10

        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .fractionalHeight(1)
            )
        )

        item.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.6)
            ),
            subitem: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellModel.categoryNames.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        )

        var config = UIListContentConfiguration.cell()
        config.image = UIImage(named: cellModel.categoryNames[indexPath.row])
        config.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        config.imageProperties.cornerRadius = 10
        cell.contentConfiguration = config

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CellModel.categoryName = cellModel.categoryNames[indexPath.row]
        performSegue(withIdentifier: "Configurations", sender: UICollectionViewCell.self)
    }
}

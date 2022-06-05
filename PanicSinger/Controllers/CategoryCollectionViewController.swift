//
//  CategoryCollectionViewController.swift
//  PanicSinger
//
//  Created by Xcho on 14.04.22.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerIdentifier = "Header"

final class CategoryCollectionViewController: UICollectionViewController {
    // MARK: - Model

    var store = Categories.allStoreCategories.filter { !Categories.ownedCategoryNames.contains($0.name)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewConfigurations()
        navigationItem.backButtonTitle = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        store = Categories.allStoreCategories.filter { !Categories.ownedCategoryNames.contains($0.name)
        }
        collectionView.reloadData()
    }

    // MARK: - Helpers

    private func collectionViewConfigurations() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.setCollectionViewLayout(layout(), animated: false)
        collectionView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
        collectionView.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerIdentifier
        )
    }

    private func layout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 10

        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.5)
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
                heightDimension: .fractionalWidth(0.5)
            ),
            subitem: item,
            count: 2
        )

        let section = NSCollectionLayoutSection(group: group)

        section.boundarySupplementaryItems = [generateHeader()]
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 40,
            trailing: 0
        )

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func generateHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(60)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        store.isEmpty ? 1 : 2
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
        -> Int { (section == 0) ? Categories.ownedCategoryNames.count : store.count }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as? CategoryCollectionViewCell
        else { return UICollectionViewCell() }

        if indexPath.section == 0 {
            cell.categoryImageView.image = UIImage(
                named: Categories.ownedCategoryNames[indexPath.row]
            )
        } else {
            cell.categoryImageView.image = UIImage(
                named: store.map { $0.name }[indexPath.row]
            )
        }
        cell.categoryImageView.layer.cornerRadius = 10
        cell.categoryImageView.layer.masksToBounds = true

        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            Categories.ownedCategoryName = Categories.ownedCategoryNames[indexPath.row]

            if let configurationsViewController = UIStoryboard(
                name: "Configurations",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "configurationsViewController"
            ) as? ConfigurationsViewController {
                navigationController?.pushViewController(configurationsViewController, animated: true)
            }
        } else {
            if let purchaseViewController = UIStoryboard(
                name: "PurchaseView",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "PurchaseView"
            ) as? PurchaseViewController {
                purchaseViewController.category = store[indexPath.row]
                navigationController?.pushViewController(purchaseViewController, animated: true)
            }
        }
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: headerIdentifier,
                for: indexPath
            ) as? HeaderCollectionReusableView
            else { fatalError() }

            headerView.titleLabel.textColor = UIColor(
                red: 250/255,
                green: 249/255,
                blue: 246/255,
                alpha: 0.85
            )

            if indexPath.section == 0 {
                headerView.titleLabel.text = "My Categories"
            } else {
                headerView.titleLabel.text = "More Categories"
            }

            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
}

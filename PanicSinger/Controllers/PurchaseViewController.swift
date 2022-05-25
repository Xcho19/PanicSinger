//
//  PurchaseViewController.swift
//  PanicSinger
//
//  Created by Xcho on 15.05.22.
//

import UIKit

class PurchaseViewController: UIViewController {
    // MARK: - Model

    var category: Category!

    // MARK: - Subviews

    @IBOutlet var storeCategoryDescriptionLabel: UILabel!
    @IBOutlet var storeCategoryImageView: UIImageView!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var buyButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureLabelTexts()
        navigationItem.title = category.name
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Helpers

    private func configureSubviews() {
        let fontSize = round(view.frame.height/19)

        storeCategoryDescriptionLabel.font = UIFont(
            name: "Apple SD Gothic Neo",
            size: round(view.frame.height/40)
        )

        storeCategoryImageView.image = UIImage(named: category.name)
        storeCategoryImageView.layer.cornerRadius = 10

        priceLabel.font = UIFont(name: "Apple SD Gothic Neo", size: fontSize)

        buyButton.layer.cornerRadius = 10
        buyButton.backgroundColor = UIColor(
            red: 75/255,
            green: 74/255,
            blue: 174/255,
            alpha: 0.95
        )
    }

    private func configureLabelTexts() {
        for storeCategory in Categories.storeCategories where storeCategory.name == category.name {
            storeCategoryDescriptionLabel.text = storeCategory.description
            priceLabel.text = "$\(storeCategory.price)"
        }
    }

    // MARK: - Callbacks

    @IBAction func didTapBuyButton(_ sender: Any) {
        let alert = UIAlertController(
            title: "Purchase Confirmation",
            message: "You are about to purchase \(category.name) for $\(category.price)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Purchase",
            style: .default,
            handler: { _ in
                Categories.ownedCategoryNames.append(contentsOf: self.category.bundle)
                Categories.storeCategories = Categories.storeCategories.filter { $0 != self.category }
                UserDefaults.standard.set(Categories.ownedCategoryNames, forKey: "OwnedCategories")
                self.navigationController?.popViewController(animated: true)
            }
        ))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

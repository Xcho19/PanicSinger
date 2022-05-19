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
    var categories: Categories!

    // MARK: - Subviews

    @IBOutlet var storeCategoryNameLabel: UILabel!
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
        navigationItem.largeTitleDisplayMode = .never
    }

    // MARK: - Helpers

    private func configureSubviews() {
        let fontSize = round(view.frame.height/18)

        storeCategoryNameLabel.text = "\(category.name) Bundle"
        storeCategoryNameLabel.font = UIFont(name: "Apple SD Gothic Neo", size: fontSize)

        storeCategoryImageView.image = UIImage(named: category.name)
        storeCategoryImageView.layer.cornerRadius = 10

        priceLabel.font = UIFont(name: "Apple SD Gothic Neo", size: fontSize)

        buyButton.layer.cornerRadius = 10
        buyButton.backgroundColor = UIColor(
            red: 88/255,
            green: 86/255,
            blue: 207/255,
            alpha: 0.85
        )
    }

    private func configureLabelTexts() {
        switch category.name {
        case "Armenian":
            storeCategoryDescriptionLabel.text = category.description
            priceLabel.text = "$\(category.price)"
        case "Russian":
            storeCategoryDescriptionLabel.text = category.description
            priceLabel.text = "$\(category.price)"
        case "International":
            storeCategoryDescriptionLabel.text = category.description
            priceLabel.text = "$\(category.price)"
        default:
            break
        }
    }

    // MARK: - Callbacks

    @IBAction func didTapBuyButton(_ sender: Any) {
        let alert = UIAlertController(
            title: "Purchase Confirmation",
            message: "You are abuot to purchase \(category.name) for $\(category.price)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Purchase",
            style: .default,
            handler: { _ in
                self.categories.ownedCategoryNames.append(contentsOf: self.category.bundle)
                self.categories.storeCategories = self.categories.storeCategories.filter { $0 != self.category }
                self.navigationController?.popViewController(animated: true)
            }
        )
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

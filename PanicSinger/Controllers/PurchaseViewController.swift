//
//  PurchaseViewController.swift
//  PanicSinger
//
//  Created by Xcho on 15.05.22.
//

import StoreKit
import UIKit

class PurchaseViewController: UIViewController {
    // MARK: - Model

    var category: CategoryDescription!

    // MARK: - Subviews

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var indicatorView: UIView!
    @IBOutlet private var storeCategoryDescriptionLabel: UILabel!
    @IBOutlet private var storeCategoryImageView: UIImageView!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var buyButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        let restoreButton = UIBarButtonItem(
            title: "Restore",
            style: .plain,
            target: self,
            action: #selector(didTapRestore)
        )
        restoreButton.tintColor = UIColor(named: "BarButtonItem85")
        navigationItem.rightBarButtonItem = restoreButton
        SKPaymentQueue.default().add(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureLabelTexts()
        navigationItem.title = category.name
        navigationItem.largeTitleDisplayMode = .never
        indicatorView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }

    // MARK: - Helpers

    private func configureSubviews() {
        let fontSize = round(view.frame.height/19)

        indicatorView.layer.cornerRadius = 10

        storeCategoryDescriptionLabel.font = UIFont(
            name: "Apple SD Gothic Neo",
            size: round(view.frame.height/40)
        )

        storeCategoryImageView.image = UIImage(named: category.name)
        storeCategoryImageView.layer.cornerRadius = 10

        priceLabel.font = UIFont(name: "Apple SD Gothic Neo", size: fontSize)

        buyButton.layer.cornerRadius = 10
    }

    private func configureLabelTexts() {
        for storeCategory in Categories.allStoreCategories where storeCategory.name == category.name {
            storeCategoryDescriptionLabel.text = storeCategory.description
            priceLabel.text = "$0.99"
        }
    }

    private func startActivityIndicator() {
        activityIndicator.startAnimating()
        indicatorView.isHidden = false
    }

    private func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        indicatorView.isHidden = true
    }

    @objc
    private func didTapRestore() {
        if Connectivity.isConnectedToInternet {
            if SKPaymentQueue.canMakePayments() {
                startActivityIndicator()
                SKPaymentQueue.default().restoreCompletedTransactions()
            }
        }
    }

    // MARK: - Callbacks

    @IBAction func didTapBuyButton(_ sender: Any) {
        if Connectivity.isConnectedToInternet {
            if SKPaymentQueue.canMakePayments() {
                let paymentRequest = SKMutablePayment()
                paymentRequest.productIdentifier = category.storeID
                SKPaymentQueue.default().add(paymentRequest)
            } else {
                print("Unable to make the payment")
            }
        } else {
            let alert = UIAlertController(
                title: "No Connection",
                message: "Please check your connection and try again.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(
                title: "Ok",
                style: .default
            ))
            present(alert, animated: true)
        }
    }
}

extension PurchaseViewController: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                startActivityIndicator()
            case .purchased:
                Categories.ownedCategoryNames.append(category.name)
                UserDefaults.standard.set(Categories.ownedCategoryNames, forKey: "OwnedCategories")
                stopActivityIndicator()
                SKPaymentQueue.default().finishTransaction(transaction)
                navigationController?.popViewController(animated: true)
            case .failed:
                stopActivityIndicator()
                let alert = UIAlertController(
                    title: "Purchase Failed",
                    message: "Something went wrong.\n Please try again.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "Ok",
                    style: .default
                ))
                SKPaymentQueue.default().finishTransaction(transaction)
                present(alert, animated: true)
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                print("deferred")
            @unknown default:
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let productID = transaction.payment.productIdentifier as String
            let purchasedCategories = Categories.allStoreCategories.filter { $0.storeID == productID }.map { $0.name }

            if !purchasedCategories.filter({ !Categories.ownedCategoryNames.contains($0) }).isEmpty {
                Categories.ownedCategoryNames.append(
                    contentsOf: purchasedCategories.filter { !Categories.ownedCategoryNames.contains($0) }
                )
                UserDefaults.standard.set(Categories.ownedCategoryNames, forKey: "OwnedCategories")
                SKPaymentQueue.default().finishTransaction(transaction)
                stopActivityIndicator()
            } else {
                let alert = UIAlertController(
                    title: "Nothing To Restore",
                    message: "",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "Ok",
                    style: .default
                ))
                SKPaymentQueue.default().finishTransaction(transaction)
                present(alert, animated: true)
                stopActivityIndicator()
            }

            navigationController?.popViewController(animated: true)
        }
    }
}

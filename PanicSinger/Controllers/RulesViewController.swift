//
//  RulesViewController.swift
//  PanicSinger
//
//  Created by Xcho on 12.05.22.
//

import UIKit

class RulesViewController: UIViewController {
    // MARK: - Subviews

    @IBOutlet var indicatorView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet private var languageSegmentedControl: UISegmentedControl!
    @IBOutlet private var englishRules: UITextView!
    @IBOutlet private var armenianRules: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        indicatorView.layer.cornerRadius = 3
    }

    // MARK: - Helpers

    private func configureSegmentedControl() {
        switch languageSegmentedControl.selectedSegmentIndex {
        case 0:
            titleLabel.text = "Rules"
            englishRules.isHidden = false
            armenianRules.isHidden = true
        case 1:
            titleLabel.text = "Կանոններ"
            englishRules.isHidden = true
            armenianRules.isHidden = false
        default:
            englishRules.isHidden = false
            armenianRules.isHidden = true
        }
    }

    // MARK: - Callbacks

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        configureSegmentedControl()
    }
}

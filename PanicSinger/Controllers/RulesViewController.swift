//
//  RulesViewController.swift
//  PanicSinger
//
//  Created by Xcho on 12.05.22.
//

import UIKit

class RulesViewController: UIViewController {
    // MARK: - Subviews

    @IBOutlet private var languageSegmentedControl: UISegmentedControl!
    @IBOutlet private var englishRules: UITextView!
    @IBOutlet private var armenianRules: UITextView!

    // MARK: - Helpers

    private func configureSegmentedControl() {
        switch languageSegmentedControl.selectedSegmentIndex {
        case 0:
            navigationItem.title = "Rules"
            englishRules.isHidden = false
            armenianRules.isHidden = true
        case 1:
            navigationItem.title = "Կանոններ"
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

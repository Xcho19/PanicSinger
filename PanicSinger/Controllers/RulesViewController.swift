//
//  RulesViewController.swift
//  PanicSinger
//
//  Created by Xcho on 12.05.22.
//

import UIKit

class RulesViewController: UIViewController {

    @IBOutlet var languageSegmentedControl: UISegmentedControl!
    @IBOutlet var englishRules: UITextView!
    @IBOutlet var armenianRules: UITextView!
    @IBOutlet var russianRules: UITextView!

    private func configureSegmentedControl() {
        switch languageSegmentedControl.selectedSegmentIndex {
        case 0:
            navigationItem.title = "Rules"
            englishRules.isHidden = false
            armenianRules.isHidden = true
            russianRules.isHidden = true
        case 1:
            navigationItem.title = "Կանոններ"
            englishRules.isHidden = true
            armenianRules.isHidden = false
            russianRules.isHidden = true
        case 2:
            navigationItem.title = "Правилы"
            englishRules.isHidden = true
            armenianRules.isHidden = true
            russianRules.isHidden = false
        default:
            englishRules.isHidden = false
            armenianRules.isHidden = true
            russianRules.isHidden = true
        }
    }

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        configureSegmentedControl()
    }
}

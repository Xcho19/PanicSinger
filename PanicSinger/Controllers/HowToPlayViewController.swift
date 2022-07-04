//
//  HowToPlayViewController.swift
//  PanicSinger
//
//  Created by Xcho on 22.06.22.
//

import UIKit

final class HowToPlayViewController: UIViewController {
    // MARK: - Subviews

    @IBOutlet var indicatorView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var englishRulesLabel: UILabel!
    @IBOutlet var armenianRulesLabel: UILabel!
    @IBOutlet var languageSegmentedControl: UISegmentedControl!
    @IBOutlet var russianRulesLabel: UILabel!
    @IBOutlet var swipeDownLabel: UILabel!
    @IBOutlet var swipeUpLabel: UILabel!
    @IBOutlet var correctImageView: UIImageView!
    @IBOutlet var passImageView: UIImageView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureGifs()
        configureFonts()
        indicatorView.layer.cornerRadius = 3
    }

    // MARK: - Helpers

    private func configureGifs() {
        let correctGif = UIImage.gifImageWithName("Correct")
        correctImageView.image = correctGif

        let passGif = UIImage.gifImageWithName("Pass")
        passImageView.image = passGif
    }

    private func configureFonts() {
        FontConfigurations.shared.configureFont(
            label: armenianRulesLabel,
            fontName: "Helvetica Neue Bold",
            smallestFontSize: 16,
            frame: view.frame.width
        )
        FontConfigurations.shared.configureFont(
            label: englishRulesLabel,
            fontName: "Helvetica Neue Bold",
            smallestFontSize: 16,
            frame: view.frame.width
        )
        FontConfigurations.shared.configureFont(
            label: russianRulesLabel,
            fontName: "Helvetica Neue Bold",
            smallestFontSize: 16,
            frame: view.frame.width
        )

        FontConfigurations.shared.configureFont(
            label: swipeUpLabel,
            fontName: "Helvetica Neue Bold",
            smallestFontSize: 26,
            frame: view.frame.width
        )
        FontConfigurations.shared.configureFont(
            label: swipeDownLabel,
            fontName: "Helvetica Neue Bold",
            smallestFontSize: 26,
            frame: view.frame.width
        )

        FontConfigurations.shared.configureFont(
            label: headerLabel,
            fontName: "Helvetica Neue Bold",
            smallestFontSize: 40,
            frame: view.frame.width
        )
    }

    private func configureSegmentedControl() {
        switch languageSegmentedControl.selectedSegmentIndex {
        case 0:
            headerLabel.text = "How To Play"
            englishRulesLabel.isHidden = false
            armenianRulesLabel.isHidden = true
            russianRulesLabel.isHidden = true
        case 1:
            headerLabel.text = "Կանոններ"
            englishRulesLabel.isHidden = true
            armenianRulesLabel.isHidden = false
            russianRulesLabel.isHidden = true
        case 2:
            headerLabel.text = "Правила Игры"
            englishRulesLabel.isHidden = true
            armenianRulesLabel.isHidden = true
            russianRulesLabel.isHidden = false
        default:
            englishRulesLabel.isHidden = false
            armenianRulesLabel.isHidden = true
            russianRulesLabel.isHidden = true
        }
    }

    // MARK: - Callbacks

    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        configureSegmentedControl()
    }
}

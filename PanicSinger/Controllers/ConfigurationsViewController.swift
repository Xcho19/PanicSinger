//
//  ConfigurationsViewController.swift
//  PanicSinger
//
//  Created by Xcho on 20.04.22.
//

import UIKit

class ConfigurationsViewController: UIViewController {

    // MARK: - Model

    var totalTime = 60

    // MARK: - Subviews

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var decreaseTimeButton: UIButton!
    @IBOutlet weak var increaseTimeButton: UIButton!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        timerLabel.text = timeFormatted(totalTime)
    }

    // MARK: - Helpers

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    // MARK: - Callbacks

    @IBAction func didTapDecreaseTimeButton(_ sender: Any) {
        if totalTime > 60 {
            totalTime -= 30
            timerLabel.text = timeFormatted(totalTime)
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.1,
            options: []) {
                self.decreaseTimeButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.decreaseTimeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }

    @IBAction func didTapIncreaseTimeButton(_ sender: Any) {
        if totalTime < 300 {
            totalTime += 30
            timerLabel.text = timeFormatted(totalTime)
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.1,
            options: []) {
                self.increaseTimeButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.increaseTimeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
}

//
//  ConfigurationsViewController.swift
//  PanicSinger
//
//  Created by Xcho on 20.04.22.
//

import UIKit

class ConfigurationsViewController: UIViewController, GamePlayViewControllerDelegate {

    // MARK: - Model

    var usedSongs: [String] = []
    var totalTime = 5

    lazy var correctResultsLabels: [UILabel] = [UILabel]()
    lazy var resultsLabels: [UILabel] = [UILabel]()

    // MARK: - Subviews

    @IBOutlet var resultsStackView: UIStackView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var decreaseTimeButton: UIButton!
    @IBOutlet var increaseTimeButton: UIButton!
    @IBOutlet var resultsScrollView: UIScrollView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        resultsScrollView.isHidden = true
        resultsScrollView.layer.cornerRadius = 10
        categoryImageView.image = UIImage(named: CellModel.categoryName)
        categoryImageView.layer.cornerRadius = 10
        timerLabel.text = timeFormatted(totalTime)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.view.layoutSubviews()
        resultsStackView.addArrangedSubviews(correctResultsLabels)
        resultsStackView.addArrangedSubviews(resultsLabels)
    }

    // MARK: - Helpers

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    func getResults(correct: [String], notCorrect: [String], usedSongs: [String]) {
         correctResultsLabels = {
            correct.map { song in
                let songLabel = UILabel()
                songLabel.text = song
                songLabel.textAlignment = .center
                songLabel.textColor = .white
                songLabel.numberOfLines = 0
                songLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 25)

                return songLabel
            }
        }()

        resultsLabels = {
            notCorrect.map { song in
                let songLabel = UILabel()
                songLabel.text = song
                songLabel.textAlignment = .center
                songLabel.textColor = .lightGray
                songLabel.numberOfLines = 0
                songLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 25)

                return songLabel
            }
        }()
        resultsScrollView.isHidden = false
        categoryImageView.isHidden = true
        self.usedSongs = usedSongs
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
        if totalTime < 180 {
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

    @IBAction func didTapStartButton(_ sender: Any) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gamePlayViewController = segue.destination as? GamePlayViewController else { return }

        resultsStackView.subviews.forEach { $0.removeFromSuperview() }
        gamePlayViewController.totalTime = totalTime
        gamePlayViewController.usedSongs = usedSongs
        gamePlayViewController.delegate = self
    }
}
extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.enumerated().forEach { insertArrangedSubview($0.1, at: $0.0) }
    }
}

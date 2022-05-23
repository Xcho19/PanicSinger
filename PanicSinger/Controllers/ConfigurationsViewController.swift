//
//  ConfigurationsViewController.swift
//  PanicSinger
//
//  Created by Xcho on 20.04.22.
//

import SwiftySound
import UIKit

final class ConfigurationsViewController: UIViewController {
    // MARK: - Model

    var totalTime = 5
    var usedSongs: [String] = []
    var categories = Categories()
    var state = State.normalView

    lazy var correctResultsLabels: [UILabel] = .init()
    lazy var skippedResultsLabels: [UILabel] = .init()

    // MARK: - Subviews

    @IBOutlet var resultsStackView: UIStackView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var resultsScrollView: UIScrollView!
    @IBOutlet var categoryDescriptionLabel: UILabel!
    @IBOutlet var decreaseTimeButton: UIButton!
    @IBOutlet var increaseTimeButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resultView: UIView!
    @IBOutlet var guessedSongsCountLabel: UILabel!
    @IBOutlet var guessedSongsRightSideLabel: UILabel!
    @IBOutlet var guessedSongsLeftSideLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subviewConfigurations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationItem.backButtonTitle = ""
        navigationController?.view.layoutSubviews()
        resultsStackView.addArrangedSubviews(skippedResultsLabels)
        resultsStackView.addArrangedSubviews(correctResultsLabels)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        stateConfiguration()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = Categories.ownedCategoryName
        resultView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        fontConfigurations(frameWidth: view.frame.width)
    }

    // MARK: - Helpers

    private func subviewConfigurations() {
        resultsScrollView.layer.cornerRadius = 10
        resultsScrollView.showsVerticalScrollIndicator = false
        resultsScrollView.backgroundColor = UIColor(
            red: 75/255,
            green: 74/255,
            blue: 174/255,
            alpha: 0.4
        )

        for category in categories.allCategories where category.name == Categories.ownedCategoryName {
            categoryDescriptionLabel.text = category.description
        }

        categoryImageView.image = UIImage(named: Categories.ownedCategoryName)
        categoryImageView.layer.cornerRadius = 10

        startButton.backgroundColor = UIColor(
            red: 75/255,
            green: 74/255,
            blue: 174/255,
            alpha: 0.95
        )
        startButton.layer.cornerRadius = 10

        timerLabel.text = timeFormatted(totalTime)

        resultView.layer.cornerRadius = 10
    }

    private func fontConfigurations(frameWidth: Double) {
        let fontSize = round(frameWidth/14)

        guessedSongsRightSideLabel.font = UIFont(
            name: "Arial Rounded MT Bold",
            size: fontSize
        )

        guessedSongsLeftSideLabel.font = UIFont(
            name: "Arial Rounded MT Bold",
            size: fontSize
        )

        guessedSongsCountLabel.font = UIFont(
            name: "Arial Rounded MT Bold",
            size: fontSize + 14
        )

        categoryDescriptionLabel.font = UIFont(
            name: "Apple SD Gothic Neo",
            size: round(view.frame.height/35)
        )
    }

    private func stateConfiguration() {
        if state == State.normalView {
            resultView.isHidden = true
            resultsScrollView.isHidden = true
            categoryImageView.isHidden = false
            categoryDescriptionLabel.isHidden = false
        } else {
            resultView.isHidden = false
            resultsScrollView.isHidden = false
            categoryImageView.isHidden = true
            categoryDescriptionLabel.isHidden = true
        }
    }

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds/60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func createLabels(from array: [String], alpha: Double = 1) -> [UILabel] {
        array.map { song -> UILabel in
            let songLabel = UILabel()
            songLabel.text = song
            songLabel.textAlignment = .center
            songLabel.textColor = .white
            songLabel.alpha = alpha
            songLabel.numberOfLines = 0
            songLabel.font = UIFont(
                name: "Apple SD Gothic Neo",
                size: round(view.frame.height/32)
            )

            return songLabel
        }
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
            options: []
        ) {
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
            options: []
        ) {
            self.increaseTimeButton.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.increaseTimeButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gamePlayViewController = segue.destination as? GamePlayViewController else { return }

        resultsStackView.subviews.forEach { $0.removeFromSuperview() }
        gamePlayViewController.totalTime = totalTime
        gamePlayViewController.usedSongs = usedSongs
        gamePlayViewController.delegate = self
    }
}

extension ConfigurationsViewController: GamePlayViewControllerDelegate {
    func getResultsFrom(correctSongs: [String], skippedSongs: [String], usedSongs: [String]) {
        correctResultsLabels = createLabels(from: correctSongs)
        skippedResultsLabels = createLabels(from: skippedSongs, alpha: 0.4)

        if correctSongs.count == 1 {
            guessedSongsRightSideLabel.text = "SONG!"
        } else {
            guessedSongsRightSideLabel.text = "SONGS!"
        }

        stateConfiguration()
        guessedSongsCountLabel.text = "\(correctSongs.count)"
        self.usedSongs = usedSongs
    }

    func getTotalTime(time: Int) {
        if time > 0 {
            state = State.normalView
            Sound.stopAll()
        } else {
            state = State.resultView
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.enumerated().forEach { insertArrangedSubview($0.1, at: $0.0) }
    }
}

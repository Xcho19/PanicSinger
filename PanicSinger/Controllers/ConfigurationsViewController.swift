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

    var totalTime = 60
    var usedSongs: [String] = []
    var state = ConfigurationsState.normalView { didSet {
        configureState()
    }}

    lazy var correctResultsLabels: [UILabel] = .init()
    lazy var skippedResultsLabels: [UILabel] = .init()

    // MARK: - Subviews

    @IBOutlet private var resultsStackView: UIStackView!
    @IBOutlet private var categoryImageView: UIImageView!
    @IBOutlet private var resultsScrollView: UIScrollView!
    @IBOutlet private var categoryDescriptionLabel: UILabel!
    @IBOutlet private var decreaseTimeButton: UIButton!
    @IBOutlet private var increaseTimeButton: UIButton!
    @IBOutlet private var timerLabel: UILabel!
    @IBOutlet private var startButton: UIButton!
    @IBOutlet private var resultView: UIView!
    @IBOutlet private var guessedSongsCountLabel: UILabel!
    @IBOutlet private var guessedSongsRightSideLabel: UILabel!
    @IBOutlet private var guessedSongsLeftSideLabel: UILabel!
    @IBOutlet private var resultsContainerView: UIView!
    @IBOutlet private var categoryImageContainerView: UIView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureState()
        configureSubviews()
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

        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = Categories.ownedCategoryName
        resultView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        configureFont(frameWidth: view.frame.width)
    }

    // MARK: - Helpers

    private func configureSubviews() {
        resultsScrollView.layer.cornerRadius = 10

        for category in Categories.allCategories where category.name == Categories.ownedCategoryName {
            categoryDescriptionLabel.text = category.description
        }

        categoryImageView.image = UIImage(named: Categories.ownedCategoryName)
        categoryImageView.layer.cornerRadius = 10

        startButton.layer.cornerRadius = 10

        timerLabel.text = formatTime(totalTime)

        resultView.layer.cornerRadius = 10
    }

    private func configureFont(frameWidth: Double) {
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
    }

    private func configureState() {
        resultsContainerView.isHidden = state == ConfigurationsState.normalView
        categoryImageContainerView.isHidden = state == ConfigurationsState.resultView
    }

    private func formatTime(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds/60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func createLabels(from songs: [String], alpha: Double = 1) -> [UILabel] {
        songs.map { song in
            let songLabel = UILabel()
            songLabel.text = song
            songLabel.textAlignment = .center
            songLabel.textColor = .white
            songLabel.alpha = alpha
            songLabel.numberOfLines = 0
            songLabel.font = UIFont(
                name: "Apple SD Gothic Neo",
                size: round(view.frame.width/32)
            )

            return songLabel
        }
    }

    // MARK: - Callbacks

    @IBAction func didTapDecreaseTimeButton(_ sender: Any) {
        if totalTime > 60 {
            totalTime -= 30
            timerLabel.text = formatTime(totalTime)
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
            timerLabel.text = formatTime(totalTime)
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
            guessedSongsRightSideLabel.text = "SONG !"
        } else {
            guessedSongsRightSideLabel.text = "SONGS !"
        }

        guessedSongsCountLabel.text = "\(correctSongs.count)"
        self.usedSongs = usedSongs
    }

    func getTotalTime(time: Int) {
        if time > 0 {
            state = ConfigurationsState.normalView
            Sound.stopAll()
        } else {
            state = ConfigurationsState.resultView
        }
    }
}

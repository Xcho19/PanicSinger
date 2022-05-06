//
//  ConfigurationsViewController.swift
//  PanicSinger
//
//  Created by Xcho on 20.04.22.
//

import UIKit

final class ConfigurationsViewController: UIViewController {
    // MARK: - Model

    var usedSongs: [String] = []
    var totalTime = 5
    var timerValueAtExit = 0

    lazy var correctResultsLabels: [UILabel] = .init()
    lazy var skippedResultsLabels: [UILabel] = .init()

    // MARK: - Subviews

    @IBOutlet var resultsStackView: UIStackView!
    @IBOutlet var categoryImageView: UIImageView!
    @IBOutlet var resultsScrollView: UIScrollView!
    @IBOutlet var decreaseTimeButton: UIButton!
    @IBOutlet var increaseTimeButton: UIButton!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var resultView: UIView!
    @IBOutlet var scoreView: UIView!
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

        if timerValueAtExit > 0 {
            categoryImageView.isHidden = false
            resultsScrollView.isHidden = true
            resultView.isHidden = true
            scoreView.isHidden = true
        }

        navigationItem.largeTitleDisplayMode = .never
        resultView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        scoreView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        fontConfigurations(frameWidth: view.frame.width)
    }

    // MARK: - Helpers

    private func subviewConfigurations() {
        resultsScrollView.isHidden = true
        resultsScrollView.layer.cornerRadius = 10
        resultsScrollView.showsVerticalScrollIndicator = false
        resultsScrollView.backgroundColor = UIColor(
            red: 88/255,
            green: 86/255,
            blue: 207/255,
            alpha: 0.4
        )

        categoryImageView.image = UIImage(named: CellModel.categoryName)
        categoryImageView.layer.cornerRadius = 10

        startButton.backgroundColor = UIColor(
            red: 88/255,
            green: 86/255,
            blue: 207/255,
            alpha: 0.85
        )
        startButton.layer.cornerRadius = 10

        timerLabel.text = timeFormatted(totalTime)

        resultView.isHidden = true
        resultView.layer.cornerRadius = 10

        scoreView.layer.cornerRadius = scoreView.layer.frame.width/2
        scoreView.isHidden = true
    }

    private func fontConfigurations(frameWidth: Double) {
        let fontSize = round(frameWidth/16)

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
            size: fontSize + 12
        )
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
                size: round(view.frame.width/32)
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
    func getResultsFrom(correct: [String], skipped: [String], usedSongs: [String]) {
        correctResultsLabels = createLabels(from: correct)
        skippedResultsLabels = createLabels(from: skipped, alpha: 0.4)

        if correct.count == 1 {
            guessedSongsRightSideLabel.text = "SONG!"
        } else {
            guessedSongsRightSideLabel.text = "SONGS!"
        }

        resultView.isHidden = false
        resultsScrollView.isHidden = false
        scoreView.isHidden = false
        categoryImageView.isHidden = true
        guessedSongsCountLabel.text = "\(correct.count)"
        self.usedSongs = usedSongs
    }

    func getTotalTime(time: Int) {
        timerValueAtExit = time
    }
}

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.enumerated().forEach { insertArrangedSubview($0.1, at: $0.0) }
    }
}

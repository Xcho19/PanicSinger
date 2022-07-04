//
//  GamePlayViewController.swift
//  PanicSinger
//
//  Created by Xcho on 28.04.22.
//

import SwiftySound
import UIKit

protocol GamePlayViewControllerDelegate: AnyObject {
    func getResultsFrom(correctSongs: [String], skippedSongs: [String])
    func getTotalTime(time: Int)
}

// swiftlint:disable all
final class GamePlayViewController: UIViewController {
    // MARK: - Dependencies

    weak var delegate: GamePlayViewControllerDelegate?

    // MARK: - Model

    private var song: String = ""
    var songs: [String] = []
    var guessedSongs: [String] = []
    var skippedSongs: [String] = []
    var totalTime = 0
    private var totalCountdownTime = 4
    private var countdownTimer: Timer?
    private var timer: Timer?

    // MARK: - Subviews

    @IBOutlet private var countdownLabel: UILabel!
    @IBOutlet private var countdownView: UIView!
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var timerLabel: UILabel!
    @IBOutlet private var answerView: UIView!
    @IBOutlet private var answerLabel: UILabel!
    @IBOutlet private var closeButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        startCountdownTimer()
        setViewBorder()
        UIApplication.shared.isIdleTimerDisabled = true
        getSongsFor(category: Categories.ownedCategoryName)
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        countdownView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resetTimer()
        countdownTimer?.invalidate()
        delegate?.getTotalTime(time: totalTime)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge { .all }

    // MARK: - Helpers

    // Subview Configurations
    private func configureSubviews() {
        timerLabel.text = formatTime(totalTime)
        countdownLabel.text = "\(totalCountdownTime - 1)"

        FontConfigurations.shared.configureFont(
            label: songNameLabel,
            fontName: "Helvetica Neue Bold",
            smallestFontSize: 38,
            frame: view.frame.height
        )
    }

    private func setViewBorder() {
        if UIDevice.current.hasNotch {
            view.layer.cornerRadius = 50
            answerView.layer.cornerRadius = 50
        } else {
            view.layer.cornerRadius = 40
            answerView.layer.cornerRadius = 40
        }
        view.layer.borderWidth = 14
        view.layer.borderColor = UIColor.white.cgColor
    }

    private func animateTransform(with label: UILabel) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.2,
            options: []
        ) {
            label.transform = CGAffineTransform(scaleX: 3.5, y: 3.5)
            label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }

    private func animateView(
        view: UIView,
        label: UILabel,
        viewAlpha: Double,
        labelAlpha: Double,
        transitionOption: UIView.AnimationOptions
    ) {
        UIView.transition(
            with: answerView,
            duration: 0.2,
            options: transitionOption,
            animations: {
                view.alpha = viewAlpha
            }
        )

        UILabel.animate(
            withDuration: 0.2,
            delay: 0,
            options: transitionOption,
            animations: {
                label.alpha = labelAlpha
            }
        )
    }

    // Haptic feedback configurations
    private func addHaptics(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    // Countdown Timer
    private func startCountdownTimer() {
        addHaptics(style: .medium)
        totalCountdownTime -= 1
        countdownTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateCountdownTimer),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func updateCountdownTimer() {
        animateTransform(with: countdownLabel)
        if totalCountdownTime > 1 {
            countdownLabel.text = "\(totalCountdownTime - 1)"
            addHaptics(style: .medium)
            totalCountdownTime -= 1
        } else if totalCountdownTime == 1 {
            addHaptics(style: .medium)
            countdownLabel.text = "GO!"
            totalCountdownTime -= 1
        } else if let timer = countdownTimer {
            addHaptics(style: .heavy)
            timer.invalidate()
            countdownTimer = nil
            animateView(
                view: countdownView,
                label: countdownLabel,
                viewAlpha: 0,
                labelAlpha: 0,
                transitionOption: .transitionCrossDissolve
            )
            addPanGesture(to: view)
            startTimer()
        }
    }

    // Timer Configurations
    private func startTimer() {
        totalTime -= 1
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func updateTimer() {
        timerLabel.text = formatTime(totalTime)
        if totalTime != 0 {
            totalTime -= 1
        } else if let timer = timer {
            timer.invalidate()
            self.timer = nil
            delegate?.getResultsFrom(correctSongs: guessedSongs, skippedSongs: skippedSongs)
            dismiss(animated: false)
        }

        switch totalTime {
        case 2:
            if let countdownUrl = Bundle.main.url(
                forResource: "countdown",
                withExtension: "wav"
            ) {
                Sound.play(url: countdownUrl)
            }
            addHaptics(style: .medium)
            animateTransform(with: timerLabel)
        case 1:
            addHaptics(style: .medium)
            animateTransform(with: timerLabel)
        case 0:
            addHaptics(style: .heavy)
            animateTransform(with: timerLabel)
        default:
            break
        }
    }

    private func formatTime(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            timerLabel.text = formatTime(totalTime)
        }
    }

    // Dictionary data configurations
    private func getSongsFor(category: String) {
        guard let songURL = Bundle.main.url(forResource: "Songs", withExtension: "plist"),
              let categoriesDict = NSDictionary(contentsOf: songURL) as? [String: [String]]
        else { return }
        songs = categoriesDict[category]!
        print(songs.map {$0}.joined(separator: "\n"))
        getNewSong(from: songs)
    }

    private func getNewSong(from songCategory: [String]) {
        if let randomSong = songCategory.shuffled().first(where: {
            !ConfigurationsViewController.usedSongs.contains($0)
        }) {
            ConfigurationsViewController.usedSongs.append(randomSong)
            song = randomSong
            songNameLabel.text = randomSong
        } else {
            ConfigurationsViewController.usedSongs = ConfigurationsViewController.usedSongs.filter {
                !songCategory.contains($0)
            }
            songNameLabel.text = songCategory.shuffled().first
        }
    }

    // Pan gesture configurations
    private func addPanGesture(to view: UIView) {
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleSwipes(_:))
        )
        view.addGestureRecognizer(pan)
    }

    private func configurePanGesture(
        sender: UIPanGestureRecognizer,
        labelText: String,
        answerArray: inout [String]
    ) {
        switch sender.state {
        case .began, .changed:
            animateView(
                view: answerView,
                label: songNameLabel,
                viewAlpha: 0.9,
                labelAlpha: 0,
                transitionOption: .transitionCrossDissolve
            )
            answerLabel.text = labelText
        case .ended:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            answerArray.append(song)
            getNewSong(from: songs)
            animateView(
                view: answerView,
                label: songNameLabel,
                viewAlpha: 0,
                labelAlpha: 1,
                transitionOption: .transitionCrossDissolve
            )
        case .cancelled:
            animateView(
                view: answerView,
                label: songNameLabel,
                viewAlpha: 0,
                labelAlpha: 1,
                transitionOption: .transitionCrossDissolve
            )
        default:
            break
        }
    }

    // MARK: - GestureHandler

    @objc
    private func handleSwipes(_ sender: UIPanGestureRecognizer) {
        if sender.translation(in: view.superview).y > 50 {
            answerView.backgroundColor = UIColor(named: "CorrectView90")
            configurePanGesture(
                sender: sender,
                labelText: "CORRECT",
                answerArray: &guessedSongs
            )
        } else if sender.translation(in: view.superview).y < -50 {
            answerView.backgroundColor = UIColor(named: "PassView90")
            configurePanGesture(
                sender: sender,
                labelText: "PASS",
                answerArray: &skippedSongs
            )
        } else {
            animateView(
                view: answerView,
                label: songNameLabel,
                viewAlpha: 0,
                labelAlpha: 1,
                transitionOption: .transitionCrossDissolve
            )
        }
    }

    // MARK: - Callbacks

    @IBAction func didTapCloseButton(_ sender: UIButton) {
        dismiss(animated: false)
    }
}


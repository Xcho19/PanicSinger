//
//  GamePlayViewController.swift
//  PanicSinger
//
//  Created by Xcho on 28.04.22.
//

import SwiftySound
import UIKit

protocol GamePlayViewControllerDelegate: AnyObject {
    func getResultsFrom(correctSongs: [String], skippedSongs: [String], usedSongs: [String])
    func getTotalTime(time: Int)
}

final class GamePlayViewController: UIViewController {
    // MARK: - Dependencies

    weak var delegate: GamePlayViewControllerDelegate?

    // MARK: - Model

    var usedSongs: [String] = []
    var songs: [String] = []
    private var song: String = ""
    var guessedSongs: [String] = []
    var skippedSongs: [String] = []
    var totalTime = 0
    private var totalCountdownTime = 4
    private var initialCenter = CGPoint()
    private var countdownTimer: Timer?
    private var timer: Timer?

    // MARK: - Subviews

    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var countdownView: UIView!
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var answerView: UIView!
    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var closeButton: UIButton!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        startCountdownTimer()
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

    // MARK: - Helpers

    // Subview Configurations
    private func configureSubviews() {
        initialCenter = view.center
        timerLabel.text = timeFormatted(totalTime)
        countdownLabel.text = "\(totalCountdownTime - 1)"
    }

    private func configureViewColor(red: Double, green: Double, blue: Double) {
        answerView.backgroundColor = UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 0.9
        )
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
        if totalCountdownTime > 1 {
            countdownLabel.text = "\(totalCountdownTime - 1)"
            addHaptics(style: .medium)
            totalCountdownTime -= 1
        } else if totalCountdownTime == 1 {
            addHaptics(style: .heavy)
            countdownLabel.text = "GO!"
            totalCountdownTime -= 1
        } else if let timer = countdownTimer {
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
        timerLabel.text = timeFormatted(totalTime)
        if totalTime != 0 {
            totalTime -= 1
        } else if let timer = timer {
            timer.invalidate()
            self.timer = nil
            delegate?.getResultsFrom(correctSongs: guessedSongs, skippedSongs: skippedSongs, usedSongs: usedSongs)
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
        case 1:
            addHaptics(style: .medium)
        case 0:
            addHaptics(style: .heavy)
        default:
            break
        }
    }

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds/60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            timerLabel.text = timeFormatted(totalTime)
        }
    }

    // Dictionary data configurations
    private func getSongsFor(category: String) {
        guard let songURL = Bundle.main.url(forResource: "Songs", withExtension: "plist")
        else { return }

        if let categoriesDict = NSDictionary(contentsOf: songURL) as? [String: [String]] {
            songs = categoriesDict[category]!
            getNewSong(from: songs)
        }
    }

    private func getNewSong(from songCategory: [String]) {
        if let randomSong = songCategory.shuffled().first(where: {
            !usedSongs.contains($0)
        }) {
            usedSongs.append(randomSong)
            song = randomSong
            songNameLabel.text = randomSong
        } else {
            usedSongs.removeAll()
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

    private func panConfigurations(
        sender: UIPanGestureRecognizer,
        labelText: String,
        answerArray: inout [String]
    ) {
        switch sender.state {
        case .began:
            initialCenter = view.center
        case .changed:
            animateView(
                view: answerView,
                label: songNameLabel,
                viewAlpha: 0.9,
                labelAlpha: 0,
                transitionOption: .transitionCrossDissolve
            )
            answerLabel.text = labelText
        case .ended:
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

    // MARK: - Gesturehandler

    @objc
    private func handleSwipes(_ sender: UIPanGestureRecognizer) {
        if sender.translation(in: view.superview).y > 50 {
            configureViewColor(red: 95/255, green: 173/255, blue: 65/255)
            panConfigurations(
                sender: sender,
                labelText: "CORRECT",
                answerArray: &guessedSongs
            )
        } else if sender.translation(in: view.superview).y < -50 {
            configureViewColor(red: 243/255, green: 167/255, blue: 18/255)
            panConfigurations(
                sender: sender,
                labelText: "PASS",
                answerArray: &skippedSongs
            )
        } else {
            animateView(
                view: answerView,
                label: answerLabel,
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

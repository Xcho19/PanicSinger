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
    var totalTime: Int!
    private var initialCenter = CGPoint()
    private var timer: Timer?

    // MARK: - Subviews

    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var answerView: UIView!
    @IBOutlet var answerLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureSubviews()
        getSongsFor(category: CellModel.categoryName)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startOtpTimer()
        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        resetTimer()
        delegate?.getTotalTime(time: totalTime)
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    // MARK: - Helpers

    // Subview Configurations
    private func configureSubviews() {
        addPanGesture(to: view)
        initialCenter = view.center
        answerView.layer.cornerRadius = 20
        timerLabel.text = timeFormatted(totalTime)
    }

    private func configureViewColor(red: Double, green: Double, blue: Double) {
        answerView.backgroundColor = UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 0.9
        )
    }

    private func animateView(viewAlpha: Double, labelAlpha: Double, transitionOption: UIView.AnimationOptions) {
        UIView.transition(
            with: answerView,
            duration: 0.2,
            options: transitionOption,
            animations: {
                self.answerView.alpha = viewAlpha
            }
        )

        UILabel.animate(
            withDuration: 0.2,
            delay: 0,
            options: transitionOption,
            animations: {
                self.songNameLabel.alpha = labelAlpha
            }
        )
    }

    // Haptic feedback configurations
    private func addHaptics(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    // Timer Configurations
    private func startOtpTimer() {
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
            navigationController?.popViewController(animated: false)
        }

        switch totalTime {
        case 2:
            if let countdownUrl = Bundle.main.url(
                forResource: "countdown",
                withExtension: "wav"
            ) {
                Sound.play(url: countdownUrl)
            }

            addHaptics(style: .light)
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
            animateView(viewAlpha: 0.9, labelAlpha: 0, transitionOption: .transitionCrossDissolve)
            answerLabel.text = labelText
        case .ended:
            answerArray.append(song)
            getNewSong(from: songs)
            animateView(viewAlpha: 0, labelAlpha: 1, transitionOption: .transitionCrossDissolve)
        case .cancelled:
            animateView(viewAlpha: 0, labelAlpha: 1, transitionOption: .transitionCrossDissolve)
        default:
            break
        }
    }

    // MARK: - Gesturehandler

    @objc
    private func handleSwipes(_ sender: UIPanGestureRecognizer) {
        if sender.translation(in: view.superview).y > 50 {
            configureViewColor(red: 89/255, green: 189/255, blue: 65/255)
            panConfigurations(
                sender: sender,
                labelText: "CORRECT",
                answerArray: &guessedSongs
            )
        } else if sender.translation(in: view.superview).y < -50 {
            configureViewColor(red: 202/255, green: 133/255, blue: 46/255)
            panConfigurations(
                sender: sender,
                labelText: "PASS",
                answerArray: &skippedSongs
            )
        } else {
            animateView(viewAlpha: 0, labelAlpha: 1, transitionOption: .transitionCrossDissolve)
        }
    }
}

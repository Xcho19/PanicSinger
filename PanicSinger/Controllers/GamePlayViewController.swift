//
//  GamePlayViewController.swift
//  PanicSinger
//
//  Created by Xcho on 28.04.22.
//

import UIKit

protocol GamePlayViewControllerDelegate: AnyObject {
    func getResultsFrom(correct: [String], skipped: [String], usedSongs: [String])
    func getTotalTime(time: Int)
}

final class GamePlayViewController: UIViewController {
    // MARK: - Dependencies

    weak var delegate: GamePlayViewControllerDelegate?

    // MARK: - Subviews

    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var answerImageView: UIImageView!

    // MARK: - Model

    var usedSongs: [String] = []
    var songs: [String] = []
    private var song: String = ""
    var guessedSongs: [String] = []
    var skippedSongs: [String] = []
    var totalTime: Int!
    private var initialCenter = CGPoint()
    private var timer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialCenter = view.center
        timerLabel.text = timeFormatted(totalTime)
        getSongsFor(category: CellModel.categoryName)

        let panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(handleSwipes(_:))
        )
        view.addGestureRecognizer(panGesture)
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
            delegate?.getResultsFrom(correct: guessedSongs, skipped: skippedSongs, usedSongs: usedSongs)
            navigationController?.popViewController(animated: false)
        }

        switch totalTime {
        case 2:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case 1:
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        case 0:
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        default:
            break
        }
    }

    private func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60

        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func resetTimer() {
        if let timer = timer {
            timer.invalidate()
            timerLabel.text = timeFormatted(totalTime)
        }
    }

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

    private func animate(imageAlpha: Double) {
        UIImageView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseIn,
            animations: {
                self.answerImageView.alpha = imageAlpha
            }
        )
    }

    private func animateUserInteractions() {
        let correctView = UIView()
        correctView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(correctView)

        
    }

    // MARK: - Gesturehandler

    @objc
    // swiftlint:disable:next cyclomatic_complexity
    func handleSwipes(_ sender: UIPanGestureRecognizer) {
        if sender.translation(in: view.superview).y < -50 {
            switch sender.state {
            case .began:
                initialCenter = view.center
            case .changed:
                answerImageView.image = UIImage(named: "pass")
                animate(imageAlpha: 1.0)
            case .ended:
                skippedSongs.append(song)
                getNewSong(from: songs)
                animate(imageAlpha: 0)
            case .cancelled:
                animate(imageAlpha: 0)
            default:
                break
            }
        } else if sender.translation(in: view.superview).y > 50 {
            switch sender.state {
            case .began:
                initialCenter = view.center
            case .changed:
                answerImageView.image = UIImage(named: "correct")
                animate(imageAlpha: 1.0)
            case .ended:
                guessedSongs.append(song)
                getNewSong(from: songs)
                animate(imageAlpha: 0)
            case .cancelled:
                animate(imageAlpha: 0)
            default:
                break
            }
        } else {
            animate(imageAlpha: 0)
        }
    }
}

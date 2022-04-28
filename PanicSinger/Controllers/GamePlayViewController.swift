//
//  GamePlayViewController.swift
//  PanicSinger
//
//  Created by Xcho on 28.04.22.
//

import UIKit

class GamePlayViewController: UIViewController {

    // MARK: - Subviews

    @IBOutlet weak var songNameLabel: UILabel!

    // MARK: - Model

    var usedSongs: [String] = []
    var songs: [String] = []
    var song: String = ""
    var guessedSongs: [String] = []
    var initialCenter = CGPoint()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialCenter = view.center
        getSongsFor(category: CellModel.categoryName!)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))

        view.addGestureRecognizer(panGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.lockOrientation(.landscape, andRotateTo: .landscapeRight)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    // MARK: - Helpers

    private func getSongsFor(category: String) {
        guard let songURL = Bundle.main.url(forResource: "Songs", withExtension: "plist")
        else { return }

        if let categoriesDict = NSDictionary(contentsOf: songURL) as? Dictionary<String, [String]> {
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

    // MARK: - Gesturehandler

    @objc func handleSwipes(_ sender: UIPanGestureRecognizer) {
        if sender.translation(in: view.superview).x < -50 {
            switch sender.state {
            case .began:
                initialCenter = view.center
            case .changed:
                view.backgroundColor = .red
            case .ended:
                getNewSong(from: songs)
                view.backgroundColor = .white
            case .cancelled:
                view.backgroundColor = .white
            default:
                break
            }
        } else if sender.translation(in: view.superview).x > 50 {
            switch sender.state {
            case .began:
                initialCenter = view.center
            case .changed:
                view.backgroundColor = .green
            case .ended:
                getNewSong(from: songs)
                guessedSongs.append(song)
                view.backgroundColor = .white
            case .cancelled:
                view.backgroundColor = .white
            default:
                break
            }
        } else {
            view.backgroundColor = .white
        }
    }
}

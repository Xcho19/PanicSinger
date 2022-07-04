//
//  FontConfigurations.swift
//  PanicSinger
//
//  Created by Xcho on 27.06.22.
//

import Foundation
import UIKit

final class FontConfigurations {
    static var shared = FontConfigurations()

    func configureFont(
        label: UILabel,
        fontName: String = "Arial Rounded MT Bold",
        smallestFontSize: Double,
        frame: Double
    ) {
        switch frame {
        case 375, 390:
            label.font = UIFont(name: fontName, size: smallestFontSize)
        case 414:
            label.font = UIFont(name: fontName, size: smallestFontSize + 2)
        case 428:
            label.font = UIFont(name: fontName, size: smallestFontSize + 4)
        case 429...1366:
            label.font = UIFont(name: fontName, size: smallestFontSize + 8)
        default:
            break
        }
    }
}

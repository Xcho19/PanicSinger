//
//  ConfigurationsViewController+Extensions.swift
//  PanicSinger
//
//  Created by Xcho on 01.06.22.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.enumerated().forEach { insertArrangedSubview($0.1, at: $0.0) }
    }
}

extension UIColor {
    static let backgroundColor40 = UIColor(named: "BackgroundBlue40")
}

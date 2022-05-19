//
//  Category.swift
//  PanicSinger
//
//  Created by Xcho on 16.05.22.
//

import Foundation

struct Category: Codable, Equatable {
    var name: String
    var description: String?
    var bundle: [String]
    var isPurchased: Bool
    var price: Double
}

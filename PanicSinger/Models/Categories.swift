//
//  Categories.swift
//  PanicSinger
//
//  Created by Xcho on 27.04.22.
//

import Foundation

final class Categories: Codable {
    static var purchasedCategoryName: String = ""

    var ownedCategoryNames = [
        "InternationalPopHits", "InternationalRapHits", "InternationalRockHits"
    ]

    var storeCategories: [Category] = [
        Category(
            name: "Armenian",
            description: "This bundle contains Rock, Rap, Rabiz categories of Aremnian songs",
            bundle: ["ArmenianGoldenEdition", "ArmenianRabiz", "ArmenianRap"],
            isPurchased: false,
            price: 1.99
        ),
        Category(
            name: "Russian",
            description: "This bundle contains Rock, Rap, Pop categories of Russian songs",
            bundle: ["RussianRap", "RussianGoldenEdition", "RussianPop"],
            isPurchased: false,
            price: 1.99
        ),
        Category(
            name: "International",
            description: "This bundle contains Rock, Rap, Pop categories of International songs",
            bundle: ["InternationalPopHits", "InternationalRapHits", "InternationalRockHits"],
            isPurchased: false,
            price: 1.99
        )
    ]
}

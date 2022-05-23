//
//  Categories.swift
//  PanicSinger
//
//  Created by Xcho on 27.04.22.
//

import Foundation

final class Categories: Codable {
    static var ownedCategoryName: String = ""

    var ownedCategoryNames = [
        "Pop Hits", "Hip-Hop Hits", "Rock Hits"
    ]

    var allCategories: [CategoryDescription] = [
        CategoryDescription(
            name: "Pop Hits",
            description: "This category contains top songs from Pop genre."
        ),
        CategoryDescription(
            name: "Hip-Hop Hits",
            description: "This category contains top songs from Hip-Hop genre."
        ),
        CategoryDescription(
            name: "Rock Hits",
            description: "This category contains top songs from Rock genre."
        ),
        CategoryDescription(
            name: "Armenian Golden Edition",
            description: "This category contains most liked Armenian songs of all times."
        ),
        CategoryDescription(
            name: "Armenian Rabiz",
            description: "This category contains top songs from Armenian Rabiz genre."
        ),
        CategoryDescription(
            name: "Armenian Hip-Hop",
            description: "This category contains top songs from Armenian Hip-Hop genre."
        ),
        CategoryDescription(
            name: "Russian Golden Edition",
            description: "This category contains most liked Russian songs of all times."
        ),
        CategoryDescription(
            name: "Russian Pop",
            description: "This category contains top songs from Russian Pop genre."
        ),
        CategoryDescription(
            name: "Russian Hip-Hop",
            description: "This category contains top songs from Russian Hip-Hop genre."
        )
    ]

    var storeCategories: [Category] = [
        Category(
            name: "Armenian Bundle",
            description: "This bundle contains Armenian Rock, Hip-Hop, Rabiz genres.",
            bundle: ["Armenian Golden Edition", "Armenian Rabiz", "Armenian Hip-Hop"],
            price: 1.99
        ),
        Category(
            name: "Russian Bundle",
            description: "This bundle contains Russian Rock, Hip-Hop, Pop genres.",
            bundle: ["Russian Golden Edition", "Russian Pop", "Russian Hip-Hop"],
            price: 1.99
        ),
        Category(
            name: "Top Hits Bundle",
            description: "This bundle contains International Rock, Hip-Hop, Pop genres.",
            bundle: ["Pop Hits", "Hip-Hop Hits", "Rock Hits"],
            price: 1.99
        )
    ]
}

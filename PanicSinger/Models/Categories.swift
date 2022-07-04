//
//  Categories.swift
//  PanicSinger
//
//  Created by Xcho on 27.04.22.
//

import Foundation

final class Categories: Codable {
    static var ownedCategoryName: String = ""

    static var ownedCategoryNames = UserDefaults.standard.object(
        forKey: "OwnedCategories"
    ) as? [String] ?? [
        "Armenian Mix", "Armenian Pop", "Russian Mix", "Russian Pop",
        "World Mix", "World Pop Hits"
    ]

    static var allCategories: [Category] = [
        Category(
            name: "World Mix",
            description: "All genres mixed together",
            storeID: ""
        ),
        Category(
            name: "World Pop Hits",
            description: "All I wanna say is that they don't really care about us . . .",
            storeID: ""
        ),
        Category(
            name: "Hip-Hop Hits",
            description: "Out on bail fresh outta jail, California dreamin . . .",
            storeID: ""
        ),
        Category(
            name: "Rock Hits",
            description: "Show must go on . . .",
            storeID: ""
        ),
        Category(
            name: "World Nostalgia",
            description: "Fly me to the Moon . . .",
            storeID: ""
        ),
        Category(
            name: "Armenian Mix",
            description: "Ամեն ինչից՝ մի քիչ, մի քիչ",
            storeID: ""
        ),
        Category(
            name: "Armenian Nostalgia",
            description: "Հա՞յ ես դու, Հայ եմ ես . . .",
            storeID: ""
        ),
        Category(
            name: "Armenian Rabiz",
            description: "Ուր որ գնաս հետդ կգա՜մ . . .",
            storeID: ""
        ),
        Category(
            name: "Armenian Hip-Hop",
            description: "Ավելի լավա չիմանյիր ինձ . . .",
            storeID: ""
        ),
        Category(
            name: "Armenian Pop",
            description: "Ա՜խ, լուսին լուսին ուզում եմ \nքեզ գրկել . . .",
            storeID: ""
        ),
        Category(
            name: "Russian Mix",
            description: "Все жанры по немножку",
            storeID: ""
        ),
        Category(
            name: "Russian Nostalgia",
            description: "Группа крови на рукаве . . .",
            storeID: ""
        ),
        Category(
            name: "Russian Pop",
            description: "Ну что ты братишка притих . . .",
            storeID: ""
        ),
        Category(
            name: "Russian Hip-Hop",
            description: "Не звонишь, летишь в Париж \n Я не звоню, прыгаю с крыш . . .",
            storeID: ""
        ),
        Category(
            name: "Armenian Patriotic",
            description: "Գնացին տղերքը ու կորան հեռվում . . .",
            storeID: ""
        )
    ]

    static var allStoreCategories: [Category] = [
        Category(
            name: "World Nostalgia",
            description: "Nostalgic songs of the world",
            storeID: "com.Khachatur.PanicSinger.WorldNostalgia"
        ),
        Category(
            name: "Hip-Hop Hits",
            description: "Top Hip-Hop songs of the world",
            storeID: "com.Khachatur.PanicSinger.HipHopHits"
        ),
        Category(
            name: "Rock Hits",
            description: "Top Rock songs of the world",
            storeID: "com.Khachatur.PanicSinger.RockHits"
        ),
        Category(
            name: "Armenian Nostalgia",
            description: "Nostalgic songs in Armenian",
            storeID: "com.Khachatur.PanicSinger.ArmenianNostalgia"
        ),
        Category(
            name: "Armenian Rabiz",
            description: "Top Rabiz songs in Armenian",
            storeID: "com.Khachatur.PanicSinger.ArmenianRabiz"
        ),
        Category(
            name: "Armenian Hip-Hop",
            description: "Top Hip-Hop songs in Armenian",
            storeID: "com.Khachatur.PanicSinger.ArmenianHipHop"
        ),
        Category(
            name: "Russian Nostalgia",
            description: "Nostalgic songs in Russian",
            storeID: "com.Khachatur.PanicSinger.RussianNostalgia"
        ),
        Category(
            name: "Russian Hip-Hop",
            description: "Top Hip-Hop songs in Russian",
            storeID: "com.Khachatur.PanicSinger.RussianHipHop"
        ),
        Category(
            name: "Armenian Patriotic",
            description: "Armenian patriotic songs",
            storeID: "com.Khachatur.PanicSinger.ArmenianPatriotic"
        )
    ]
}

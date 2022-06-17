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
        "Armenian Mix", "Armenian Pop Hits", "Russian Mix", "Russian Hits", "World Mix", "World Pop Hits"
    ]

    static var allCategories: [CategoryDescription] = [
        CategoryDescription(
            name: "World Mix",
            description: "All genres mixed together",
            storeID: ""
        ),
        CategoryDescription(
            name: "World Pop Hits",
            description: "All I wanna say is that they don't really care about us . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Hip-Hop Hits",
            description: "Out on bail fresh outta jail, California dreamin . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Rock Hits",
            description: "Show must go on . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "World Nostalgia",
            description: "Fly me to the Moon . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Armenian Mix",
            description: "Ամեն ինչից՝ մի քիչ, մի քիչ",
            storeID: ""
        ),
        CategoryDescription(
            name: "Armenian Nostalgia",
            description: "Հա՞յ ես դու, Հայ եմ ես . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Armenian Rabiz",
            description: "Ուր որ գնաս հետդ կգա՜մ . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Armenian Hip-Hop",
            description: "Ավելի լավա չիմանյիր ինձ . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Armenian Pop Hits",
            description: "Ա՜խ, լուսին լուսին ուզում եմ \nքեզ գրկել . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Russian Mix",
            description: "Все жанры по немножку",
            storeID: ""
        ),
        CategoryDescription(
            name: "Russian Hits",
            description: "Наверно ты меня не помнишь . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Russian Nostalgia",
            description: "Группа крови на рукаве . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Russian Pop",
            description: "Ну что ты братишка притих . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Russian Hip-Hop",
            description: "Не звонишь, летишь в Париж \n Я не звоню, прыгаю с крыш . . .",
            storeID: ""
        ),
        CategoryDescription(
            name: "Armenian Patriotic",
            description: "Հերոս տղերքը մեր, ելան բարցունքն ի վեր . . .",
            storeID: ""
        )
    ]

    static var allStoreCategories: [CategoryDescription] = [
        CategoryDescription(
            name: "World Nostalgia",
            description: "Contains Nostalgic songs of the world.",
            storeID: "com.Khachatur.PanicSinger.WorldNostalgia"
        ),
        CategoryDescription(
            name: "Hip-Hop Hits",
            description: "Contains top songs from Hip-Hop genre.",
            storeID: "com.Khachatur.PanicSinger.HipHopHits"
        ),
        CategoryDescription(
            name: "Rock Hits",
            description: "Contains top songs from Rock genre.",
            storeID: "com.Khachatur.PanicSinger.RockHits"
        ),
        CategoryDescription(
            name: "Armenian Nostalgia",
            description: "Contains most liked Armenian songs of all times.",
            storeID: "com.Khachatur.PanicSinger.ArmenianNostalgia"
        ),
        CategoryDescription(
            name: "Armenian Rabiz",
            description: "Contains top songs from Armenian Rabiz genre.",
            storeID: "com.Khachatur.PanicSinger.ArmenianRabiz"
        ),
        CategoryDescription(
            name: "Armenian Hip-Hop",
            description: "Contains top songs from Armenian Hip-Hop genre.",
            storeID: "com.Khachatur.PanicSinger.ArmenianHipHop"
        ),
        CategoryDescription(
            name: "Russian Nostalgia",
            description: "Contains most liked Russian songs of all times.",
            storeID: "com.Khachatur.PanicSinger.RussianNostalgia"
        ),
        CategoryDescription(
            name: "Russian Pop",
            description: "Contains top songs from Russian Pop genre.",
            storeID: "com.Khachatur.PanicSinger.RussianPop"
        ),
        CategoryDescription(
            name: "Russian Hip-Hop",
            description: "Contains top songs from Russian Hip-Hop genre.",
            storeID: "com.Khachatur.PanicSinger.RussianHipHop"
        ),
        CategoryDescription(
            name: "Armenian Patriotic",
            description: "Contains Armenian patriotic songs.",
            storeID: "com.Khachatur.PanicSinger.ArmenianPatriotic"
        )
    ]
}

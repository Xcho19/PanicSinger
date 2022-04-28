//
//  Songs.swift
//  PanicSinger
//
//  Created by Xcho on 28.04.22.
//

import Foundation

struct Songs: Decodable {
    var armRap: [String] = []
    var armGoldenEdition: [String] = []
    var armRabiz: [String] = []

    var songs: [String: [String]] = [CellModel.categoryName!: []]
    
    init(withPlistAt url: URL) {
        do {
            let plistData = try Data(contentsOf: url)
            self = try PropertyListDecoder().decode(Songs.self, from: plistData)
        } catch {
            print(error.localizedDescription)
        }
    }
}

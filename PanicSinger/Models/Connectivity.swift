//
//  Connectivity.swift
//  PanicSinger
//
//  Created by Xcho on 03.06.22.
//

import Alamofire
import Foundation

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet: Bool {
        self.sharedInstance.isReachable
    }
}

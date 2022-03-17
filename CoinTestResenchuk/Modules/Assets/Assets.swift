//
//  Assets.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/16/22.
//

import Foundation
import Alamofire

struct Assets {
    struct Coin: Codable {
        var id: String?
        var rank: String?
        var symbol: String?
        var name: String?
        var supply: String?
        var maxSupply: String?
        var marketCapUsd: String?
        var volumeUsd24Hr: String?
        var priceUsd: String?
        var changePercent24Hr: String?
        var vwap24Hr: String?
    }
    
    struct CoinResponse: Codable {
        var data: [Coin]?
    }
}

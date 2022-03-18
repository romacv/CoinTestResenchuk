//
//  AssetDetails.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/17/22.
//

struct AssetDetails {
    struct History: Codable {
        var priceUsd: String
        var time: Int
    }
    
    struct HistoryResponse: Codable {
        var data: [History]?
    }
}

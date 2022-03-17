//
//  Assets.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/16/22.
//

import Foundation
import Alamofire

// Assets Model
struct Assets {
    typealias didFetchSuccess = (Assets)->()
    typealias didFailWithError = (Error) -> ()
    
    // JSON Structure
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
    
    // Model structure
    struct FormattedItem {
        var id: String!
        var symbol: String!
        var name: String!
        var priceUsdFormatted: String!
        var changePercent24HrFormatted: String!
        var isChangePositive: Bool
    }
    var formattedItems = [FormattedItem]()
    
    func didFetch(search: String,
                  limit: Int,
                  offset: Int,
                  withSuccess: @escaping didFetchSuccess,
                  withError: @escaping didFailWithError) {
        let requestUrl = "https://api.coincap.io/v2/assets?search=\(search)&offset=\(offset)&limit=\(limit)"
        var formattedItems = [FormattedItem]()
        AF.request(requestUrl)
            .validate()
            .responseDecodable(of: CoinResponse.self) { (response) in
                guard response.error == nil else {
                    withError(response.error!)
                    return
                }
                guard let coins = response.value?.data else { return }
                // Parse response
                for coin in coins {
                    let isChangePositive = Double(coin.changePercent24Hr ?? "0.0") ?? 0 > 0
                    formattedItems.append(
                        FormattedItem(id: coin.id,
                                      symbol: coin.symbol,
                                      name: coin.name,
                                      priceUsdFormatted: coin.priceUsd?.toUSCurrencyFormat() ?? "Unknown",
                                      changePercent24HrFormatted: coin.changePercent24Hr?.toUSCurrencyFormat() ?? "Unknown",
                                      isChangePositive: isChangePositive)
                    )
                }
                withSuccess(
                    Assets(formattedItems: formattedItems)
                )
            }
    }
}

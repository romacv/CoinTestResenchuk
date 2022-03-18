//
//  LocalService.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/18/22.
//

import Foundation

private let userDefaults = UserDefaults.standard
private let kFavCoins = "favCoins"

class LocalService {
    func addCoinToFav(coinId: String) {
        var favCoins = getFavCoins()
        favCoins.append(coinId)
        userDefaults.setValue(favCoins, forKey: kFavCoins)
        userDefaults.synchronize()
    }
    
    func removeCoinFromFav(coinId: String) {
        let favCoins = getFavCoins().filter({$0 != coinId})
        userDefaults.setValue(favCoins, forKey: kFavCoins)
        userDefaults.synchronize()
    }

    func getFavCoins() -> [String] {
        userDefaults.value(forKey: kFavCoins) as? [String] ?? []
    }
    
    func checkisCoinFav(coinId: String) -> Bool {
        getFavCoins().contains(coinId)
    }
}

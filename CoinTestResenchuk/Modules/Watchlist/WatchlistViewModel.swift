//
//  WatchlistViewModel.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/16/22.
//

import Foundation

protocol WatchlistViewModelProtocol {
    func fetchData()
    func deleteObject(index: Int)
}

class WatchlistViewModel {
    var view: WatchlistViewProtocol!
    struct FormattedItem {
        var id: String!
        var symbol: String!
        var name: String!
        var priceUsdFormatted: String!
        var changePercent24HrFormatted: String!
        var isChangePositive: Bool
        var marketCap: String!
        var supply: String!
        var volume24: String!
    }
    var formattedItems = [FormattedItem]()
    let apiService = APIService()
    let localService = LocalService()
    
    func fetchData() {
        let ids = localService.getFavCoins()
        guard ids.count > 0 else {
            formattedItems.removeAll()
            view.willReloadData()
            return
        }
        apiService.getAssetsByIds(type: Watchlist.CoinResponse.self,
                             ids: ids) { [weak self] success in
            guard let successData = success.data else {
                self?.view.willPresent(error: CustomError(error: nil,
                                                          errorMessage: "error_parsing".localized()))
                return
            }
            self?.formattedItems.removeAll()
            for coin in successData {
                let isChangePositive = Double(coin.changePercent24Hr ?? "0.0") ?? 0 > 0
                self?.formattedItems.append(
                    FormattedItem(id: coin.id,
                                  symbol: coin.symbol,
                                  name: coin.name,
                                  priceUsdFormatted: coin.priceUsd?.toUSCurrencyFormat() ?? "unknown".localized(),
                                  changePercent24HrFormatted: coin.changePercent24Hr?.toPercentFormat() ?? "unknown".localized(),
                                  isChangePositive: isChangePositive,
                                  marketCap: coin.marketCapUsd?.toUSCurrencyFormat() ?? "unknown".localized(),
                                  supply: coin.supply?.toUSCurrencyFormat() ?? "unknown".localized(),
                                  volume24: coin.volumeUsd24Hr?.toUSCurrencyFormat() ?? "unknown".localized())
                )
            }
            self?.view.willReloadData()
        } withError: { [weak self] err in
            self?.view.willPresent(error: err)
        }
        
    }
    
    func deleteObject(index: Int) {
        localService.removeCoinFromFav(coinId: formattedItems[index].id)
        formattedItems.remove(at: index)
        // After cell animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.view.willReloadData()
        }
    }
}

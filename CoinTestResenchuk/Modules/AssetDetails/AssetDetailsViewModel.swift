//
//  AssetDetailsViewModel.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/17/22.
//

import Foundation

protocol AssetDetailsViewModelProtocol {
    func fetchData()
    func favoritesAction(isAdd: Bool)
}

class AssetDetailsViewModel {
    var view: AssetDetailsViewProtocol!
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
    var currentCoin: FormattedItem!
    var isFavorite: Bool = false
    let localService = LocalService()
    let apiService = APIService()
    let interval = "m5"
    struct FormattedChartItem {
        var id: UUID!
        var time: Int!
        var value: Double
        var moneyValue: String
    }
    var formattedChartItems = [FormattedChartItem]()
    var chartPoints = [Double]()
    
    func fetchData() {
        isFavorite = localService.checkisCoinFav(coinId: currentCoin.id)
        view.willReloadData()
        formattedChartItems.removeAll()
        apiService.getHistoryPrice(type: AssetDetails.HistoryResponse.self,
                                   id: currentCoin.id,
                                   interval: interval) { [weak self] success in
            guard let successData = success.data else {
                self?.view.willPresent(error: CustomError(error: nil,
                                                          errorMessage: "error_parsing".localized()))
                return
            }
            for item in successData {
                self?.formattedChartItems.append(
                FormattedChartItem(id: UUID(),
                                   time: item.time,
                                   value: Double(item.priceUsd) ?? 0.0,
                                   moneyValue: item.priceUsd.toUSCurrencyFormat()))
                self?.chartPoints.append(Double(item.priceUsd) ?? 0.0)
            }
            self?.view.willReloadData()
        } withError: { [weak self] err in
            self?.view.willPresent(error: err)
        }
    }
    
    func favoritesAction(isAdd: Bool) {
        if isAdd {
            localService.addCoinToFav(coinId: currentCoin.id)
        }
        else {
            localService.removeCoinFromFav(coinId: currentCoin.id)
        }
        isFavorite.toggle()
        self.view.willReloadData()
    }
}

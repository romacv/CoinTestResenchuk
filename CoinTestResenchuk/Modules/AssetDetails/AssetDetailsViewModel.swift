//
//  AssetDetailsViewModel.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/17/22.
//

import Foundation

protocol AssetDetailsViewModelProtocol {
    func fetchData()
    func didReceiveUISelect(object: AssetDetails)
}

class AssetDetailsViewModel {
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
    var view: AssetDetailsViewProtocol!
    
    func fetchData() {
//        object.didFetch(withSuccess: { (success) in
//            self.view.viewWillPresent(data: success)
//        }) { (err) in
//            debugPrint("Error happened", err as Any)
//        }
    }
    
    func didReceiveUISelect(object: AssetDetails) {
        debugPrint("Did receive UI object", object)
    }
}

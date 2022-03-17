//
//  AssetsViewModel.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/16/22.
//

import Foundation

protocol AssetsViewModelProtocol {
    func fetchData()
    func didReceiveUISelect(object: Assets)
}

class AssetsViewModel {
    var view: AssetsViewProtocol!
    var object = Assets()
    
    func fetchData(search: String = "",
                   limit: Int,
                   offset: Int) {
        object.didFetch(search: search,
                        limit: limit,
                        offset: offset,
                        withSuccess: { [weak self] (success) in
            guard let weakSelf = self else { return }
            if offset == 0 {
                weakSelf.object = success
            }
            else {
                weakSelf.object.formattedItems.append(contentsOf: success.formattedItems)
            }
            weakSelf.view.viewWillPresent(data: weakSelf.object)
        }) { (err) in
            self.view.errorWillPresent(error: err)
        }
    }
    
    func didReceiveUISelect(object: Assets) {
        debugPrint("Did receive UI object", object)
    }
}

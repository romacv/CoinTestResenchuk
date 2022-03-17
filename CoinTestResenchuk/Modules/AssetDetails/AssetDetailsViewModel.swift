//
//  AssetDetailsViewModel.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/17/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//  Generated using MVVM Module Generator by Mohamad Kaakati
//  https://github.com/Kaakati/MVVM-Template-Generator
//

import Foundation

protocol AssetDetailsViewModelProtocol {
    func fetchData()
    func didReceiveUISelect(object: AssetDetails)
}

class AssetDetailsViewModel {
    var view : AssetDetailsViewProtocol!
    var object = AssetDetails()
    
    func fetchData() {
        object.didFetch(withSuccess: { (success) in
            self.view.viewWillPresent(data: success)
        }) { (err) in
            debugPrint("Error happened", err as Any)
        }
    }
    
    func didReceiveUISelect(object: AssetDetails) {
        debugPrint("Did receive UI object", object)
    }
}
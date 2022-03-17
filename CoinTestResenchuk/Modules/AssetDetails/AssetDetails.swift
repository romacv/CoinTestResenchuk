//
//  AssetDetails.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/17/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//  Generated using MVVM Module Generator by Mohamad Kaakati
//  https://github.com/Kaakati/MVVM-Template-Generator
//

/// AssetDetails Model
struct  AssetDetails {
    typealias didFetchSuccess = (AssetDetails)->()
    typealias didFailWithError = (Error?) -> ()
    
    // Your Model Structure
    var id : Int?
    var name : Int?
    
    func didFetch(withSuccess: @escaping didFetchSuccess, withError: @escaping didFailWithError) {
        withSuccess(AssetDetails())
        withError(nil)
    }
}

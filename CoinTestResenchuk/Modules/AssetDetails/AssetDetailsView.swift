//
//  AssetDetailsView.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/17/22.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//  Generated using MVVM Module Generator by Mohamad Kaakati
//  https://github.com/Kaakati/MVVM-Template-Generator
//

import UIKit

protocol AssetDetailsViewProtocol {
    func viewWillPresent(data: AssetDetails)
}

class AssetDetailsView: UIViewController, AssetDetailsViewProtocol {
    
    
    var object : AssetDetails?
    
    var viewModel : AssetDetailsViewModel! {
        willSet {
            newValue.view = self
        }
    }

    @IBOutlet weak var favoritesButton: UIButton!
    @IBAction func tapFavorites(_ sender: Any) {
        favoritesButton.isSelected.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = AssetDetailsViewModel()
        viewModel.fetchData()
    }
    
    func viewWillPresent(data: AssetDetails) {
        object = data
    }
    
    func uiDidSelect(object: AssetDetails) {
        viewModel.didReceiveUISelect(object: object)
    }
}

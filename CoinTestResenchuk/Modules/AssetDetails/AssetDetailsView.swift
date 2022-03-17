//
//  AssetDetailsView.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/17/22.
//

import UIKit

protocol AssetDetailsViewProtocol {
    func viewWillPresent(data: AssetDetails)
}

class AssetDetailsView: UIViewController, AssetDetailsViewProtocol {
    // MARK: - Properties
    var viewModel : AssetDetailsViewModel! {
        willSet {
            newValue.view = self
        }
    }
    static let positiveColor = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
    static let negativeColor =  UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 1)

    // MARK: - IB Outlets
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var coinSymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changesLabel: UILabel!
    
    // MARK: - IB Actions
    @IBAction func tapFavorites(_ sender: Any) {
        favoritesButton.isSelected.toggle()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUIData()
    }
    
    // MARK: - AssetDetailsViewProtocol
    func viewWillPresent(data: AssetDetails) {
        
    }
    
    // MARK: - Actions
    private func setupUIData() {
        coinNameLabel.text = viewModel.currentCoin.name
        coinSymbolLabel.text = viewModel.currentCoin.symbol
        priceLabel.text = viewModel.currentCoin.priceUsdFormatted
        changesLabel.text = viewModel.currentCoin.changePercent24HrFormatted
        changesLabel.textColor = viewModel.currentCoin.isChangePositive ? Self.positiveColor : Self.negativeColor
    }
}

// MARK: - UITableView
extension AssetDetailsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        var title = ""
        var value = ""
        switch indexPath.row {
        case 0:
            title = "market_cap".localized()
            value = viewModel.currentCoin.marketCap
        case 1:
            title = "supply".localized()
            value = viewModel.currentCoin.supply
        case 2:
            title = "volume_24".localized()
            value = viewModel.currentCoin.volume24
        default:
            break
        }
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = value
        return cell
    }
    
    
}

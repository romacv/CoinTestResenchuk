//
//  WatchlistView.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/16/22.
//

import UIKit
import Alamofire

protocol WatchlistViewProtocol {
    func willReloadData()
    func willPresent(error: CustomError)
}

class WatchlistView: UIViewController, WatchlistViewProtocol {
    // MARK: - Properties
    var viewModel: WatchlistViewModel! {
        willSet {
            newValue.view = self
        }
    }
    static let segueShowDetailsIdentifier = "SegueShowDetails"
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyTitleLabel: UILabel!
    @IBOutlet weak var emptySubtitleLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = WatchlistViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchData()
    }
    
    // MARK: - Actions
    private func setupUI() {
        tableView.delegate = self
        self.title = "watchlist".localized()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinTableViewCell")
        emptyTitleLabel.text = "empty_title".localized();
        emptySubtitleLabel.text = "empty_subtitle".localized();
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        viewModel.fetchData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - WatchlistViewProtocol
    func willReloadData() {
        emptyView.isHidden = !viewModel.formattedItems.isEmpty
        tableView.isHidden = !emptyView.isHidden
        tableView.reloadData()
    }
    
    func willPresent(error: CustomError) {
        let alert = UIAlertController(title: "error".localized(),
                                      message: error.errorMessage,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        present(alert,
                animated: true,
                completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Self.segueShowDetailsIdentifier,
           let destinationVC = segue.destination as? AssetDetailsView {
            let detailsViewModel = AssetDetailsViewModel()
            let selectedItem = viewModel.formattedItems[(sender as! NSIndexPath).row]
            // TODO: For complex apps better to implement coordinator layer
            detailsViewModel.currentCoin =
            AssetDetailsViewModel.FormattedItem(id: selectedItem.id,
                                                symbol: selectedItem.symbol,
                                                name: selectedItem.name,
                                                priceUsdFormatted: selectedItem.priceUsdFormatted,
                                                changePercent24HrFormatted: selectedItem.changePercent24HrFormatted,
                                                isChangePositive: selectedItem.isChangePositive,
                                                marketCap: selectedItem.marketCap,
                                                supply: selectedItem.supply,
                                                volume24: selectedItem.volume24)
            destinationVC.viewModel = detailsViewModel
        }
    }
}

// MARK: - TableView
extension WatchlistView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.formattedItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell") as! CoinTableViewCell
        let item = viewModel.formattedItems[indexPath.row]
        cell.setupCell(coinText: item.symbol,
                       coinDescrText: item.name,
                       priceText: item.priceUsdFormatted,
                       changesText: item.changePercent24HrFormatted,
                       isChangePositive: item.isChangePositive)
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Self.segueShowDetailsIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteObject(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

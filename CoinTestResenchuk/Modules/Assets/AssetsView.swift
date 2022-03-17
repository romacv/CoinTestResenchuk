//
//  AssetsView.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/16/22.
//

import UIKit
import Alamofire

protocol AssetsViewProtocol {
    func willReloadData()
    func willPresent(error: CustomError)
}

class AssetsView: UIViewController, AssetsViewProtocol {
    // MARK: - Properties
    let searchController = UISearchController()
    var viewModel: AssetsViewModel! {
        willSet {
            newValue.view = self
        }
    }
    var currentOffset = 0
    let limit = 10
    var loadingData = false
    static let segueShowDetailsIdentifier = "SegueShowDetails"
    
    // MARK: - IB Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = AssetsViewModel()
        viewModel.fetchData(limit: limit,
                            offset: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Actions
    private func setupUI() {
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        tableView.delegate = self
        self.title = "assets".localized()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinTableViewCell")
        self.tabBarController?.tabBar.layer.borderWidth = 0.5
        self.tabBarController?.tabBar.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        searchController.searchBar.text = ""
        currentOffset = 0
        viewModel.fetchData(limit: limit,
                            offset: currentOffset)
        refreshControl.endRefreshing()
    }
    
    // MARK: - AssetsViewProtocol
    func willReloadData() {
        tableView.reloadData()
        loadingData = false
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


// MARK: - Search
extension AssetsView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else {
            return
        }
        currentOffset = 0
        viewModel.fetchData(search: searchBarText,
                            limit: limit,
                            offset: currentOffset)
        print(searchBarText)
    }
}

// MARK: - TableView
extension AssetsView: UITableViewDelegate, UITableViewDataSource {
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
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if !loadingData && indexPath.row == viewModel.formattedItems.count - 1 {
            currentOffset += limit
            viewModel.fetchData(search: searchController.searchBar.text ?? "",
                                limit: limit,
                                offset: currentOffset)
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Self.segueShowDetailsIdentifier, sender: indexPath)
    }
}

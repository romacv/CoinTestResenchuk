//
//  AssetsView.swift
//  CoinTestResenchuk
//
//  Created Roman R. on 3/16/22.
//

import UIKit
import Alamofire

protocol AssetsViewProtocol {
    func viewWillPresent(data: Assets)
    func errorWillPresent(error: Error)
    func uiDidSelect(object: Assets)
}

class AssetsView: UIViewController, AssetsViewProtocol {
    // MARK: - Variables
    var object: Assets?
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
        navigationItem.title = "Assets"
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinTableViewCell")
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        searchController.searchBar.text = ""
        currentOffset = 0
        viewModel.fetchData(limit: limit,
                            offset: currentOffset)
        refreshControl.endRefreshing()
    }
    
    // MARK: - AssetsViewProtocol
    func viewWillPresent(data: Assets) {
        object = data
        tableView.reloadData()
        loadingData = false
    }
    
    func errorWillPresent(error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        present(alert,
                animated: true,
                completion: nil)
    }
    
    func uiDidSelect(object: Assets) {
        self.performSegue(withIdentifier: Self.segueShowDetailsIdentifier, sender: nil)
        viewModel.didReceiveUISelect(object: object)
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
        guard let object = object else {
            return 0
        }
        return object.formattedItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let object = object else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoinTableViewCell") as! CoinTableViewCell
        let item = object.formattedItems[indexPath.row]
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
        guard let object = object else {
            return
        }
        if !loadingData && indexPath.row == object.formattedItems.count - 1 {
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
        uiDidSelect(object: self.object!)
    }
}

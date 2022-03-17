//
//  SettingsTableViewController.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/17/22.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties
    let segueShowSetIcon = "SegueShowSetIcon"
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "settings".localized()
    }

    // MARK: - UITableView
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "icon".localized()
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: segueShowSetIcon, sender: nil)
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }

}

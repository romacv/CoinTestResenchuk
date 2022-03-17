//
//  SetIconTableViewController.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/17/22.
//

import UIKit

class SetIconTableViewController: UITableViewController {

    // MARK: - Properties
    struct AltIcon {
        var name: String
        var imageName: String
    }
    var altIcons = [AltIcon(name: "white".localized(), imageName: "AppIcon1"),
                    AltIcon(name: "black".localized(), imageName: "AppIcon2"),
                    AltIcon(name: "yellow".localized(), imageName: "AppIcon3")]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - TableView
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = altIcons[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return altIcons.count
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    override func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect.zero)
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIApplication.shared.setAlternateIconName(altIcons[indexPath.row].imageName) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("App Icon changed!")
            }
        }
    }
    
}

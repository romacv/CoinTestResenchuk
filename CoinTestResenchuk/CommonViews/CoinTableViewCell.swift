//
//  CoinTableViewCell.swift
//  CoinTestResenchuk
//
//  Created by Roman R. on 3/17/22.
//

import UIKit
import SDWebImage

class CoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinDescrLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changesLabel: UILabel!
    
    static let positiveColor = UIColor(red: 0.204, green: 0.78, blue: 0.349, alpha: 1)
    static let negativeColor =  UIColor(red: 1, green: 0.231, blue: 0.188, alpha: 1)
    
    func setupCell(coinText: String,
                   coinDescrText: String,
                   priceText: String,
                   changesText: String,
                   isChangePositive: Bool) {
        coinLabel.text = coinText
        coinDescrLabel.text = coinDescrText
        priceLabel.text = priceText
        changesLabel.text = changesText
        let imageURL = URL(string: "https://cryptoicon-api.vercel.app/api/icon/\(coinText.lowercased())")
        iconImageView.sd_setImage(with: imageURL)
        changesLabel.textColor = isChangePositive ? Self.positiveColor : Self.negativeColor
    }
    
}

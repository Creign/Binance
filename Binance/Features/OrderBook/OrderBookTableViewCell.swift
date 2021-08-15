//
//  OrderBookTableViewCell.swift
//  Binance
//
//  Created by Excell on 15/08/2021.
//

import UIKit

class OrderBookTableViewCell: UITableViewCell {

    @IBOutlet weak var bidDescLabel: UILabel!
    @IBOutlet weak var bidValueLabel: UILabel!
    @IBOutlet weak var askDescLabel: UILabel!
    @IBOutlet weak var askValueLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bidDescLabel.textColor = .white
        bidValueLabel.textColor = .green
        askDescLabel.textColor = .white
        askValueLabel.textColor = .red
    }
    
    func bind(bid: [Double], ask: [Double]) {
        bidDescLabel.text = String(bid[0])
        bidValueLabel.text = String(bid[1])
        askDescLabel.text = String(ask[0])
        askValueLabel.text = String(ask[1])
    }
    
}

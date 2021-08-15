//
//  MarketTradeTableViewCell.swift
//  Binance
//
//  Created by Excell on 15/08/2021.
//

import UIKit

class MarketTradeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeLabel.textColor = .gray
        priceLabel.textColor = .white
        amountLabel.textColor = .gray
    }
    
    func bind(model: MarketTradeModel) {
        let price = Double(model.p ?? "0.0")
        
        timeLabel.text = getTime(time: model.T ?? 0)//"\(model.T ?? 0)"
        priceLabel.text = String(format: "%.2f", price!)
        amountLabel.text = model.q
    }
    
    func getTime(time: Int) -> String {
        let calendar = Calendar.current
        let epocTime = TimeInterval(time)
        let myDate = Date(timeIntervalSince1970: epocTime)
        
        let hours = calendar.component(.hour, from: myDate)
        let minutes = calendar.component(.minute, from: myDate)
        let seconds = calendar.component(.second, from: myDate)
        
        return "\(hours):\(minutes):\(seconds)"
    }
}

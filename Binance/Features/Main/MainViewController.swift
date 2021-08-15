//
//  MainViewController.swift
//  Binance
//
//  Created by Excell on 12/08/2021.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var orderBookButton: UIButton!
    @IBOutlet weak var orderBookHighlightView: UIView!
    @IBOutlet weak var marketTradesButton: UIButton!
    @IBOutlet weak var marketTradesHighlightView: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var infoHighlightView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    var orderBook: OrderBookViewController!
    var marketTrades: MarketTradesViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        initCommon()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if orderBook == nil && marketTrades == nil {
            didTapOrderBook()
        }
    }
    
}

// MARK: - Private Functions
private extension MainViewController {
    
    func initCommon() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        orderBookButton.addTarget(self,
                                  action: #selector(didTapOrderBook),
                                  for: .touchUpInside)
        marketTradesButton.addTarget(self,
                                     action: #selector(didTapMarketTrades),
                                     for: .touchUpInside)
//        infoButton.addTarget(self,
//                             action: #selector(<#T##@objc method#>),
//                             for: .touchUpInside)
    }
    
    func deselectOrderBookButton() {
        orderBookButton.setTitleColor(.gray, for: .normal)
        orderBookHighlightView.isHidden = true
        guard let orderBook = orderBook else { return }
        orderBook.view.removeFromSuperview()
        orderBook.removeFromParent()
    }
    
    func deselectMarketTradesButton() {
        marketTradesButton.setTitleColor(.gray, for: .normal)
        marketTradesHighlightView.isHidden = true
        guard let marketTrades = marketTrades else { return }
        marketTrades.view.removeFromSuperview()
        marketTrades.removeFromParent()
    }
    
    @objc func didTapOrderBook() {
        if orderBook != nil, let _ = orderBook.parent { return }
        orderBookButton.setTitleColor(.white, for: .normal)
        orderBookHighlightView.isHidden = false
        
        deselectMarketTradesButton()
        
        if orderBook == nil {
            orderBook = OrderBookViewController()
//            orderBook.selectedCard = self.selectedCard
//            orderBook.navigationType = navigationType
//            orderBook.delegate = self
        }
        
        guard !containerView.subviews.contains(orderBook.view) else { return }
        orderBook.view.frame = containerView.bounds
        self.addChild(orderBook)
        self.containerView.addSubview(orderBook.view)
        self.orderBook.didMove(toParent: self)
        self.containerView.bringSubviewToFront(orderBook.view)
    }
    
    @objc func didTapMarketTrades() {marketTradesHighlightView.isHidden = false
        if marketTrades != nil, let _ = marketTrades.parent { return }
        marketTradesButton.setTitleColor(.white, for: .normal)
        

        deselectOrderBookButton()
        
        if marketTrades == nil {
            marketTrades = MarketTradesViewController()
//            orderBook.selectedCard = self.selectedCard
//            orderBook.navigationType = navigationType
//            orderBook.delegate = self
        }
        
        guard !containerView.subviews.contains(marketTrades.view) else { return }
        marketTrades.view.frame = containerView.bounds
        self.addChild(marketTrades)
        self.containerView.addSubview(marketTrades.view)
        self.marketTrades.didMove(toParent: self)
        self.containerView.bringSubviewToFront(marketTrades.view)
    }
}



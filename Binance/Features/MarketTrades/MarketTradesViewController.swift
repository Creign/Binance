//
//  MarketTradesViewController.swift
//  Binance
//
//  Created by Excell on 12/08/2021.
//

import UIKit
import Starscream

class MarketTradesViewController: UIViewController {

    @IBOutlet weak var marketTradeTableView: UITableView!
    
    // Websocket
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()
    
    // Controller Variables
    var arrModel: [MarketTradeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupWebsocket()
        
        socket.connect()
    }
}

extension MarketTradesViewController {
    func setupTable() {
        marketTradeTableView.dataSource = self
        marketTradeTableView.delegate = self
        marketTradeTableView.register(UINib(nibName: MarketTradeTableViewCell.identifier,
                                          bundle: nil),
                                    forCellReuseIdentifier: MarketTradeTableViewCell.identifier)
    }
    
    func setupWebsocket() {
        let request = URLRequest(url: URL(string: "wss://stream.binance.com:9443/ws/btcusdt@aggTrade")!)
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func processModel(model: MarketTradeModel) {
        arrModel.insert(model, at: 0)
        marketTradeTableView.reloadData()
    }
}

extension MarketTradesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (arrModel.count > 20) ? 20 : arrModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MarketTradeTableViewCell.identifier,
                                                    for: indexPath) as? MarketTradeTableViewCell {
            
            cell.bind(model: arrModel[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}

extension MarketTradesViewController: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")

        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
            
            socket.connect()
        case .text(let str):
            guard let data = str.data(using: .utf8),
                  let jsonData = try? JSONSerialization.jsonObject(with: data),
                  let jsonDict = jsonData as? [String : Any] else { return }

            let e = jsonDict["e"] as! String
            let E = jsonDict["E"] as! Int
            let s = jsonDict["s"] as! String
            let a = jsonDict["a"] as! Int
            let p = jsonDict["p"] as! String
            let q = jsonDict["q"] as! String
            let f = jsonDict["f"] as! Int
            let l = jsonDict["l"] as! Int
            let T = jsonDict["T"] as! Int
            let m = jsonDict["m"] as! Bool
            let M = jsonDict["M"] as! Bool
            
            let model = MarketTradeModel(e: e, E: E, s: s, a: a, p: p, q: q, f: f, l: l, T: T, m: m, M: M)
            processModel(model: model)
            
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
    }
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
}

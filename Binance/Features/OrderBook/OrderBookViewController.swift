//
//  OrderBookViewController.swift
//  Binance
//
//  Created by Excell on 12/08/2021.
//

import UIKit
import Starscream

class OrderBookViewController: UIViewController {
    
    @IBOutlet weak var orderBookTableView: UITableView!
    
    // Websocket
    var socket: WebSocket!
    var isConnected = false
    let server = WebSocketServer()

    // Controller Variables
    var model: OrderBookModel?
    var bid: [[Double]]?
    var ask: [[Double]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        setupWebsocket()
        
        socket.connect()
    }
}

extension OrderBookViewController {
    func setupTable() {
        orderBookTableView.dataSource = self
        orderBookTableView.delegate = self
        orderBookTableView.register(UINib(nibName: OrderBookTableViewCell.identifier,
                                          bundle: nil),
                                    forCellReuseIdentifier: OrderBookTableViewCell.identifier)
    }
    
    func setupWebsocket() {
        let request = URLRequest(url: URL(string: "wss://stream.binance.com:9443/ws/btcusdt@depth@1000ms")!)
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func processModel(model: OrderBookModel) {
        bid = model.b!.filter({ $0[0] != 0 && $0[1] != 0 })
        ask = model.a!.filter({ $0[0] != 0 && $0[1] != 0 })
        
        if !(bid?.isEmpty ?? false) && !(ask?.isEmpty ?? false) {
            orderBookTableView.reloadData()
        }
    }
}

extension OrderBookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let b = bid?.count else { return 0 }
        guard let a = ask?.count else { return 0 }
        
        return (b > a) ? a : b
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OrderBookTableViewCell.identifier,
                                                    for: indexPath) as? OrderBookTableViewCell {
            
            cell.bind(bid: bid![indexPath.row], ask: ask![indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}

extension OrderBookViewController: WebSocketDelegate {
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
            let U = jsonDict["U"] as! Int
            let u = jsonDict["u"] as! Int
            let b = jsonDict["b"] as! [[String]]
            let a = jsonDict["a"] as! [[String]]

            let bid = convertBidAsk(str: str, arr: b)
            let ask = convertBidAsk(str: str, arr: a)

            model = OrderBookModel(e: e, E: E, s: s, U: U, u: u, b: bid, a: ask)
            
            guard let model = model else { return }
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
    
    func convertBidAsk(str : String?, arr: [[String]]) -> [[Double]]{
        var array : [[Double]] = []
        for i in 0..<arr.count{
            let price = Double(arr[i][0])?.rounded(toPlaces: 6) ?? 0
            let diff = Double(arr[i][1])?.rounded(toPlaces: 4) ?? 0
            array.append([])
            for _ in 0..<arr[i].count{
                array[i].append(price)
                array[i].append(diff)
            }
        }
        return array
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

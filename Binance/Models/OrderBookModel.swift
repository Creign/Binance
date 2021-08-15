//
//  OrderBookModel.swift
//  Binance
//
//  Created by Excell on 15/08/2021.
//

import Foundation

class OrderBookModel: Codable {
    let e : String?
    let E : Int?
    let s : String?
    let U : Int?
    let u : Int?
    let b : [[Double]]?
    let a : [[Double]]?
    
    init(e: String, E: Int, s: String, U: Int, u: Int, b: [[Double]], a: [[Double]]) {
        self.e = e
        self.E = E
        self.s = s
        self.U = U
        self.u = u
        self.b = b
        self.a = a
    }
}



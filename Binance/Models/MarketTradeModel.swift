//
//  MarketTradeModel.swift
//  Binance
//
//  Created by Excell on 15/08/2021.
//

import Foundation

class MarketTradeModel: Codable {
    let e : String?
    let E : Int?
    let s : String?
    let a : Int?
    let p : String?
    let q : String?
    let f : Int?
    let l: Int?
    let T: Int?
    let m: Bool?
    let M: Bool?
    
    init(e: String, E: Int, s: String, a: Int, p: String, q: String, f: Int, l: Int, T: Int, m: Bool, M: Bool) {
        self.e = e
        self.E = E
        self.s = s
        self.a = a
        self.p = p
        self.q = q
        self.f = f
        self.l = l
        self.T = T
        self.m = m
        self.M = M
    }
}

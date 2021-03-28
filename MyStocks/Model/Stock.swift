//
//  Stock.swift
//  MyStocks
//
//  Created by Sergey Golovin on 22.03.2021.
//  Copyright © 2021 GoldenWindGames LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Stock: Object {
    @objc dynamic var stockTicker = ""
    @objc dynamic var stockName = ""
    @objc dynamic var stockPrice = 0.0
    @objc dynamic var stockLastClosePrice = 0.0
    @objc dynamic var stockDelta = 0.0
    @objc dynamic var isFavourite = false
}

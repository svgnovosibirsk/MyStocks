//
//  StockCell.swift
//  MyStocks
//
//  Created by Sergey Golovin on 22.03.2021.
//  Copyright © 2021 GoldenWindGames LLC. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {

    @IBOutlet weak var stockImage: UIImageView!
    @IBOutlet weak var stockTicker: UILabel!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    @IBOutlet weak var stockDelta: UILabel!
    
    func configureCell(with stock: Stock) {
        self.stockName.text = stock.stockName
        self.stockTicker.text = stock.stockTicker
        self.stockPrice.text = "$ \(stock.stockPrice)"
        let deltaPercent = stock.stockDelta / stock.stockPrice * 100
        self.stockDelta.text = String(format: "$%.2f  %%%.2f", stock.stockDelta, deltaPercent)
        self.imageView?.image = stock.isFavourite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star") // Должно быть наоборот
        self.stockDelta.textColor = stock.stockDelta > 0 ? .systemGreen : .systemRed
    }
    
}

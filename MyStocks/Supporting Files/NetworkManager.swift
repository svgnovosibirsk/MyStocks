//
//  NetworkManager.swift
//  MyStocks
//
//  Created by Sergey Golovin on 24.03.2021.
//  Copyright © 2021 GoldenWindGames LLC. All rights reserved.
//

// Данный класс NetworkManager используются при наличии платного аккаунта https://api.polygon.io и отсутствии жесткого лимита на количество обращений к API.
// При существующих ограничениях на количество обращений к API, данные берутся из файла MockupSterverAnswer.json, иммитирующего ответ сервера.

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()
    
    var stocksArray = [Stock]()
    
    func getStocks() {
        getTickers()
        getPrices()
    }
    
    private func getTickers()  {
        let tickersURL = "https://api.polygon.io/v2/reference/tickers?apiKey=Zp5xRd4whBpV6xxynO_xxZPZpbJ3RrC7"
        Alamofire.request(tickersURL, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let stocksJSONData: JSON = JSON(response.result.value!)
                let tickersPerPage = stocksJSONData["perPage"].intValue
                
                for i in 0...tickersPerPage - 1 {
                    let stock = Stock()
                    stock.stockTicker = stocksJSONData["tickers"][i]["ticker"].stringValue
                    stock.stockName = stocksJSONData["tickers"][i]["name"].stringValue
                    self.stocksArray.append(stock)
                }
                
            } else {
                print("HTTP Request error: \(String(describing: response.result.error))")
                let ac = UIAlertController(title: "Internet connection issues", message: "", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            }
        }
    }
    
    private func getPrices() {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        
        let firstDay = Date()
        let secondDay = Date(timeIntervalSinceNow: -1*24*60*60)
        let firstDayString = dateFormater.string(from: firstDay)
        let secondDayString = dateFormater.string(from: secondDay)
        
        for i in 0...stocksArray.count - 1 {
            let priceURL = "https://api.polygon.io/v1/open-close/\(stocksArray[i].stockTicker)/\(firstDayString)?unadjusted=true&apiKey=Zp5xRd4whBpV6xxynO_xxZPZpbJ3RrC7"
            let encodedURL = priceURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(encodedURL!, method: .get).responseJSON { response in
                if response.result.isSuccess {
                    let stocksJSONData: JSON = JSON(response.result.value!)
                    self.stocksArray[i].stockPrice = stocksJSONData["close"].doubleValue
                } else {
                    print("HTTP Request error: \(String(describing: response.result.error))")
                }
            }
            
            let price2URL = "https://api.polygon.io/v1/open-close/\(stocksArray[i].stockTicker)/\(secondDayString)?unadjusted=true&apiKey=Zp5xRd4whBpV6xxynO_xxZPZpbJ3RrC7"
            let encodedURL2 = price2URL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            Alamofire.request(encodedURL2!, method: .get).responseJSON { response in
                if response.result.isSuccess {
                    let stocksJSONData: JSON = JSON(response.result.value!)
                    self.stocksArray[i].stockLastClosePrice = stocksJSONData["close"].doubleValue
                } else {
                    print("HTTP Request error: \(String(describing: response.result.error))")
                }
            }
        }
    }
    
   
}


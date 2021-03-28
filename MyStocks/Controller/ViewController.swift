//
//  ViewController.swift
//  MyStocks
//
//  Created by Sergey Golovin on 21.03.2021.
//  Copyright © 2021 GoldenWindGames LLC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    var stocksArray = [Stock]()
    var favouriteStocksArray = [Stock]()
    var tempStocksArray = [Stock]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var stocksBtn: UIButton!
    @IBOutlet weak var favouriteBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Методы класса NetworkManager вызываются при наличии платного аккаунта https://api.polygon.io и отсутствии жесткого лимита на количество обращений к API.
        // При существующих ограничениях на количество обращений к API, данные берутся из файла MockupSterverAnswer.json, иммитирующего ответ сервера.
        
//        NetworkManager.shared.getStocks()
//        stocksArray = NetworkManager.shared.stocksArray
        

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StockCell", bundle: nil), forCellReuseIdentifier: "stockCell")
        searchField.delegate = self
        
        // сохранение значения для импользовании в функии фильтрации
        tempStocksArray = stocksArray
        
        setupStocksArrayfromMockup()
       
    }
    
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
         let vc = storyboard?.instantiateViewController(withIdentifier: "favourite") as! FavouriteViewController
         vc.stocksArray = favouriteStocksArray
         present(vc, animated: true)
     }
    
    private func setupStocksArrayfromMockup() {
        guard let mockupServerAnswerURL = Bundle.main.url(forResource: "MockupSterverAnswer", withExtension: "json") else { return }
        guard let data = try? JSON(Data(contentsOf: mockupServerAnswerURL)) else { return }
        for i in 0...data.count - 1 {
            let stock = Stock()
            stock.stockName = data[i]["name"].stringValue
            stock.stockTicker = data[i]["ticker"].stringValue
            let price = data[i]["close"].doubleValue
            let prevClose = data[i]["lastClose"].doubleValue
            let delta = price - prevClose
            stock.stockPrice = price
            stock.stockDelta = delta
                
            stocksArray.append(stock)
        }
    }
    
    private func setupFavouriteStocksArray() {
        for stock in stocksArray {
            if stock.isFavourite {
                favouriteStocksArray.append(stock)
            }
        }
    }
    
}

// MARK: - UITableViewDelegate and UITableViewDataSource Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stocksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        let stock = stocksArray[indexPath.row]
        cell.configureCell(with: stock)
        cell.backgroundColor = indexPath.row.isMultiple(of: 2) ? .systemGroupedBackground : .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stock = stocksArray[indexPath.row]
        
        if stock.isFavourite {
            stock.isFavourite.toggle()
            favouriteStocksArray.removeAll()
            setupFavouriteStocksArray()
            tableView.reloadData()
            
        } else {
            stock.isFavourite.toggle()
            favouriteStocksArray.append(stock)
            tableView.reloadData()
        }
    }
    
}

// MARK: - SearchBar Methods

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text?.lowercased() else { return }
        var searchArray = [Stock]()
        for stock in stocksArray {
            if stock.stockName.lowercased().contains(searchText) || stock.stockTicker.lowercased().contains(searchText) {
                searchArray.append(stock)
            }
        }
        tempStocksArray = stocksArray
        stocksArray = searchArray

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            stocksArray = tempStocksArray
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
            }
        }
    }
}

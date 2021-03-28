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
import RealmSwift

class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    var stocksArray: Results<Stock>?
    var favouriteStocksArray = [Stock]()
    //var tempStocksArray = [Stock]()
    var tempStocksArray: Results<Stock>?
    
    
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
        
        // Запускается при первом запуске, при отсутствии данных в базы
        // При платного аккаунта https://api.polygon.io подгружаем данные с сервераю
        setupStocksArrayfromMockup()
        
        // Подгружает данные из базы
        loadStocks()
       
    }
    
    @IBAction func favouriteBtnPressed(_ sender: UIButton) {
         let vc = storyboard?.instantiateViewController(withIdentifier: "favourite") as! FavouriteViewController
         let tempStocksArray = stocksArray?.filter(NSPredicate(format: "isFavourite = true"))
         vc.stocksArray = tempStocksArray
         present(vc, animated: true)
     }
    
    private func setupStocksArrayfromMockup() {
        // Проверяем наличие оюъектов в базе данных
        let tempStocksArray = realm.objects(Stock.self)
        guard tempStocksArray.isEmpty else { return }
        
        // Если база пустая, прогружаем данные из файла
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

            save(stock: stock)
        }
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        if let stock = stocksArray?[indexPath.row] {
            cell.configureCell(with: stock)
        }
        cell.backgroundColor = indexPath.row.isMultiple(of: 2) ? .systemGroupedBackground : .white
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let stock = stocksArray?[indexPath.row] else { return }
        
            do {
                try realm.write {
                    stock.isFavourite.toggle()
                }
            } catch {
                print("Realm write error \(error)")
            }
            
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar Methods

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let namePredicate:NSPredicate = NSPredicate(format: "stockName CONTAINS[cd] %@", searchBar.text!)
        let tickerPedicate:NSPredicate = NSPredicate(format: "stockTicker CONTAINS[cd] %@", searchBar.text!)
        let predicate:NSPredicate  = NSCompoundPredicate(orPredicateWithSubpredicates: [namePredicate,tickerPedicate])
        tempStocksArray = stocksArray
        stocksArray = stocksArray?.filter(predicate)
        tableView.reloadData()
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

// MARK: - Realm Methods

extension ViewController {
    
    func save(stock: Stock) {
        do {
            try realm.write {
                realm.add(stock)
            }
        } catch {
            print("Realm saving error \(error)")
        }
        tableView.reloadData()
    }
    
    func loadStocks() {
        stocksArray = realm.objects(Stock.self)
        tableView.reloadData()
    }
}

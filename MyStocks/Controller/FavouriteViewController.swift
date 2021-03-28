//
//  FavouriteViewController.swift
//  MyStocks
//
//  Created by Sergey Golovin on 21.03.2021.
//  Copyright © 2021 GoldenWindGames LLC. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteViewController: UIViewController {

    var stocksArray: Results<Stock>?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "StockCell", bundle: nil), forCellReuseIdentifier: "stockCell")
          
    }
    
    @IBAction func stocksBtnPressed(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
    }
    
}


extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksArray?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stockCell", for: indexPath) as! StockCell
        if let stock = stocksArray?[indexPath.row] {
            cell.configureCell(with: stock)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "chartVC") as! ChartViewController
        if let stock = stocksArray?[indexPath.row] {
            vc.stock = stock
        }
        present(vc, animated: true)
    }
}

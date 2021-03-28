//
//  ChartViewController.swift
//  MyStocks
//
//  Created by Sergey Golovin on 27.03.2021.
//  Copyright © 2021 GoldenWindGames LLC. All rights reserved.
//

import UIKit
import CoreGraphics

class ChartViewController: UIViewController {
    
    // При наличии платного аккаунта https://api.polygon.io и отсутствии жесткого лимита на количество обращений к API, получаем исторические данные через запрос https://api.polygon.io/v1/open-close/HD/2020-10-14?unadjusted=true&apiKey=Zp5xRd4whBpV6xxynO_xxZPZpbJ3RrC7
    
    var historicalPrices = [205.66, 207.81, 210.32, 230.65, 225.12, 220.42, 215.76, 220.86, 215.32, 210.41, 207.86, 215.44, 207.12, 220.56, 217.86, 222.85, 220.76, 230.65, 225.12, 220.42] // При получении данных через API, устанавливаем значение в зависимости от рассматриваемого периода (неделя, месяц, год...)
    var stock = Stock()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tickerLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tickerLbl.text = stock.stockTicker
        nameLbl.text = stock.stockName
        drawChart()
    }
    
    // Иммитация графиков за неделю, месяц, год. При наличии платного аккаунта https://api.polygon.io и отсутствии жесткого лимита на количество обращений к API, получаем исторические данные через запрос к серверу.
    
    @IBAction func weekBtnPressed(_ sender: UIButton) {
        historicalPrices = [200.66, 207.81, 190.32, 230.65, 205.12, 220.42, 205.76, 225.86, 202.32, 210.41, 230.86, 215.44, 203.12, 220.56, 207.86, 222.85, 220.76, 230.65, 205.12, 220.42]
        drawChart()
    }
    
    @IBAction func monthBtnPressed(_ sender: UIButton) {
        historicalPrices = [235.66, 232.81, 230.32, 228.65, 235.12, 226.42, 220.76, 218.86, 216.32, 220.41, 214.86, 215.44, 203.12, 207.56, 210.86, 200.85, 205.76, 210.65, 215.12, 220.42]
        drawChart()
    }
    
    @IBAction func yearBtnPressed(_ sender: UIButton) {
        historicalPrices = [180.66, 185.81, 190.32, 185.65, 195.12, 200.42, 195.76, 190.86, 195.32, 200.41, 204.86, 210.44, 203.12, 207.56, 210.86, 215.85, 220.76, 210.65, 225.12, 220.42]
        drawChart()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    private func drawChart() {
        let renderer = UIGraphicsImageRenderer(bounds: imageView.bounds)
        
        let image = renderer.image { context in
            context.cgContext.setStrokeColor(UIColor.blue.cgColor)
            context.cgContext.setLineWidth(3)
            
            //let chartWidth = imageView.bounds.width
            let chartHeight = Double(imageView.bounds.height)
            
           // Отрисовка графика в цикле
            
//            var date = Double(chartWidth) / Double(historicalPrices.count)
//
//            context.cgContext.move(to: CGPoint(x: 0, y: historicalPrices[0]))
//
//            for i in 1...historicalPrices.count - 1 {
//
//                let pricePosition = Double(chartHeight - historicalPrices[i])
//                context.cgContext.addLine(to: CGPoint(x: date, y: pricePosition))
//                date += date
//            }
            
            // Прописал в ручную, т.к. при выводе через цикл график получается сглаженный. К сожалению не успел разобраться. Полагаю, что причина в приведении типов.
            
            context.cgContext.move(to: CGPoint(x: 0, y: historicalPrices[0]))
            context.cgContext.addLine(to: CGPoint(x: 20, y: chartHeight - historicalPrices[1]))
            context.cgContext.addLine(to: CGPoint(x: 40, y: chartHeight - historicalPrices[2]))
            context.cgContext.addLine(to: CGPoint(x: 60, y: chartHeight - historicalPrices[3]))
            context.cgContext.addLine(to: CGPoint(x: 80, y: chartHeight - historicalPrices[4]))
            context.cgContext.addLine(to: CGPoint(x: 100, y: chartHeight - historicalPrices[5]))
            context.cgContext.addLine(to: CGPoint(x: 120, y: chartHeight - historicalPrices[6]))
            context.cgContext.addLine(to: CGPoint(x: 140, y: chartHeight - historicalPrices[7]))
            context.cgContext.addLine(to: CGPoint(x: 160, y: chartHeight - historicalPrices[8]))
            context.cgContext.addLine(to: CGPoint(x: 180, y: chartHeight - historicalPrices[9]))
            context.cgContext.addLine(to: CGPoint(x: 200, y: chartHeight - historicalPrices[10]))
            context.cgContext.addLine(to: CGPoint(x: 210, y: chartHeight - historicalPrices[11]))
            context.cgContext.addLine(to: CGPoint(x: 220, y: chartHeight - historicalPrices[12]))
            context.cgContext.addLine(to: CGPoint(x: 240, y: chartHeight - historicalPrices[13]))
            context.cgContext.addLine(to: CGPoint(x: 260, y: chartHeight - historicalPrices[14]))
            context.cgContext.addLine(to: CGPoint(x: 280, y: chartHeight - historicalPrices[15]))
            context.cgContext.addLine(to: CGPoint(x: 300, y: chartHeight - historicalPrices[16]))
            context.cgContext.addLine(to: CGPoint(x: 320, y: chartHeight - historicalPrices[17]))
            context.cgContext.addLine(to: CGPoint(x: 340, y: chartHeight - historicalPrices[18]))
            context.cgContext.addLine(to: CGPoint(x: 360, y: chartHeight - historicalPrices[19]))
            
            context.cgContext.strokePath()
            
            context.cgContext.setStrokeColor(UIColor.black.cgColor)
            context.cgContext.setLineWidth(5)
            
            context.cgContext.move(to: CGPoint(x: 0, y: 374))
            context.cgContext.addLine(to: CGPoint(x: 374, y: 374))
         
            context.cgContext.move(to: CGPoint(x: 0, y: 374))
            context.cgContext.addLine(to: CGPoint(x: 0, y: 10))
            
            context.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
}

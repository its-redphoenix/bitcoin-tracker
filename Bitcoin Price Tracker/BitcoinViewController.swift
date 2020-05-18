//
//  BitcoinViewController.swift
//  Bitcoin Price Tracker
//

import UIKit

class BitcoinViewController: UIViewController {
    
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var eurLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let usd = UserDefaults.standard.string(forKey: "USD") {
            usdLabel.text = usd
        }
        if let eur = UserDefaults.standard.string(forKey: "EUR") {
            eurLabel.text = eur
        }
        if let jpy = UserDefaults.standard.string(forKey: "JPY") {
            jpyLabel.text = jpy
        }
        
        
        
        getPrice()
    }
    
    func getPrice() {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,JPY,EUR") {
            URLSession.shared.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
                if error == nil {
                    if data != nil {
                        if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String:Double] {
                            DispatchQueue.main.async {
                                
                                if let usdPrice = json["USD"] {
                                    self.usdLabel.text = self.getStringFor(price: usdPrice, currencyCode: "USD")
                                    UserDefaults.standard.set(self.getStringFor(price: usdPrice, currencyCode: "USD") + "~", forKey: "USD")
                                }
                                if let eurPrice = json["EUR"] {
                                    self.eurLabel.text = self.getStringFor(price: eurPrice, currencyCode: "EUR")
                                    UserDefaults.standard.set(self.getStringFor(price: eurPrice, currencyCode: "EUR") + "~", forKey: "EUR")
                                }
                                if let jpyPrice = json["JPY"] {
                                    self.jpyLabel.text = self.getStringFor(price: jpyPrice, currencyCode: "JPY")
                                    UserDefaults.standard.set(self.getStringFor(price: jpyPrice, currencyCode: "JPY") + "~", forKey: "JPY")
                                }
                                
                            }
                        }
                    }
                    
                    
                } else {
                    print("We have an error")
                }
            }.resume()
        }
    }
    
    func getStringFor(price:Double, currencyCode:String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        if let priceString = formatter.string(from: NSNumber(value: price)) {
            return priceString
        }
        return "Error"
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        getPrice()
    }
    
}


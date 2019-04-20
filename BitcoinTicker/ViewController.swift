//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
	let currenySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       	currencyPicker.delegate = self
		currencyPicker.dataSource = self
    }

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
    
	func pickerView(_ pickerView: UIPickerView,  numberOfRowsInComponent compenent: Int) -> Int {
		return currencyArray.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return currencyArray[row]
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print(currencyArray[row])

		finalURL = baseURL + currencyArray[row]

		print(finalURL)
		getBitcoinData(url: finalURL, symbol: currenySymbol[row])
	}

    //MARK: - Networking
    /***************************************************************/

	func getBitcoinData(url: String, symbol: String) {
		var askPrice = ""
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    let bitcoinJSON : JSON = JSON(response.result.value!)
                    askPrice = symbol + self.updateBitcoinData(json: bitcoinJSON)
                } else {
                    print("Error: \(String(describing: response.result.error))")
                }
				self.bitcoinPriceLabel.text = askPrice
            }
    }

    //MARK: - JSON Parsing
    /***************************************************************/

    func updateBitcoinData(json : JSON) -> String{
		var returnStatement = "Connection Issues"
        if let tempResult = json["ask"].double {
			returnStatement = String(tempResult)
        }
		return returnStatement
	}
}


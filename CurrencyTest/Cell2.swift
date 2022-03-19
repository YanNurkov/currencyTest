//
//  Cell2.swift
//  CurrencyTest
//
//  Created by Ян Нурков on 09.11.2021.
//

import Foundation
import UIKit

class CustomeCell2: UITableViewCell {
    var codeCurrency = String()
    let infoCurrency = UILabel()
    let nameOfCurrency = UILabel()
    
   
    func configView() {
        self.contentView.addSubview(infoCurrency)
        self.contentView.addSubview(nameOfCurrency)
        contentView.backgroundColor = .white
        
        
        nameOfCurrency.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(contentView.snp.centerY)
        }
        infoCurrency.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-25)
            make.top.equalTo(nameOfCurrency.snp.bottom)
        }
        
        infoCurrency.backgroundColor = .white
        infoCurrency.font = UIFont(name: "Ubuntu-Light", size: 23)
        nameOfCurrency.font = UIFont(name: "Ubuntu-Regular", size: 25)
        nameOfCurrency.backgroundColor = .white
    }
    
    func setData(dataCurrency: String, dataInfo: String, codeCurrency: String) {
        infoCurrency.text = dataInfo
        nameOfCurrency.text = dataCurrency
        self.codeCurrency = codeCurrency
      
    }
    
}


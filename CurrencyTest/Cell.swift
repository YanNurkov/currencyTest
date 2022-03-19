//
//  Cell.swift
//  CurrencyTest
//
//  Created by Ян Нурков on 15.10.2021.
//

import Foundation
import UIKit

class CustomeCell: UITableViewCell {
    var codeCurrency = String()
    let infoCurrency = UILabel()
    let nameOfCurrency = UILabel()
    let button: UIButton = {
       let obj = UIButton()
        obj.backgroundColor = .white
        obj.setImage(UIImage(named: "icons8-звезда-100"), for: UIControl.State.normal)
        obj.addTarget(self, action: #selector(pushButton(_:)), for: UIControl.Event.touchUpInside)
        return obj
    }()
    
    @objc func pushButton(_ sender: UIButton) {
        if UserDefaults.standard.value(forKey: "FavoritesCodes") == nil {
            UserDefaults.standard.set([String](), forKey: "FavoritesCodes")
        }
        guard var array = UserDefaults.standard.value(forKey: "FavoritesCodes") as? [String] else {return}
        if array.contains(codeCurrency) {
            if let index = array.firstIndex(of: codeCurrency) {
                array.remove(at: index)
                button.setImage(UIImage(named: "icons8-звезда-100"), for: UIControl.State.normal)
                
            }
        }
        else {
            array.append(codeCurrency)
            button.setImage(UIImage(named: "icons8-звезда-96"), for: UIControl.State.normal)
        }
        UserDefaults.standard.set(array, forKey: "FavoritesCodes")
        
    }
    
    func configView() {
        self.contentView.addSubview(infoCurrency)
        self.contentView.addSubview(nameOfCurrency)
        self.contentView.addSubview(button)
        contentView.backgroundColor = .white
        
        
        if let array = UserDefaults.standard.value(forKey: "FavoritesCodes") as? [String] {
            if array.contains(codeCurrency) {
                button.setImage(UIImage(named: "icons8-звезда-96"), for: UIControl.State.normal)
            }
            else {
                button.setImage(UIImage(named: "icons8-звезда-100"), for: UIControl.State.normal)
            }
        }
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nameOfCurrency.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            make.right.equalTo(button.snp.left)
            make.bottom.equalTo(contentView.snp.centerY)
        }
        infoCurrency.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalTo(button.snp.left)
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



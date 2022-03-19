//
//  FavoritesScreen.swift
//  CurrencyTest
//
//  Created by Ян Нурков on 02.11.2021.
//

import Foundation
import SnapKit
import UIKit
import Alamofire

class FavoritesScreen: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let array = UserDefaults.standard.value(forKey: "FavoritesCodes") as? [String] else {return 0}
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? CustomeCell2 else {return UITableViewCell() }
                
        guard let array = UserDefaults.standard.array(forKey: "FavoritesCodes") as? [String] else {return UITableViewCell()}
        let code = array[indexPath.row]
        guard let value = dictCode_Value[code] else {return UITableViewCell()}
       
        let firstIndex = arrayCode_Name.firstIndex { codeName in
           return codeName.key == code
        }
        
        func dataCurrencyFunc() -> String? {
            if self.flugs.keys.contains(arrayCode_Name[firstIndex!].key) {
                return (flugs[arrayCode_Name[firstIndex!].key]! + arrayCode_Name[firstIndex!].value) }
            else {
                return ("\u{1fa99}" + arrayCode_Name[firstIndex!].value )
            }
        }
        
        
        let dataInfoText = code + ": " + String(value)
        let codeCurrencyText = code
        
        
        cell.setData(dataCurrency: dataCurrencyFunc()!,  dataInfo: dataInfoText, codeCurrency: codeCurrencyText)
        cell.configView()
        cell.selectionStyle = .none
        navigationController?.navigationBar.barTintColor = .white
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            guard var array = UserDefaults.standard.array(forKey: "FavoritesCodes") as? [String] else {return}
            array.remove(at: indexPath.row)
            UserDefaults.standard.set(array, forKey:"FavoritesCodes")
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        default:
            return
        }
    }
    
    var alert: UIAlertController?
    var value: Double?
    var codeName: String?
    var codeOfCurrency: String?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
        guard let array = UserDefaults.standard.array(forKey: "FavoritesCodes") as? [String] else {return }
        let code = array[indexPath.row]
        let firstIndex = arrayCode_Name.firstIndex { codeName in
           return codeName.key == code
        }
        
        value = self.dictCode_Value[arrayCode_Name[firstIndex!].key]
        codeName = self.arrayCode_Name[firstIndex!].key
        
        
        alert = UIAlertController (title: arrayCode_Name[firstIndex!].value, message:"0.0 " + arrayCode_Name[firstIndex!].key, preferredStyle: .alert)
        alert?.setValue(NSAttributedString(string: "0.0 " + code, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)]), forKey: "attributedMessage")
        
        guard let alert = alert else {
            return
        }
        alert.addTextField { UITextField in
            UITextField.delegate = self
            UITextField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            UITextField.placeholder = "Введите в " + self.code
            UITextField.keyboardType = UIKeyboardType.decimalPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
        }))
        self.present(alert, animated: true, completion: nil)
    
    }
    @objc func textChanged(_ sender: UITextField) {
      
        
        guard var text = sender.text else {return}
        guard let codeName = codeName else {
            return
        }
        if text == "" {
            sender.text = ""
        }
        if text == "" {
            alert?.message = "0.0 " + codeName
        }
        let replaced = String(text.map {
            $0 == "," ? "." : $0
        })
        var dot = Int()
        var comma = Int()
        for simvol in text {
            if simvol == "." {
                dot += 1
            }
        }
        if dot >= 2 {
            text.removeLast()
        }
        
        for simvol in text {
            if simvol == "," {
                comma += 1
            }
        }
        if comma >= 2 {
            text.removeLast()
        }
        sender.text = text
        guard let textDouble = Double(replaced) else {return}
        guard let value = value else {return}
        alert?.message = String(format: "%.2f", textDouble * value) + " " + codeName
    }
    

    var arrayInfo = [String]()
    let label = UILabel()
    let labelFavorites = UILabel()
    let tableView = UITableView()
    let code: String
    var flugs = [String : String]()
    let arrayCode_Name: [Dictionary<String, String>.Element]
    var dictCode_Value = [String: Double]()
    
    
    init(code: String, flugs: [String : String], arrayCode_Name: [Dictionary<String, String>.Element]) {
        self.code = code
        self.arrayCode_Name = arrayCode_Name
        self.flugs = flugs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        tableView.separatorInset = .zero
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(label)
        self.view.addSubview(labelFavorites)
        labelFavorites.text = "Избранное"
        labelFavorites.textAlignment = .center
        labelFavorites.font = UIFont(name: "Ubuntu-Regular", size: 25)
        label.text = code
        label.font = UIFont(name: "Ubuntu-Regular", size: 30)
        label.textColor = UIColor.systemTeal
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(100)
        }
        labelFavorites.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(100)
        }
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(label.snp.bottom)
        }
        tableView.register(CustomeCell2.self, forCellReuseIdentifier: "cell2")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        
        downloadInfo(currency: code)
       
    
    }

}
        
        
        
        
        
        
extension FavoritesScreen {
    
    func downloadInfo(currency: String) {
        
        
        let infoUrl = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/" + currency + ".json"

        guard let url = URL(string: infoUrl) else {return}
        
        AF
            .request(url)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    guard let resultDict = data as? [String: Any] else {return}
                    guard let resultEur = resultDict[currency] else {return}
                    guard let dictCode_Value = resultEur as? [String: Double] else {return}
                    self.dictCode_Value = dictCode_Value
                
                    
                    self.tableView.reloadData()
                    
                    
                    
                    
                case.failure(let error):
                    
                    if let data = UserDefaults.standard.value(forKey: "currencyCodeName" + currency + "Dict") {
                        guard let resultDict = data as? [String: Any] else {return}
                        guard let resultEur = resultDict[currency] else {return}
                        guard let dictCode_Value = resultEur as? [String: Double] else {return}
                        self.dictCode_Value = dictCode_Value
                    }
                    else {
                        let alert = UIAlertController(title: "Не получилось загрузить данные", message: "Попробовать снова?", preferredStyle: .alert)
                        alert.addAction(.init(title: "OK", style: .default, handler: { _ in
                            self.downloadInfo(currency: currency)
                        }))
                        alert.addAction(.init(title: "Закрыть", style: .cancel, handler: { _ in
                           // self.navigationController?.popViewController(animated: true)
                            self.dismiss(animated: true)
                            
                        }))
                        self.present(alert, animated: true)
                    }
                    print(error.localizedDescription)
                    
                }
            }
    }
   
}



//
//  ViewController.swift
//  CurrencyTest
//
//  Created by Ян Нурков on 05.10.2021.
//

import UIKit
import SnapKit
import Alamofire



class SecondScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UISearchResultsUpdating {
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredArrayCode_Name.count
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomeCell  else {return UITableViewCell()}
       
       
       let code = filteredArrayCode_Name[indexPath.row].key
     
       
       guard let value = self.dictCode_Value[code] else {return UITableViewCell()}
       
       func dataCurrencyFunc() -> String? {
           if self.dictFlugs.keys.contains(filteredArrayCode_Name[indexPath.row].key) {
               return (dictFlugs[filteredArrayCode_Name[indexPath.row].key]! + filteredArrayCode_Name[indexPath.row].value) }
           else {
               return ("\u{1fa99}" + filteredArrayCode_Name[indexPath.row].value )
           }
       }


       cell.setData(dataCurrency: dataCurrencyFunc()!,  dataInfo: code + ": " + String(value), codeCurrency: code)

        cell.configView()
        cell.selectionStyle = .none
        navigationController?.navigationBar.barTintColor = .white
        
       
        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        
        guard let searchText = searchController.searchBar.text, searchText.isEmpty == false else {
            filteredArrayCode_Name = arrayCode_Name
            tableView.reloadData()
            return
        }
        
       filteredArrayCode_Name = arrayCode_Name.filter { codeName in
           codeName.value.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()

    }
    
    
    
    
    
    
    
    var alert: UIAlertController?
    var value: Double?
    var name: String?
    var codeOfCurrency: String?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        let code = filteredArrayCode_Name[indexPath.row].key
        
        
        value = self.dictCode_Value[code]
        name = filteredArrayCode_Name[indexPath.row].value
        codeOfCurrency = code
        
        alert = UIAlertController (title: name, message:"0.0 " + code, preferredStyle: .alert)
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
    @objc func dismissKeyBoard() {
        searchController.searchBar.resignFirstResponder()
    }
    
    
    @objc func textChanged(_ sender: UITextField) {
        guard var text = sender.text else {return}
        
        guard let codeName = codeOfCurrency else {
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
    
   

    let code: String
    var arrayInfo = [String]()
    let tableView = UITableView()
    var searchController: UISearchController!
    let label = UILabel()
    let arrayCode_Name: [Dictionary<String, String>.Element]
    var dictCode_Value = [String: Double]()
    var namesOfCurrency = [String]()
    var filteredArrayCode_Name = [Dictionary<String, String>.Element]()
    var dictFlugs = [String : String]()
    
    
    init(code: String, dictFlugs: [String : String], arrayCode_Name: [Dictionary<String, String>.Element], namesOfCurrency: [String]) {
        self.code = code
        self.arrayCode_Name = arrayCode_Name
        self.namesOfCurrency = namesOfCurrency
        self.dictFlugs = dictFlugs
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.navigationItem.searchController?.searchBar.endEditing(true)
        //self.navigationItem.titleView?.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        tableView.separatorInset = .zero
        super.viewDidLoad()
        tableView.dataSource = self
        self.filteredArrayCode_Name = arrayCode_Name
        
        
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar
        //navigationItem.searchController = searchController
        //self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        view.backgroundColor = .white
        self.view.addSubview(tableView)
        self.view.addSubview(label)
        
        
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
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(label.snp.bottom)
        }
        tableView.register(CustomeCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        
        downloadInfo(currency: code)
       
    
    }
  

}


extension SecondScreen {
    
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
                    UserDefaults.standard.set(data, forKey: "currencyCodeName" + currency + "Dict")
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
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true)
                    }
                    print(error.localizedDescription)
                    
                }
            }
    }
   
}

class CustomeSearchController: UISearchController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
    
    
    
    
    
    
    
    
    
    


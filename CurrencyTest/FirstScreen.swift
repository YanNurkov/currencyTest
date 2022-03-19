//
//  FirstScreen.swift
//  CurrencyTest
//
//  Created by Ян Нурков on 05.10.2021.
//

import Foundation
import UIKit
import SnapKit
import Alamofire
import CoreLocation




class FirstScreen: UIViewController, CLLocationManagerDelegate {
    
    let tableView = UIView()
    var locat = [CLLocation]()
    @objc let locatorManager = CLLocationManager()
    
   lazy var button: UIButton = {
        let obj = UIButton()
        obj.backgroundColor = .white
       obj.setImage(UIImage(named: "icons8-звезда-100"), for: UIControl.State.normal)
       obj.addTarget(self, action: #selector (buttonToFavorites), for: UIControl.Event.touchDown)
       return obj
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        configRightButton()
        dowloadInfo()
        locatorManager.delegate = self
        locatorManager.requestAlwaysAuthorization()
        locatorManager.startUpdatingLocation()
    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       guard let locat = locations.last else { return }
        self.locat.append(locat)
       
//       if self.locat.count >= 1 {
//           let indexPlace = UserDefaults.standard.value(forKey: "index")
//           self.pickerView.selectRow(indexPlace as! Int, inComponent: 0, animated: true)
//
//       }
     
        let decoder = CLGeocoder()
                    decoder.reverseGeocodeLocation(locat) { placemark, error in
                        if error != nil {
                            let indexPlace = UserDefaults.standard.value(forKey: "index")
                            self.pickerView.selectRow(indexPlace as! Int, inComponent: 0, animated: true)
                            self.locatorManager.stopUpdatingLocation()
                        }
            guard let place = placemark?.first else {return}
            guard let isoCodeCurrency = Locale.currency[place.isoCountryCode!]?.code?.lowercased() else {return}
            guard let index = self.fullInfoOfCurrency.firstIndex(where: { code , name in
                if code == isoCodeCurrency {
                 return true
                }
                else {
                    return false
                }
            }) else {return}
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
            self.locatorManager.stopUpdatingLocation()
            print(place.country, Locale.currency[place.isoCountryCode!]?.code)
            UserDefaults.standard.set(index, forKey: "index")
            print(UserDefaults.standard.value(forKey: "index") as Any)

        }

    }
    
    

    
    
    private func configView() {
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.pickerView)
        self.view.addSubview(self.button)
        
        self.button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-40)
            make.height.width.equalTo(60)
        }
        
        self.tableView.snp.makeConstraints { make in
            make.bottom.top.right.left.equalToSuperview()
        }
        self.pickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.view.backgroundColor = .white
    }
    
    
    var namesOfCurrency = [String]()
   
    var fullInfoOfCurrency = [Dictionary<String, String>.Element]() {
        didSet{
            self.updatePickerView()
        }
    }
   
    
    var dictFlugs = ["afn" : "\u{1f1e6}\u{1f1eb}", "all" : "\u{1f1e6}\u{1f1f1}", "dzd" : "\u{1f1e9}\u{1f1ff}", "aoa" : "\u{1f1e6}\u{1f1f4}", "ars" : "\u{1f1e6}\u{1f1f7}" , "amd" : "\u{1f1e6}\u{1f1f2}" , "awg" : "\u{1f1e6}\u{1f1fc}" , "aud" : "\u{1f1e6}\u{1f1fa}" , "azn" : "\u{1f1e6}\u{1f1ff}" , "bsd" : "\u{1f1e7}\u{1f1f8}" , "bhd" : "\u{1f1e7}\u{1f1ed}" , "bbd" : "\u{1f1e7}\u{1f1e7}" , "bdt" : "\u{1f1e7}\u{1f1e9}" , "byr" : "\u{1f1e7}\u{1f1fe}" , "bzd" : "\u{1f1e7}\u{1f1ff}" , "bmd" : "\u{1f1e7}\u{1f1f2}" , "btn" : "\u{1f1e7}\u{1f1f9}" , "bnb" : "\u{1fa99}" , "btc" : "\u{20bf}" , "bch" : "\u{20bf}" , "bob" : "\u{1f1e7}\u{1f1f4}" , "bam" : "\u{1f1e7}\u{1f1e6}" , "bwp" : "\u{1f1e7}\u{1f1fc}" , "brl" : "\u{1f1e7}\u{1f1f7}" , "bnd" : "\u{1f1e7}\u{1f1f3}" , "bgn" : "\u{1f1e7}\u{1f1ec}" , "bif" : "\u{1f1e7}\u{1f1ee}" , "xpf" : "\u{1fa99}" , "khr" : "\u{1f1f0}\u{1f1ed}" , "cad" : "\u{1f1e8}\u{1f1e6}" , "cve" : "\u{1f1e8}\u{1f1fb}" , "ada" : "\u{1fa99}" , "kyd" : "\u{1f1f0}\u{1f1fe}" , "xaf" : "\u{1f1e8}\u{1f1eb}" , "link" : "\u{1fa99}" , "clf" : "\u{1f1e8}\u{1f1f1}" , "clp" : "\u{1f1e8}\u{1f1f1}" , "cny" : "\u{1f1e8}\u{1f1f3}" , "imp" : "\u{1fa99}" , "cop" : "\u{1f1e8}\u{1f1f4}" , "kmf" : "\u{1f1f0}\u{1f1f2}" , "cdf" : "\u{1f1e8}\u{1f1e9}" , "crc" : "\u{1f1e8}\u{1f1f7}" , "hrk" : "\u{1f1ed}\u{1f1f7}" , "cup" : "\u{1f1e8}\u{1f1fa}" , "cuc" : "\u{1f1e8}\u{1f1fa}" , "czk" : "\u{1f1e8}\u{1f1ff}" , "dkk" : "\u{1f1e9}\u{1f1f0}" , "djf" : "\u{1f1e9}\u{1f1ef}" , "doge" : "\u{1fa99}" , "dop" : "\u{1f1e9}\u{1f1f4}" , "xcd" : "\u{1f1e7}\u{1f1f6}" , "egp" : "\u{1f1ea}\u{1f1ec}" , "ern" : "\u{1f1ea}\u{1f1f7}" , "eth" : "\u{1fa99}" , "etc" : "\u{1fa99}" , "etb" : "\u{1fa99}" , "eur" : "\u{1f4b6}" , "fkp" : "\u{1f1eb}\u{1f1f0}" , "fjd" : "\u{1f1eb}\u{1f1ef}" , "ggp" : "\u{1fa99}" , "gmd" : "\u{1f1ec}\u{1f1f2}" , "gel" : "\u{1f1ec}\u{1f1ea}" , "ghs" : "\u{1f1ec}\u{1f1ed}" , "gip" : "\u{1f1ec}\u{1f1ee}" , "gtq" : "\u{1f1ec}\u{1f1f9}", "gnf" : "\u{1f1ec}\u{1f1f3}" , "gyd" : "\u{1f1ec}\u{1f1fe}" , "htg" : "\u{1f1ed}\u{1f1f9}" , "hnl" : "\u{1f1ed}\u{1f1f3}" , "hkd" : "\u{1f1ed}\u{1f1f0}" , "huf" : "\u{1f1ed}\u{1f1fa}" , "isk" : "\u{1f1ee}\u{1f1f8}" , "inr" : "\u{1f1ee}\u{1f1f3}" , "idr" : "\u{1f1ee}\u{1f1e9}" , "irr" : "\u{1f1ee}\u{1f1f7}" , "iqd" : "\u{1f1ee}\u{1f1f1}" , "ils" : "\u{1f1ee}\u{1f1f1}" , "jmd" : "\u{1f1ef}\u{1f1f2}" , "jpy" : "\u{1f1ef}\u{1f1f5}" , "jep" : "\u{1f1ef}\u{1f1ea}" , "jod" : "\u{1f1ef}\u{1f1f4}" , "kzt" : "\u{1f1f0}\u{1f1ff}" , "kes" : "\u{1f1f0}\u{1f1ea}" , "kwd" : "\u{1f1f0}\u{1f1fc}" , "kgs" : "\u{1f1f0}\u{1f1ec}" , "lak" : "\u{1f1f1}\u{1f1e6}" , "lvl" : "\u{1f1f1}\u{1f1fb}" , "lbp" : "\u{1f1f1}\u{1f1e7}" , "lsl" : "\u{1f1f1}\u{1f1f8}" , "lrd" : "\u{1f1f1}\u{1f1f7}" , "lyd" : "\u{1f1f1}\u{1f1fe}" , "ltc" : "\u{1fa99}" , "ltl" : "\u{1f1f1}\u{1f1f9}" , "mop" : "\u{1f1f2}\u{1f1f4}" , "mkd" : "\u{1fa99}" , "mga" : "\u{1f1f2}\u{1f1ec}" , "mwk" : "\u{1f1f2}\u{1f1fc}" , "myr" : "\u{1f1f2}\u{1f1fe}" , "mvr" : "\u{1f1f2}\u{1f1fb}" , "mro" : "\u{1f1f2}\u{1f1f7}" , "mur" : "\u{1f1f2}\u{1f1fa}" , "mxn" : "\u{1f1f2}\u{1f1fd}" , "mdl" : "\u{1f1f2}\u{1f1e9}" , "mnt" : "\u{1f1f2}\u{1f1f3}" , "mad" : "\u{1f1f2}\u{1f1e6}" , "mzn" : "\u{1f1f2}\u{1f1ff}" , "mmk" : "\u{1f1f2}\u{1f1f2}" , "nad" : "\u{1f1f3}\u{1f1e6}" , "npr" : "\u{1f1f3}\u{1f1f5}" , "ang" : "\u{1f1f3}\u{1f1f1}" , "byn" : "\u{1f1e7}\u{1f1fe}" , "twd" : "\u{1f1f9}\u{1f1fc}" , "nzd" : "\u{1f1f3}\u{1f1ff}" , "nio" : "\u{1f1f3}\u{1f1ee}" , "ngn" : "\u{1f1f3}\u{1f1ea}" , "kpw" : "\u{1f1f0}\u{1f1f5}" , "nok" : "\u{1f1f3}\u{1f1f4}" , "omr" : "\u{1f1f4}\u{1f1f2}" , "pkr" : "\u{1f1f5}\u{1f1f0}" , "pab" : "\u{1f1f5}\u{1f1e6}" , "pgk" : "\u{1f1f5}\u{1f1ec}" , "pyg" : "\u{1f1f5}\u{1f1fe}" , "php" : "\u{1f1f5}\u{1f1ed}" , "pln" : "\u{1f1f5}\u{1f1f1}" , "gbp" : "\u{1f1ec}\u{1f1e7}" , "qar" : "\u{1f1f6}\u{1f1e6}" , "ron" : "\u{1f1f7}\u{1f1f4}" , "rub" : "\u{1f1f7}\u{1f1fa}" , "rwf" : "\u{1f1f7}\u{1f1fc}" , "shp" : "\u{1f1f8}\u{1f1ed}" , "svc" : "\u{1f1f8}\u{1f1fb}" , "wst" : "\u{1f1fc}\u{1f1f8}" , "sar" : "\u{1f1f8}\u{1f1e6}" , "rsd" : "\u{1f1f7}\u{1f1f8}" , "scr" : "\u{1f1f8}\u{1f1e8}" , "sll" : "\u{1f1f8}\u{1f1f1}" , "xag" : "\u{1fa99}" , "sgd" : "\u{1f1f8}\u{1f1ec}" , "pen" : "\u{1fa99}" , "sbd" : "\u{1f1f8}\u{1f1e7}" , "sos" : "\u{1f1f8}\u{1f1f4}" , "zar" : "\u{1f1ff}\u{1f1e6}" , "krw" : "\u{1f1f0}\u{1f1f7}" , "vef" : "\u{1f1fb}\u{1f1ea}" , "xdr" : "\u{1fa99}" , "lkr" : "\u{1f1f1}\u{1f1f0}" , "xlm" : "\u{1fa99}" , "sdg" : "\u{1f1f8}\u{1f1e9}" , "srd" : "\u{1f1f8}\u{1f1f7}" , "szl" : "\u{1fa99}" , "sek" : "\u{1f1f8}\u{1f1ea}" , "chf" : "\u{1f1e8}\u{1f1ed}" , "syp" : "\u{1f1f8}\u{1f1fe}" , "std" : "\u{1f1f8}\u{1f1f9}" , "trx" : "\u{1fa99}" , "tjs" : "\u{1f1f9}\u{1f1ef}" , "tzs" : "\u{1f1f9}\u{1f1ff}" , "usdt" : "\u{1fa99}" , "thb" : "\u{1f1f9}\u{1f1ed}" , "theta" : "\u{1fa99}" , "top" : "\u{1f1f9}\u{1f1f4}" , "ttd" : "\u{1f1f9}\u{1f1f9}" , "tnd" : "\u{1f1f9}\u{1f1f3}" , "try" : "\u{1f1f9}\u{1f1f7}" , "tmt" : "\u{1f1f9}\u{1f1f2}" , "ugx" : "\u{1f1fa}\u{1f1ec}" , "uah" : "\u{1f1fa}\u{1f1e6}" , "aed" : "\u{1f1e6}\u{1f1ea}" , "usd" : "\u{1f1fa}\u{1f1f8}" , "uyu" : "\u{1f1fa}\u{1f1fe}" , "uzs" : "\u{1f1fa}\u{1f1ff}" , "vuv" : "\u{1f1fb}\u{1f1fa}" , "vnd" : "\u{1f1fb}\u{1f1f3}" , "xof" : "\u{1fa99}" , "xrp" : "\u{1fa99}" , "xau" : "\u{1fa99}" , "yer" : "\u{1f1fe}\u{1f1ea}" , "zmw" : "\u{1f1ff}\u{1f1f2}" , "zmk" : "\u{1f1ff}\u{1f1f2}" , "zwl" : "\u{1f1ff}\u{1f1fc}", "xmr" : "\u{1fa99}" ]
    
    
    private lazy var pickerView: UIPickerView = {
        let obj = UIPickerView()
        obj.backgroundColor = .white
        obj.delegate = self
        obj.dataSource = self
        return obj
    }()
}


    
extension FirstScreen {
    func configRightButton() {
        let button = UIBarButtonItem(title: "OK", style: UIBarButtonItem.Style.done, target: self, action: #selector (nextScreen))
        let navigation = UIBarButtonItem(image: UIImage(named: "icons8-рядом-со-мной-50"), style: UIBarButtonItem.Style.done, target: self, action: #selector (location))
        
        navigationItem.setLeftBarButton(navigation, animated: true)
        navigationItem.setRightBarButton(button, animated: true)
        navigationItem.title = "Выберите Валюту"
        
        
    }
    
    @objc func location () {
            self.locationManager(locatorManager, didUpdateLocations: locat)
    
    }

    
    @objc func nextScreen() {
        let idRow = self.pickerView.selectedRow(inComponent: 0)
        let code = self.fullInfoOfCurrency[idRow].key
        let dictFlugs = self.dictFlugs
        let namesOfCurrency = self.namesOfCurrency
        let secondScreen = SecondScreen(code: code, dictFlugs: dictFlugs, arrayCode_Name: self.fullInfoOfCurrency, namesOfCurrency: namesOfCurrency )
        navigationController?.pushViewController(secondScreen, animated: true)
    }
   
    
   @objc func buttonToFavorites() {
       let idRow = self.pickerView.selectedRow(inComponent: 0)
       let code = self.fullInfoOfCurrency[idRow].key
       let flugs = self.dictFlugs
       let favoritesScreen = FavoritesScreen(code: code, flugs: dictFlugs, arrayCode_Name: self.fullInfoOfCurrency)
       navigationController?.present(favoritesScreen, animated: true)
      
     
    }
}

    



extension FirstScreen: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.namesOfCurrency.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.dictFlugs.keys.contains(fullInfoOfCurrency[row].key) {
            return (self.dictFlugs[fullInfoOfCurrency[row].key]! + self.fullInfoOfCurrency[row].value) }
        else {
           return ("\u{1fa99}" + self.fullInfoOfCurrency[row].value)
        }
    }
 
}

extension FirstScreen {
    func dowloadInfo() {
        
        
        let infoURL = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json"
        
        guard let url = URL(string: infoURL) else {return}
        
    AF
        .request(url)
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                guard let resultDict = data as? [String: String] else
                {return}
                let result = resultDict.sorted { element, element1 in
                    return element.value < element1.value
                }
                self.fullInfoOfCurrency = result
                UserDefaults.standard.set(data, forKey: "currenciesCodeNameArray")
                
                
                
            case .failure(let error):
                if let data = UserDefaults.standard.value(forKey: "currenciesCodeNameArray") {
                    guard let resultDict = data as? [String: String] else
                    {return}
                    let result = resultDict.sorted { element, element1 in
                        return element.value < element1.value
                    }
                    self.fullInfoOfCurrency = result
                    
                }
                else {
                    let alert = UIAlertController(title: "Не получилось загрузить данные", message: "Попробовать снова?", preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: { _ in
                        self.dowloadInfo()
                    }))
                    alert.addAction(.init(title: "Закрыть", style: .cancel, handler: { _ in
                        exit(-1)
                    }))
                    self.present(alert, animated: true)
                }
                print(error.localizedDescription)
            }
        }
    }
    func updatePickerView() {
        self.namesOfCurrency = self.fullInfoOfCurrency.map{ pair ->
            String in
            return pair.value
        }
        self.pickerView.reloadAllComponents()
    }
}



extension Locale {
    static let currency: [String: (code: String?, symbol: String?, name: String?)] = isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol, locale.localizedString(forCurrencyCode: locale.currencyCode ?? ""))
    }
}

extension FirstScreen {
    struct Connectivity {
      static let sharedInstance = NetworkReachabilityManager()!
      static var isConnectedToInternet:Bool {
          return self.sharedInstance.isReachable
        }
    }
   
}

//
//  RandomViewController.swift
//  NetKnight
//
//  Created by Admin on 8/6/18.
//  Copyright © 2018 Nordic Semiconductor ASA. All rights reserved.
//

import UIKit

class RandomViewController: UITableViewController {
    
    @IBOutlet weak var level1SwitchOutlet: UISwitch!
    @IBOutlet weak var level2SwitchOutlet: UISwitch!
    @IBOutlet weak var level3SwitchOutlet: UISwitch!
    @IBOutlet weak var level4SwitchOutlet: UISwitch!
    @IBOutlet weak var level5SwitchOutlet: UISwitch!
    @IBOutlet weak var level6SwitchOutlet: UISwitch!
    @IBOutlet weak var level7SwitchOutlet: UISwitch!
    @IBOutlet weak var level8SwitchOutlet: UISwitch!
    @IBOutlet weak var level9SwitchOutlet: UISwitch!
    @IBOutlet weak var level10SwitchOutlet: UISwitch!
    
    
    @IBOutlet weak var level1TextFieldOutlet: UITextField!
    @IBOutlet weak var level2TextFieldOutlet: UITextField!
    @IBOutlet weak var level3TextFieldOutlet: UITextField!
    @IBOutlet weak var level4TextFieldOutlet: UITextField!
    @IBOutlet weak var level5TextFieldOutlet: UITextField!
    @IBOutlet weak var level6TextFieldOutlet: UITextField!
    @IBOutlet weak var level7TextFieldOutlet: UITextField!
    @IBOutlet weak var level8TextFieldOutlet: UITextField!
    @IBOutlet weak var level9TextFieldOutlet: UITextField!
    @IBOutlet weak var level10TextFieldOutlet: UITextField!
    
    @IBOutlet weak var updateButtonOutlet: UIButton!
    
    @IBAction func onLevel1Switch(_ sender: Any) {
        checkUpdateEnable()
        if level1SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel2Switch(_ sender: Any) {
        checkUpdateEnable()
        if level2SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel3Switch(_ sender: Any) {
        checkUpdateEnable()
        if level3SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel4Switch(_ sender: Any) {
        checkUpdateEnable()
        if level4SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel5Switch(_ sender: Any) {
        checkUpdateEnable()
        if level5SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel6Switch(_ sender: Any) {
        checkUpdateEnable()
        if level6SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel7Switch(_ sender: Any) {
        checkUpdateEnable()
        if level7SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel8Switch(_ sender: Any) {
        checkUpdateEnable()
        if level8SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel9Switch(_ sender: Any) {
        checkUpdateEnable()
        if level9SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    @IBAction func onLevel10Switch(_ sender: Any) {
        checkUpdateEnable()
        if level10SwitchOutlet.isOn {
            
        } else {
            
        }
    }
    
    
    @IBAction func onTapUpdateButton(_ sender: Any) {
        if let blinkyPeripheral = blinkyPeripheral {
            var content = "";
            
            var time:Float = 0;
            if level1SwitchOutlet.isOn {
                time = Float(level1TextFieldOutlet.text!) ?? 0
                content += "{\"S\":1,\"T\":\(time)},";
            }
            if level2SwitchOutlet.isOn {
                time = Float(level2TextFieldOutlet.text!) ?? 0
                content += "{\"S\":2,\"T\":\(time)},";
            }
            if level3SwitchOutlet.isOn  {
                time = Float(level3TextFieldOutlet.text!) ?? 0
                content += "{\"S\":3,\"T\":\(time)},";
            }
            if level4SwitchOutlet.isOn  {
                time = Float(level4TextFieldOutlet.text!) ?? 0
                content += "{\"S\":4,\"T\":\(time)},";
            }
            if level5SwitchOutlet.isOn  {
                time = Float(level5TextFieldOutlet.text!) ?? 0
                content += "{\"S\":5,\"T\":\(time)},";
            }
            if level6SwitchOutlet.isOn  {
                time = Float(level6TextFieldOutlet.text!) ?? 0
                content += "{\"S\":6,\"T\":\(time)},";
            }
            if level7SwitchOutlet.isOn  {
                time = Float(level7TextFieldOutlet.text!) ?? 0
                content += "{\"S\":7,\"T\":\(time)},";
            }
            if level8SwitchOutlet.isOn  {
                time = Float(level8TextFieldOutlet.text!) ?? 0
                content += "{\"S\":8,\"T\":\(time)},";
            }
            if level9SwitchOutlet.isOn  {
                time = Float(level9TextFieldOutlet.text!) ?? 0
                content += "{\"S\":9,\"T\":\(time)},";
            }
            if level10SwitchOutlet.isOn  {
                time = Float(level10TextFieldOutlet.text!) ?? 0
                content += "{\"S\":10,\"T\":\(time)},";
            }
            content = content.substring(from: 0, to: content.count - 1)
            
            
            let command = "CMD*RM*{\"ST\":[" + content + "]}#";
            print("command", command)
            let len = command.count;
            let count = Int( ceil(Double(len) / 20.0))
            print(len, count)
            for i in 0..<count {
                
                let to = min(len, (i + 1) * 20)
                let newArray = command.substring(from: i * 20, to: to);
                if let data = newArray.data(using: .utf8) {
                    print(i*20, newArray)
                    blinkyPeripheral.writeLevel(data)
                }
            }
            
            let randomConfig =  RandomConfig()
            randomConfig.level1 = level1SwitchOutlet.isOn
            randomConfig.level2 = level2SwitchOutlet.isOn
            randomConfig.level3 = level3SwitchOutlet.isOn
            randomConfig.level4 = level4SwitchOutlet.isOn
            randomConfig.level5 = level5SwitchOutlet.isOn
            randomConfig.level6 = level6SwitchOutlet.isOn
            randomConfig.level7 = level7SwitchOutlet.isOn
            randomConfig.level8 = level8SwitchOutlet.isOn
            randomConfig.level9 = level9SwitchOutlet.isOn
            randomConfig.level10 = level10SwitchOutlet.isOn
            Preference.shared.setRandomConfig(randomConfig)
            print("connected")
            firebaseLog("Ble connected")
        } else {
            Alerts.showToastError(title: "Error", message: "Ble Not connected")
            firebaseLog("Ble not connected")
        }
    }
    
    func checkUpdateEnable() {
        let isEnable =
            level1SwitchOutlet.isOn ||
                level2SwitchOutlet.isOn ||
                level3SwitchOutlet.isOn ||
                level4SwitchOutlet.isOn ||
                level5SwitchOutlet.isOn ||
                level6SwitchOutlet.isOn ||
                level7SwitchOutlet.isOn ||
                level8SwitchOutlet.isOn ||
                level9SwitchOutlet.isOn ||
                level10SwitchOutlet.isOn
        if isEnable{
            updateButtonOutlet.enable()
        }else {
            updateButtonOutlet.disable()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        level1TextFieldOutlet.delegate = self
        level2TextFieldOutlet.delegate = self
        level3TextFieldOutlet.delegate = self
        level4TextFieldOutlet.delegate = self
        level5TextFieldOutlet.delegate = self
        level6TextFieldOutlet.delegate = self
        level7TextFieldOutlet.delegate = self
        level8TextFieldOutlet.delegate = self
        level9TextFieldOutlet.delegate = self
        level10TextFieldOutlet.delegate = self
        
        
        updateButtonOutlet.disable()
        let height = updateButtonOutlet.frame.height
        updateButtonOutlet.layer.cornerRadius = height / 4
        // Do any additional setup after loading the view.
        level1SwitchOutlet.transform()
        level2SwitchOutlet.transform()
        level3SwitchOutlet.transform()
        level4SwitchOutlet.transform()
        level5SwitchOutlet.transform()
        level6SwitchOutlet.transform()
        level7SwitchOutlet.transform()
        level8SwitchOutlet.transform()
        level9SwitchOutlet.transform()
        level10SwitchOutlet.transform()
        
        if let randomConfig = Preference.shared.getRandomConfig() {
            level1SwitchOutlet.setOn(randomConfig.level1, animated: false)
            level2SwitchOutlet.setOn(randomConfig.level2, animated: false)
            level3SwitchOutlet.setOn(randomConfig.level3, animated: false)
            level4SwitchOutlet.setOn(randomConfig.level4, animated: false)
            level5SwitchOutlet.setOn(randomConfig.level5, animated: false)
            level6SwitchOutlet.setOn(randomConfig.level6, animated: false)
            level7SwitchOutlet.setOn(randomConfig.level7, animated: false)
            level8SwitchOutlet.setOn(randomConfig.level8, animated: false)
            level9SwitchOutlet.setOn(randomConfig.level9, animated: false)
            level10SwitchOutlet.setOn(randomConfig.level10, animated: false)
         
            checkUpdateEnable()
            firebaseLog("randomViewOnCreate")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.white
    }
}

extension RandomViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else {
            return true
        }
        text = text + string
        print(text)
        guard let num = Float(text) else {
            return false
        }
        if num >= 0 && num < 256 {
            return true
        } else {
            let index3 = text.index(text.endIndex, offsetBy: -2)
            let subText = text[index3...]
            textField.text = String(subText)
        }
        return false
    }
    
}
extension Float {
    func splitAtDecimal() -> [UInt8] {
        let strNum = String(self)
        let arr = strNum.components(separatedBy: ".")
        var arrInt = [UInt8]()
        if let first = arr.first {
            guard let intFirst = Int(first) else {
                return []
            }
            if intFirst < 256 {
                arrInt.append(UInt8(intFirst))
            } else {
                return []
            }
        }
        
        if arr.count > 1 {
            let second = arr[1]
            guard let intSecond = Int(second) else {
                return arrInt
            }
            if intSecond < 256 {
                arrInt.append(UInt8(intSecond))
            } else{
                let index3 = second.index(second.startIndex, offsetBy: 1)
                let subText = String(second[...index3])
                print(subText)
                guard let number = UInt8(subText) else {
                    return arrInt
                }
                arrInt.append(number)
            }
            
        }
        
        return arrInt
    }
}

extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }
    
    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}

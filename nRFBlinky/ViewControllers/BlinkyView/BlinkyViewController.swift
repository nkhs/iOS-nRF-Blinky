//
//  BlinkyViewController.swift
//  nRFBlinky
//
//  Created by Mostafa Berg on 01/12/2017.
//  Copyright © 2017 Nordic Semiconductor ASA. All rights reserved.
//

import UIKit
import CoreBluetooth

class BlinkyViewController: UIViewController, CBCentralManagerDelegate {
    
    //MARK: - Outlets and Actions
    
    @IBAction func switchChanged(_ sender: Any) {
        isChecked = toggleSwitch.isOn
        updateButton(true)
    }
    
    @IBOutlet weak var randomSwitch: UISwitch!
    @IBOutlet weak var randomBtnOutlet: UIButton!
    @IBOutlet weak var toggleSwitch: UISwitch!
    @IBOutlet weak var labelOutlet: UILabel!
    
    @IBOutlet weak var btnLevelOutlet: UIButton!
    
    var isChecked = false
    var isCheckedRandom = false
    
    func updateButton(_ isUpdate:Bool = false, _ fromButton:Bool = false){
        if isChecked {
            if blinkyPeripheral != nil && isUpdate {
                //                blinkyPeripheral.writeMode(0x1)
            }
            if fromButton {
                toggleSwitch.setOn(true, animated: false)
            }
            randomBtnOutlet.disable()
            randomSwitch.isEnabled = false
        } else {
            if blinkyPeripheral != nil && isUpdate {
                if let cmd = self.getCommandWithLevel(0) {
                    blinkyPeripheral.writeLevel(cmd)
                }
            }
            
            if fromButton {
                toggleSwitch.setOn(false, animated: false)
            }
            randomBtnOutlet.enable()
            randomSwitch.isEnabled = true
        }
    }
    
    func updateRandomButton(_ isUpdate:Bool = false, _ fromButton:Bool = false){
        if isCheckedRandom {
            if blinkyPeripheral != nil && isUpdate {
                //                blinkyPeripheral.writeMode(0x3)
            }
            toggleSwitch.isEnabled = false
            toggleSwitch.setOn(false, animated: false)
            btnLevelOutlet.disable()
            
            if fromButton {
                randomSwitch.setOn(true, animated: false)
            }
        }else {
            if blinkyPeripheral != nil && isUpdate {
                //                blinkyPeripheral.writeMode(0x4)
            }
            
            toggleSwitch.isEnabled = true
            btnLevelOutlet.enable()
            
            if fromButton {
                randomSwitch.setOn(false, animated: false)
            }
            
        }
    }
    
    @IBAction func onTapLevel(_ sender: Any) {
        showLevelList()
    }
    @IBAction func onToggleRandomStart(_ sender: Any) {
        print("Random1", randomSwitch.isOn)
    }
    @IBAction func randomSwitchChanged(_ sender: Any) {
        isCheckedRandom = randomSwitch.isOn
        updateRandomButton(true)
        print("Random2", randomSwitch.isOn)
    }
    
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private var hapticGenerator : NSObject? //Only available on iOS 10 and above
    
    private var centralManager : CBCentralManager!
    
    //MARK: - Implementation
    public func setCentralManager(_ aManager: CBCentralManager) {
        centralManager = aManager
        centralManager.delegate = self
    }
    
    public func setPeripheral(_ aPeripheral: BlinkyPeripheral) {
        let peripheralName = aPeripheral.advertisedName ?? "Unknown Device"
        title = peripheralName
        blinkyPeripheral = aPeripheral
        print("connecting to blinky")
        centralManager.connect(blinkyPeripheral.basePeripheral, options: nil)
    }
    
    private func showLevelList() {
        let alert = UIAlertController(title: "Level", message: "Please Choose level", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Level 1", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 1", for:.normal)
            if let cmd = self.getCommandWithLevel(1) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 2", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 2", for:.normal)
            if let cmd = self.getCommandWithLevel(2) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 3", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 3", for:.normal)
            if let cmd = self.getCommandWithLevel(3) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 4", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 4", for:.normal)
            if let cmd = self.getCommandWithLevel(4) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 5", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 5", for:.normal)
            if let cmd = self.getCommandWithLevel(5) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 6", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 6", for:.normal)
            if let cmd = self.getCommandWithLevel(6) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 7", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 7", for:.normal)
            if let cmd = self.getCommandWithLevel(7) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 8", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 8", for:.normal)
            if let cmd = self.getCommandWithLevel(8) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 9", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 9", for:.normal)
            
            if let cmd = self.getCommandWithLevel(9) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        alert.addAction(UIAlertAction(title: "Level 10", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 10", for:.normal)
            if let cmd = self.getCommandWithLevel(10) {
                blinkyPeripheral.writeLevel(cmd)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    func getCommandWithLevel(_ level:Int) -> Data! {
        return ("CMD*MM*{\"S\":\(level)}#").data(using: .utf8)
    }
    private func setupDependencies() {
        //This will run on iOS 10 or above
        //and will generate a tap feedback when the button is tapped on the Dev kit.
        prepareHaptics()
        
        //Set default text to Reading ...
        //As soon as peripheral enables notifications the values will be notified
        
        
        print("adding button notification and led write callback handlers")
        blinkyPeripheral.setModeCallback { (modeData) -> (Void) in
            guard let dataStr = String(data: modeData, encoding: String.Encoding.utf8) else{
                return
            }
            DispatchQueue.main.async {
                if dataStr.contains("MM*") {
                    self.isChecked = true
                    self.updateButton(false, true)
//                    CMD*MM*{"S":1}#
                    var level = dataStr.replacingOccurrences(of: "CMD*MM*{\"S\":", with: "")
                    level = level.replacingOccurrences(of: "}#", with: "")
                    
                    guard let levelInt = Int(level) else{
                        return
                    }
                    self.btnLevelOutlet.setTitle("Level \(levelInt)", for:.normal)
                }
                if dataStr.contains("RM*"){
                    self.isChecked = false
                    self.updateButton(false, true)
                }
            }
        }
        
        blinkyPeripheral.setLevelCallback { (level) -> (Void) in
            DispatchQueue.main.async {
                self.btnLevelOutlet.setTitle("Level \(level)", for: .normal)
            }
        }
    }
    
    private func roundButton(_ button:UIButton){
        let height = button.frame.height
        button.layer.cornerRadius = height / 4
    }
    
    
    //MARK: - UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roundButton(btnLevelOutlet)
        roundButton(randomBtnOutlet)
        toggleSwitch.transform(isZoom:true)
        
        randomSwitch.transform(isZoom:true)
        
        
        guard blinkyPeripheral != nil else {
            return
        }
        guard blinkyPeripheral.basePeripheral.state != .connected else {
            //View is coming back from a swipe, everything is already setup
            return
        }
        //This is the first time view appears, setup the subviews and dependencies
        setupDependencies()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("removing button notification and led write callback handlers")
        //        blinkyPeripheral.removeLEDCallback()
        //        blinkyPeripheral.removeButtonCallback()
        //
        //        if blinkyPeripheral.basePeripheral.state == .connected {
        //            centralManager.cancelPeripheralConnection(blinkyPeripheral.basePeripheral)
        //        }
        firebaseLog("blinkViewOnCreate")
        super.viewDidDisappear(animated)
    }
    
    //MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == blinkyPeripheral.basePeripheral {
            print("connected to blinky.")
            blinkyPeripheral.discoverBlinkyServices()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == blinkyPeripheral.basePeripheral {
            print("blinky disconnected.")
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func prepareHaptics() {
        if #available(iOS 10.0, *) {
            hapticGenerator = UIImpactFeedbackGenerator(style: .heavy)
            (hapticGenerator as? UIImpactFeedbackGenerator)?.prepare()
        }
    }
    private func buttonTapHapticFeedback() {
        if #available(iOS 10.0, *) {
            (hapticGenerator as? UIImpactFeedbackGenerator)?.impactOccurred()
        }
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
    func selected(){
        backgroundColor = UIColor(rgb: 0x3CC5EF).darker()
    }
    func unselected(){
        backgroundColor = UIColor(rgb: 0x3CC5EF)
    }
    func enable(){
        isEnabled = true
        backgroundColor = UIColor(rgb: 0x3CC5EF)
    }
    func disable(){
        isEnabled = false
        backgroundColor = UIColor(rgb: 0xB7B7B7)
    }
}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

extension UISwitch {
    func transform(isZoom:Bool = false){
        tintColor = UIColor(rgb:0xB7B7B7)
        layer.cornerRadius = 16
        backgroundColor = UIColor(rgb:0xB7B7B7)
        if isZoom {
            transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
}

var blinkyPeripheral : BlinkyPeripheral!

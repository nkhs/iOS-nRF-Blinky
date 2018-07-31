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
    
    @IBOutlet weak var toggleBtnOutlet: UIButton!
    @IBOutlet weak var btnLevelOutlet: UIButton!
    @IBOutlet weak var toggleRandomBtnOutlet: UIButton!
    
    var isChecked = false
    var isCheckedRandom = false
    
    @IBAction func onToggleStart(_ sender: Any) {
        isChecked = !isChecked
        if isChecked {
            if blinkyPeripheral != nil {
                self.blinkyPeripheral.writeMode(0x1)
            }
            toggleBtnOutlet.setTitle("Manual Stop", for:.highlighted)
            toggleRandomBtnOutlet.isEnabled = false
            toggleRandomBtnOutlet.backgroundColor = UIColor.init(red: 0xB7 / 0xFF, green:  0xB7 / 0xFF, blue:  0xB7 / 0xFF, alpha: 1)
        } else {
            if blinkyPeripheral != nil {
                self.blinkyPeripheral.writeMode(0x2)
            }
            toggleBtnOutlet.setTitle("Manual Start", for:.normal)
            toggleRandomBtnOutlet.isEnabled = true
            toggleRandomBtnOutlet.backgroundColor = UIColor.init(red: 0x15 / 0xFF, green:  0x9B / 0xFF, blue:  0xE1 / 0xFF, alpha: 1)
        }
    }
    
    @IBAction func onTapLevel(_ sender: Any) {
        showLevelList()
    }
    @IBAction func onToggleRandomStart(_ sender: Any) {
        isCheckedRandom = !isCheckedRandom
        if isCheckedRandom {
            if blinkyPeripheral != nil {
                self.blinkyPeripheral.writeMode(0x3)
            }
            toggleBtnOutlet.isEnabled = false
            toggleBtnOutlet.backgroundColor = UIColor.init(red: 0xB7 / 0xFF, green:  0xB7 / 0xFF, blue:  0xB7 / 0xFF, alpha: 1)
            
            btnLevelOutlet.isEnabled = false
            btnLevelOutlet.backgroundColor = UIColor.init(red: 0xB7 / 0xFF, green:  0xB7 / 0xFF, blue:  0xB7 / 0xFF, alpha: 1)
            
            toggleRandomBtnOutlet.setTitle("Random Stop", for:.highlighted)
        }else {
            if blinkyPeripheral != nil {
                self.blinkyPeripheral.writeMode(0x4)
            }
            
            toggleBtnOutlet.isEnabled = true
            toggleBtnOutlet.backgroundColor = UIColor.init(red: 0x15 / 0xFF, green:  0x9B / 0xFF, blue:  0xE1 / 0xFF, alpha: 1)
            
            btnLevelOutlet.isEnabled = true
            btnLevelOutlet.backgroundColor = UIColor.init(red: 0x15 / 0xFF, green:  0x9B / 0xFF, blue:  0xE1 / 0xFF, alpha: 1)
            
            toggleRandomBtnOutlet.setTitle("Random Start", for:.normal)
        }
    }
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private var hapticGenerator : NSObject? //Only available on iOS 10 and above
    private var blinkyPeripheral : BlinkyPeripheral!
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
            self.blinkyPeripheral.writeLevel(0x1)
        }))
        alert.addAction(UIAlertAction(title: "Level 2", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 2", for:.normal)
            self.blinkyPeripheral.writeLevel(0x2)
        }))
        alert.addAction(UIAlertAction(title: "Level 3", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 3", for:.normal)
            self.blinkyPeripheral.writeLevel(0x3)
        }))
        alert.addAction(UIAlertAction(title: "Level 4", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 4", for:.normal)
            self.blinkyPeripheral.writeLevel(0x4)
        }))
        alert.addAction(UIAlertAction(title: "Level 5", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 5", for:.normal)
            self.blinkyPeripheral.writeLevel(0x5)
        }))
        alert.addAction(UIAlertAction(title: "Level 6", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 6", for:.normal)
            self.blinkyPeripheral.writeLevel(0x6)
        }))
        alert.addAction(UIAlertAction(title: "Level 7", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 7", for:.normal)
            self.blinkyPeripheral.writeLevel(0x7)
        }))
        alert.addAction(UIAlertAction(title: "Level 8", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 8", for:.normal)
            self.blinkyPeripheral.writeLevel(0x8)
        }))
        alert.addAction(UIAlertAction(title: "Level 9", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 9", for:.normal)
            self.blinkyPeripheral.writeLevel(0x9)
        }))
        alert.addAction(UIAlertAction(title: "Level 10", style: .default, handler: { (action) in
            self.btnLevelOutlet.setTitle("Level 10", for:.normal)
            self.blinkyPeripheral.writeLevel(0xa)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupDependencies() {
        //This will run on iOS 10 or above
        //and will generate a tap feedback when the button is tapped on the Dev kit.
        prepareHaptics()
        
        //Set default text to Reading ...
        //As soon as peripheral enables notifications the values will be notified
        
        
        print("adding button notification and led write callback handlers")
        blinkyPeripheral.setButtonCallback { (isPressed) -> (Void) in
            DispatchQueue.main.async {
                if isPressed {
//                    self.buttonStateLabel.text = "PRESSED"
                } else {
//                    self.buttonStateLabel.text = "RELEASED"
                }
                self.buttonTapHapticFeedback()
            }
        }
        
        blinkyPeripheral.setLEDCallback { (isOn) -> (Void) in
            DispatchQueue.main.async {
                
            }
        }
    }
    
    private func roundButton(_ button:UIButton){
//        button.backgroundColor = .clear
        let height = button.frame.height
        button.layer.cornerRadius = height / 4
        
//        button.backgroundColor = [UIColor colorWithRed:(200.0f/255.0f) green:0.0 blue:0.0 alpha:1.0];
        
//        button.layer.cornerRadius = 3.0;
        
//        button.layer.borderWidth = 2.0;
//        button.layer.borderColor = [[UIColor clearColor] CGColor];
        
//        button.layer.shadowColor = UIColor.init(red: 100 / 0xFF, green:  0x00 / 0xFF, blue:  0x00 / 0xFF, alpha: 1).cgColor
//        button.layer.shadowOpacity = 1.0
//        button.layer.shadowRadius = 1.0
//        button.layer.shadowOffset = CGSize(width:0, height:3)
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.black.cgColor
    }

    
    //MARK: - UIViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        roundButton(toggleBtnOutlet)
        roundButton(btnLevelOutlet)
        roundButton(toggleRandomBtnOutlet)
        
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
        blinkyPeripheral.removeLEDCallback()
        blinkyPeripheral.removeButtonCallback()
        
        if blinkyPeripheral.basePeripheral.state == .connected {
            centralManager.cancelPeripheralConnection(blinkyPeripheral.basePeripheral)
        }
        
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

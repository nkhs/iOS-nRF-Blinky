//
//  BlinkyPeripheral.swift
//  nRFBlinky
//
//  Created by Mostafa Berg on 28/11/2017.
//  Copyright © 2017 Nordic Semiconductor ASA. All rights reserved.
//

import UIKit
import CoreBluetooth

class BlinkyPeripheral: NSObject, CBPeripheralDelegate {
    //MARK: - Blinky services and charcteristics Identifiers
    //
    
    public static let nordicBlinkyServiceUUID  = CBUUID.init(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
    public static let modeNotifyCharacteristicUUID = CBUUID.init(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")
    public static let levelCharacteristicUUID    = CBUUID.init(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")
    
    //MARK: - Properties
    //
    public private(set) var basePeripheral      : CBPeripheral
    public private(set) var advertisedName      : String?
    public private(set) var RSSI                : NSNumber
    public private(set) var advertisedServices  : [CBUUID]?
    
    //MARK: - Callback handlers
    private var levelCallbackHandler : ((UInt8) -> (Void))?
    private var modeChangedHandler : ((Data) -> (Void))?
    
    //MARK: - Services and Characteristic properties
    //
    private             var blinkyService       : CBService?
    
    private             var levelCharacteristic   : CBCharacteristic?
    private             var modeNotifyCharacteristic   : CBCharacteristic?
    
    
    init(withPeripheral aPeripheral: CBPeripheral, advertisementData anAdvertisementDictionary: [String : Any], andRSSI anRSSI: NSNumber) {
        basePeripheral = aPeripheral
        RSSI = anRSSI
        super.init()
        (advertisedName, advertisedServices) = parseAdvertisementData(anAdvertisementDictionary)
        basePeripheral.delegate = self
    }
    
    public func setLevelCallback(aCallbackHandler: @escaping (UInt8) -> (Void)){
        levelCallbackHandler = aCallbackHandler
    }
    
    public func setModeCallback(aCallbackHandler: @escaping (Data) -> (Void)) {
        modeChangedHandler = aCallbackHandler
    }
    
    public func removeButtonCallback() {
        modeChangedHandler = nil
    }
    
    public func removeLEDCallback() {
        levelCallbackHandler = nil
    }
    
    public func discoverBlinkyServices() {
        print("Discovering blinky service")
        basePeripheral.delegate = self
        basePeripheral.discoverServices([BlinkyPeripheral.nordicBlinkyServiceUUID])
    }
    
    public func discoverCharacteristicsForBlinkyService(_ aService: CBService) {
        basePeripheral.discoverCharacteristics([BlinkyPeripheral.levelCharacteristicUUID,
                                                BlinkyPeripheral.modeNotifyCharacteristicUUID,
                                                ],
                                               for: aService)
    }
    
    public func enableNotifications(_ characteristic: CBCharacteristic) {
        print("Enabling notifications for characteristic")
        basePeripheral.setNotifyValue(true, for: characteristic)
    }
    
    public func readLevel() {
        if let levelCharacteristic = levelCharacteristic {
            basePeripheral.readValue(for: levelCharacteristic)
        }
    }
    
    public func didReceiveLevelValue(_ aValue: Data) {
        if aValue.count == 0 {
            print("received 0")
            return
        }
        print("level value received \(aValue[0])")
//        levelCallbackHandler?(aValue[0])
        
    }
    
    public func didReceiveModeNotificationWithValue(_ aValue: Data) {
//        print("Button value changed to: \(aValue[0])")
        modeChangedHandler?(aValue)
    }
    
    public func writeLevel(_ byte:Data) {
        writeLevelCharcateristicValue(byte)
    }
    
    private func writeLevelCharcateristicValue(_ aValue: Data) {
        guard let levelCharacteristic = levelCharacteristic else {
            print("Level characteristic is not present, nothing to be done")
            return
        }
        basePeripheral.writeValue(aValue, for: levelCharacteristic, type: .withResponse)
    }
    
    private func parseAdvertisementData(_ anAdvertisementDictionary: [String : Any]) -> (String?, [CBUUID]?) {
        var advertisedName: String
        var advertisedServices: [CBUUID]
        
        if let name = anAdvertisementDictionary[CBAdvertisementDataLocalNameKey] as? String{
            advertisedName = name
        } else {
            advertisedName = "N/A"
        }
        if let services = anAdvertisementDictionary[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            advertisedServices = services
        } else {
            advertisedServices = [CBUUID]()
        }
        
        return (advertisedName, advertisedServices)
    }
    
    //MARK: - NSObject protocols
    override func isEqual(_ object: Any?) -> Bool {
        if object is BlinkyPeripheral {
            let peripheralObject = object as! BlinkyPeripheral
            return peripheralObject.basePeripheral.identifier == basePeripheral.identifier
        } else if object is CBPeripheral {
            let peripheralObject = object as! CBPeripheral
            return peripheralObject.identifier == basePeripheral.identifier
        } else {
            return false
        }
    }
    
    //MARK: - CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic == modeNotifyCharacteristic {
            if let aValue = characteristic.value {
                didReceiveModeNotificationWithValue(aValue)
            }
        } else if characteristic == levelCharacteristic {
            if let aValue = characteristic.value {
                guard let dataStr = String(data: aValue, encoding: String.Encoding.utf8) else{
                    return
                }
                print("dataStr", dataStr)
//                didReceiveLevelValue(aValue)
                didReceiveModeNotificationWithValue(aValue)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == modeNotifyCharacteristic?.uuid {
            print("Notification state is now \(characteristic.isNotifying) for Button characteristic")
            
            readLevel()
        } else {
            print("Notification state is now \(characteristic.isNotifying) for an unknown characteristic with UUID: \(characteristic.uuid.uuidString)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for aService in services {
                if aService.uuid == BlinkyPeripheral.nordicBlinkyServiceUUID {
                    print("Discovered Blinky service!")
                    //Capture and discover all characteristics for the blinky service
                    blinkyService = aService
                    discoverCharacteristicsForBlinkyService(blinkyService!)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if service == blinkyService {
            print("Discovered characteristics for blinky service")
            if let characteristics = service.characteristics {
                for aCharacteristic in characteristics {
                    if aCharacteristic.uuid == BlinkyPeripheral.levelCharacteristicUUID {
                        firebaseLog("ble ch: Discovered Blinky LED characteristic")
                        levelCharacteristic = aCharacteristic
                        enableNotifications(levelCharacteristic!)
                    } else if aCharacteristic.uuid == BlinkyPeripheral.modeNotifyCharacteristicUUID {
                        firebaseLog("ble ch: Discovered Blinky modeNotifyCharacteristicUUID characteristic")
                        modeNotifyCharacteristic = aCharacteristic
                        enableNotifications(modeNotifyCharacteristic!)
                    }
                }
            }
        } else {
            print("Discovered characteristics for an unnknown service with UUID: \(service.uuid.uuidString)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic == levelCharacteristic {
            peripheral.readValue(for: levelCharacteristic!)
        }
        firebaseLog("DidWriteValueFor" + characteristic.uuid.uuidString)
        if let error = error {
            firebaseLog("DidWriteValueFor " + characteristic.uuid.uuidString + " error: " + error.localizedDescription)
        }
    }
}

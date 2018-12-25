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
    public static let nordicBlinkyServiceUUID  = CBUUID.init(string: "00001207-0000-1000-8000-00805f9b34fb")
    public static let modeCharacteristicUUID = CBUUID.init(string: "00001208-0000-1000-8000-00805f9b34fb")
    public static let modeNotifyCharacteristicUUID = CBUUID.init(string: "00001210-0000-1000-8000-00805f9b34fb")
    public static let levelCharacteristicUUID    = CBUUID.init(string: "00001209-0000-1000-8000-00805f9b34fb")
    public static let randomCharacteristicUUID    = CBUUID.init(string: "00001211-0000-1000-8000-00805f9b34fb")
    
//        public static let nordicBlinkyServiceUUID  = CBUUID.init(string: "00001975-0000-1000-8000-00805f9b34fb")
//        public static let modeCharacteristicUUID = CBUUID.init(string: "00001006-0000-1000-8000-00805f9b34fb")
//        public static let modeNotifyCharacteristicUUID = CBUUID.init(string: "00001007-0000-1000-8000-00805f9b34fb")
//        public static let levelCharacteristicUUID    = CBUUID.init(string: "00001003-0000-1000-8000-00805f9b34fb")
//        public static let randomCharacteristicUUID    = CBUUID.init(string: "00001002-0000-1000-8000-00805f9b34fb")
    
    //MARK: - Properties
    //
    public private(set) var basePeripheral      : CBPeripheral
    public private(set) var advertisedName      : String?
    public private(set) var RSSI                : NSNumber
    public private(set) var advertisedServices  : [CBUUID]?
    
    //MARK: - Callback handlers
    private var levelCallbackHandler : ((UInt8) -> (Void))?
    private var modeChangedHandler : ((UInt8) -> (Void))?

    //MARK: - Services and Characteristic properties
    //
    private             var blinkyService       : CBService?
    private             var modeCharacteristic: CBCharacteristic?
    private             var levelCharacteristic   : CBCharacteristic?
    private             var modeNotifyCharacteristic   : CBCharacteristic?
    private             var randomWriteCharacteristic   : CBCharacteristic?
    

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

    public func setModeCallback(aCallbackHandler: @escaping (UInt8) -> (Void)) {
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
        basePeripheral.discoverCharacteristics([BlinkyPeripheral.modeCharacteristicUUID,
                                            BlinkyPeripheral.levelCharacteristicUUID,
                                            BlinkyPeripheral.modeNotifyCharacteristicUUID,
                                            BlinkyPeripheral.randomCharacteristicUUID
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
    
    public func readMode() {
        if let modeCharacteristic = modeCharacteristic {
            basePeripheral.readValue(for: modeCharacteristic)
        }
    }

    public func didReceiveLevelValue(_ aValue: Data) {
        print("level value received \(aValue[0])")
        levelCallbackHandler?(aValue[0])
       
    }
    
    public func didReceiveModeNotificationWithValue(_ aValue: Data) {
        print("Button value changed to: \(aValue[0])")
        modeChangedHandler?(aValue[0])
    }
    
    public func writeLevel(_ byte:UInt8) {
        writeLevelCharcateristicValue(Data([byte]))
    }
    
    private func writeLevelCharcateristicValue(_ aValue: Data) {
        guard let levelCharacteristic = levelCharacteristic else {
            print("Level characteristic is not present, nothing to be done")
            return
        }
        basePeripheral.writeValue(aValue, for: levelCharacteristic, type: .withResponse)
    }
    
    public func writeMode(_ byte:UInt8) {
        writeModeCharcateristicValue(Data([byte]))
    }
    
    public func writeRandom(_ arrByte:[UInt8]) {
        firebaseLog("-- writing random")
        guard let randomCharacteristic = randomWriteCharacteristic else {
            firebaseLog("Mode characteristic is not present, nothing to be done")
            return
        }
        
        firebaseLog(" -- call write random " + randomCharacteristic.uuid.uuidString)
        let hexaString = arrByte.map{String(format: "%02X,", $0)}.joined()
        firebaseLog(hexaString)
        basePeripheral.writeValue(Data(arrByte), for: randomCharacteristic, type: .withResponse)
    }
    
    private func writeModeCharcateristicValue(_ aValue: Data) {
        guard let modeCharacteristic = modeCharacteristic else {
            print("Mode characteristic is not present, nothing to be done")
            return
        }
        basePeripheral.writeValue(aValue, for: modeCharacteristic, type: .withResponse)
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
                didReceiveLevelValue(aValue)
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == modeCharacteristic?.uuid {
            print("Notification state is now \(characteristic.isNotifying) for Button characteristic")
            readMode()
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
                    if aCharacteristic.uuid == BlinkyPeripheral.modeCharacteristicUUID {
                        firebaseLog("ble ch: Discovered Blinky button characteristic")
                        modeCharacteristic = aCharacteristic
//                        enableNotifications(modeCharacteristic!)
                    } else if aCharacteristic.uuid == BlinkyPeripheral.levelCharacteristicUUID {
                        firebaseLog("ble ch: Discovered Blinky LED characteristic")
                        levelCharacteristic = aCharacteristic
                        enableNotifications(levelCharacteristic!)
                    } else if aCharacteristic.uuid == BlinkyPeripheral.modeNotifyCharacteristicUUID {
                        firebaseLog("ble ch: Discovered Blinky modeNotifyCharacteristicUUID characteristic")
                        modeNotifyCharacteristic = aCharacteristic
                        enableNotifications(modeNotifyCharacteristic!)
                    } else if aCharacteristic.uuid == BlinkyPeripheral.randomCharacteristicUUID {
                        firebaseLog("ble ch: Discovered randomCH")
                        randomWriteCharacteristic = aCharacteristic
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

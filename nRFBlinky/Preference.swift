//
//  Preference.swift
//  NetKnight
//
//  Created by Admin on 8/15/18.
//  Copyright © 2018 Nordic Semiconductor ASA. All rights reserved.
//

import Foundation
//
//  Preference.swift
//  CalmSide
//
//  Created by Admin on 2018/5/3.
//  Copyright © 2018 admin. All rights reserved.
//

import DefaultsKit

class Preference {
    static let shared = Preference()
    
    static let PAIRED_DEVICE_INFO_KEY = "RANDOM_CONFIGV2"
    
    // MARK: Paired Device Info preferences
    
    func getRandomConfig() -> RandomConfig! {
        let info = Key<RandomConfig>(Preference.PAIRED_DEVICE_INFO_KEY)
        if let deviceInfo = Defaults.shared.get(for: info) {
            return deviceInfo
        }
        return nil
    }
    
    func setRandomConfig(_ device: RandomConfig) {
        let info = Key<RandomConfig>(Preference.PAIRED_DEVICE_INFO_KEY)
        Defaults.shared.set(device, for: info)
    }
    
    func unsetPairedDevice() {
        let deviceInfoKey = Key<RandomConfig>(Preference.PAIRED_DEVICE_INFO_KEY)
        Defaults.shared.clear(deviceInfoKey)
    }
}

class RandomConfig: Codable {
    var level1 = false
    var level2 = false
    var level3 = false
    var level4 = false
    var level5 = false
    var level6 = false
    var level7 = false
    var level8 = false
    var level9 = false
    var level10 = false
    var min:Float = 0
    var max:Float = 0
    init() {
        
    }
}

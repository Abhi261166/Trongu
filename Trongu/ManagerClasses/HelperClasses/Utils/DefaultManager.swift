//
//  DefaultManager.swift
//  Dannah
//
//  Created by Admin on 03/05/22.
//

import UIKit

final class DefaultManager: UserDefaults {
    
    static var shared = DefaultManager()
    
    public struct SessionKeys {
        static let lat: String = "lat"
        static let long: String = "long"
        static let isNew: String = "newUser"
        
    }
    
    var lat: String? {
        get {
            guard let lat = DefaultManager.shared.object(forKey: SessionKeys.lat) as? String else { return nil }
            return lat
        }
        set(newValue) {
            DefaultManager.shared.set(newValue, forKey: SessionKeys.lat)
            DefaultManager.shared.synchronize()
        }
    }
    var long: String? {
        get {
            guard let long = DefaultManager.shared.object(forKey: SessionKeys.long) as? String else { return nil }
            return long
        }
        set(newValue) {
            DefaultManager.shared.set(newValue, forKey: SessionKeys.long)
            DefaultManager.shared.synchronize()
        }
    }
    var isNew: String? {
        get {
            guard let isNew = DefaultManager.shared.object(forKey: SessionKeys.isNew) as? String else { return nil }
            return isNew
        }
        set(newValue) {
            DefaultManager.shared.set(newValue, forKey: SessionKeys.isNew)
            DefaultManager.shared.synchronize()
        }
    }
    
}

//
//  Array+Custom.swift
//  Wedswing
//
//  Created by Nitin Kumar on 27/06/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit


extension Array {
    
    var jsonString: String {
        do {
            let dataObject:Data? = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            if let data = dataObject {
                let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                if let json = json {
                    return json as String
                }
            }
        } catch {
            print("Error")
        }
        return ""
    }
    
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
//    func filterDuplicates(@noescape includeElement : ( _ lhs:Element, _ rhs:Element)->Bool) -> [Element] {
//        var results = [Element]()
//        forEach { (element) in
//            let existingElements = results.filter {
//                return includeElement(element, $0)
//            }
//            if existingElements.count == 0 {
//                results.append(element)
//            }
//        }
//        return results
//    }
    
}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
    
    func remove(element:Element) -> [Element] {
        var result = [Element]()
        for value in self {
            if value != element {
                result.append(value)
            }
        }
        return result
    }
    
    mutating func removeElement(_ element:Element) {
        var result = [Element]()
        for value in self {
            if value != element {
                result.append(value)
            }
        }
        self = result
    }
    
    
}


public extension Sequence where Element: Hashable {
    var firstUniqueElements: [Element] {
        var set: Set<Element> = []
        return filter { set.insert($0).inserted }
    }
    
//    var firstUniqueElements: [Element] {
//        var set: Set<Element> = []
//        return filter { set.insert($0).inserted }
//    }
    
}

extension Dictionary {
    var stringValues: [String] {
        var values = [String]()
        self.values.forEach { value in
            if let val = value as? String {
                values.append(val)
            }
        }
        return values
    }
    
//    var filter: Void {
//        if var json = (self as? [String:Any?]) {
//            json = json.filter{($0.1 != nil)}
//        }
//    }
    
}



extension Dictionary {
    
    var isNotEmpty: Bool {
        return !isEmpty
    }
    
}

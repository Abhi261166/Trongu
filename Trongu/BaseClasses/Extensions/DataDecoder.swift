//
//  DataDecoder.swift
//  Clout Lyfe
//
//  Created by mac on 27/04/22.
//

import UIKit


class DataDecoder: NSObject {
    
    class func decodeData<T>(_ data: Data?, type: T.Type) -> T? where T : Codable {
        guard let data = data else {
            return nil
        }
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(type.self, from: data)
            print("decodedData:-\(decodedData) **** \(data.count)")
            return decodedData
        } catch {
            print("error***** \(error)")
            return nil
        }
    }
    
//    class func decodeData<T>(_ data: Data?, type: T.Type) -> T? where T : Decodable {
//        guard let data = data else {
//            return nil
//        }
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(type.self, from: data)
//            return decodedData
//        } catch {
//            return nil
//        }
//    }
    

}

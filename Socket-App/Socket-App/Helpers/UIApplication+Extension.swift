//
//  UIApplication+Extension.swift
//  Socket-App
//
//  Created by Marcus Vinicius Vieira Badiale on 12/07/21.
//

import UIKit

extension UIApplication {
    static func jsonString(from object: Any) -> String? {
        guard let data = jsonData(from: object) else {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func jsonData(from object: Any) -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        
        return data
    }
}

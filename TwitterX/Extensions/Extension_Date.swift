//
//  Extension_Date.swift
//  TwitterX
//
//  Created by Piyush Kant on 2021/03/07.
//

import Foundation

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

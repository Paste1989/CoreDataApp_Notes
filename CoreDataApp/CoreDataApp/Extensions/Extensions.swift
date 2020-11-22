//
//  Extensions.swift
//  CoreDataApp
//
//  Created by SS on 21.11.2020..
//

import Foundation
import UIKit


extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}


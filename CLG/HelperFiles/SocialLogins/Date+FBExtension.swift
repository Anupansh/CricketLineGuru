//
//  Date+FBExtension.swift
//  Extras
//
//  Created by Anmol's Macbook Air on 03/07/18.
//  Copyright © 2018 Girijesh Kumar. All rights reserved.
//

import Foundation

struct DateFormat
{
    static let shortDateFormat = "dd.MM.yyyy"
    static let fullDateFormat  = "HH:mm dd.MM.yyyy"
    static let onlyTimeFormat  = "HH a"
    static let exactTimeFormat = "HH:mm"
    static let onlyDay         = "EEEE"
    static let dayOfMonth      = "dd MMM"
    static let dayOfYear       = "dd MMM, yyyy"
    static let monthOfYear     = "MMMM yyyy"
    static let apiDate         = "yyyy-MM-dd"
    static let fbApiDate       = "MM/dd/yyyy"
    static let apiTime         = "HH:mm:ss"
    static let apiDateTime     = "yyyy-MM-dd HH:mm:ss"
    static let apiPostDateTime = "dd.MM.yyyy HH:mm:ss"
    static let apiDateTimeZone = "yyyy-MM-dd HH:mm:ss ZZZ"
}

extension Date {
    
    // MARK: - Static Functions
    
    static func convertFBDateString(dateString: String) -> Date {
        
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = DateFormat.fbApiDate
        let convertedDate = dateFormatter.date(from: dateString)
        return convertedDate!
    }
    
    // MARK: - Instance Methods
    
    func userAge() -> Int {
        
        let units:NSCalendar.Unit = [.year]
        let calendar = NSCalendar.current as NSCalendar
        calendar.timeZone = NSTimeZone.default
        calendar.locale = NSLocale.current
        let components = calendar.components(units, from: self, to: Date(), options: NSCalendar.Options.wrapComponents)
        let years       = components.year
        
        return years!
    }
}


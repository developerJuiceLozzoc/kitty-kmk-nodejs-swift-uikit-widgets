//
//  Date.swift
//  Mkk-iOS
//
//  Created by Conner Maddalozzo on 1/8/22.
//

import Foundation
extension Calendar {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
    
}

func doubleDateToString(from date: Double) -> String{
    let birthday = Date(timeIntervalSince1970: date)
    let df = DateFormatter()
    df.dateFormat = "MMM dd, yyyy"
    return df.string(from: birthday)
}



class KMKDateFormatter {
    enum LocalizedDays: String {
        case today = "Today"
        case yesturday = "Yesturday"
        case sun = "Sunday"
        case mon = "Monday"
        case tue = "Tuesday"
        case wed = "Wednesday"
        case thu = "Thursday"
        case fri = "Friday"
        case sat = "Saturday"
        case oneWeek = "over a week ago"
        case idk = "Undefined"
    }
    
    static var yesturday: Date? {
        Calendar.current.date(byAdding: .day, value: -1, to: Date.now)
    }
    
    static var lastWeek: Date? {
        
            let calendar = Calendar.current

            // Define the duration in days and hours
            let days = 6
            let hours = 20

            // Create a DateComponents object with the specified duration
            var dateComponents = DateComponents()
            dateComponents.day = -days
            dateComponents.hour = -hours

           return calendar.date(byAdding: dateComponents, to: Date())
    }
    
    func describeDate(_ timeInterval: Double) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)

        let calendar = Calendar.current
        let now = Date()
        
        // Check if the date is today
        if calendar.isDateInToday(date) {
            return "Today"
        }
        
        // Check if the date is yesterday
        if calendar.isDateInYesterday(date) {
            return "Yesterday"
        }
        
        // Calculate the number of days between the date and today
        if let daysAgo = calendar.dateComponents([.day], from: date, to: now).day {
            // Check if it's within the last 7 days
            if daysAgo > -7 && daysAgo < 0 {
                let formatter = DateFormatter()
                formatter.dateFormat = "EEEE"  // Full weekday name in English
                return formatter.string(from: date)
            }
            
            // Check if it's over a week ago
            if daysAgo <= -7 && daysAgo > -14 {
                return "Over a week ago"
            }
            
            // Check if it's beyond 14 days ago
            if daysAgo <= -14 {
                return "Distant past"
            }
        }
        
        return "?" // Default value if any unwrapping fails
    }}

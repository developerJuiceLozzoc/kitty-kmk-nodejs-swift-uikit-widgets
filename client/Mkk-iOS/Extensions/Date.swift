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
        case idk = "Undefined"
    }
    
    func convertTimestampToLabel(from day: Double) -> String {
        let past = Date.init(timeIntervalSince1970: day)
        let today = Date.init()
        let calendar = Calendar.current
        let differenceInDays: Int = calendar.numberOfDaysBetween(past, and: today)
        var yesturdayInt: Int
        guard
            let pastInt = calendar.dateComponents([.weekday], from: past).weekday,
            let tempyesturdayInt = calendar.dateComponents([.weekday], from: today).weekday,
            let todayInt = calendar.dateComponents([.weekday], from: today).weekday
        else { return LocalizedDays.idk.rawValue }
        print(pastInt,todayInt,differenceInDays)
        if  tempyesturdayInt - 1 < 0 {
            yesturdayInt = 6;
          } else {
              yesturdayInt = tempyesturdayInt - 1;
          }

          if yesturdayInt == pastInt && differenceInDays < 2 {
              return LocalizedDays.yesturday.rawValue;
          } else if differenceInDays >= 7 {
              return "69/69/69"
              
          } else if (differenceInDays >= 1 && differenceInDays < 7) {
            switch (pastInt) {
              case 0:
                return LocalizedDays.sun.rawValue
              case 1:
                return LocalizedDays.mon.rawValue
              case 2:
                return LocalizedDays.tue.rawValue
              case 3:
                return LocalizedDays.wed.rawValue
              case 4:
                return LocalizedDays.thu.rawValue
              case 5:
                return LocalizedDays.fri.rawValue
            default:
                return LocalizedDays.sat.rawValue
                
            }
          }

          if todayInt == pastInt {
              return LocalizedDays.today.rawValue
          }

          return LocalizedDays.idk.rawValue
    }
}

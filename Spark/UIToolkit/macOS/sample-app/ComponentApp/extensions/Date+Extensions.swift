//
//  Date+Extensions.swift
//  ComponentApp
//
//  Created by James Nestor on 22/06/2021.
//

import Cocoa

extension Date {
    
    static func stringFromDate(_ date: Date) -> String {
        let dateFormatter =  DateFormatter()
        var dateString = ""
        let when = daysAgo(date: date as NSDate)
        
        // [Time | Day | Date]
        if(when.isToday){
            dateString =  DateFormatter.localizedString(from: date, dateStyle: .none, timeStyle: .short)
        }else if (when.isYesterday) {
            dateString = LocalizationStrings.yesterday
        }else if (when.isThisWeek){
            dateFormatter.dateFormat = "EEEE"
            dateString = dateFormatter.string(from: date)
        }else{
            dateString = DateFormatter.localizedString(from: date, dateStyle:.short , timeStyle: .none)
        }
        
        return dateString
    }
    
    static func daysAgo(date:NSDate) -> (isToday: Bool, isYesterday: Bool, isTomorrow:Bool, isThisWeek: Bool, isThisYear: Bool) {
        let dateFormatter =  DateFormatter()
        
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year], from: date as Date)
        let year = dateComponents.year
        let dateComponentsCurrent = calendar.dateComponents([.year], from: Date())
        let yearCurrent = dateComponentsCurrent.year
        let isThisYear = year == yearCurrent
        
        if  let dateStart = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: date as Date){

            let daysAgo = daysSinceTodayDate(dateForComparison: dateStart)
            if (daysAgo == 0){
                return (true, false, false, true, isThisYear) // Optimised skip out
            }
            else if daysAgo == 1{
                //Setting isThisWeek flag to true as we are essentially ignoring it for isYesterday, isTomorrow
                return (false, true, false, true, isThisYear)
            }
            else if daysAgo == -1 {
                return (false, false, true, true, isThisYear)
            }
            
            dateFormatter.dateFormat = "c" // Day of week
            if let currentDayOfWeek = Int(dateFormatter.string(from: Date())){
                return (daysAgo == 0, daysAgo == 1, daysAgo == -1, (currentDayOfWeek - daysAgo) > 0 && (currentDayOfWeek - daysAgo) < 8, isThisYear)

            }
        }
        
        return (false, false, false, false, isThisYear)
    }

    static func daysSinceTodayDate(dateForComparison: Date, ignoringTime: Bool = false) -> Int {
        let calendar = NSCalendar.current
        var numDays = 0
        
        var today = Date()
        var theDateForComparison = dateForComparison
        if ignoringTime {
            today = calendar.startOfDay(for: today)
            theDateForComparison = calendar.startOfDay(for: dateForComparison)
        }
        
        if theDateForComparison.compare(today) == ComparisonResult.orderedDescending {
            
            if let endDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: theDateForComparison){
                let components = calendar.dateComponents([.day], from: today as Date, to: endDate)
                if let day = components.day{
                    numDays = -day
                }
            }
        }
        else {
            let components = calendar.dateComponents([.day], from: theDateForComparison, to: today)
            if let day = components.day{
                numDays = day
            }
        }
        
        return numDays
    }
}

//
//  MZDateUitl.swift
//  MZDatePicker
//
//  Created by 曾龙 on 2021/12/27.
//

import Foundation

struct MZDateUtil {
    
    /// Date转时间数组
    static func getArray(withDate date: Date) -> [Int] {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return format.string(from: date).components(separatedBy: "-").map { string in
            return Int(string)!
        }
    }
    
    /// 时间数组转Date
    static func getDate(withArray array: [String]) -> Date {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        var newArray = array
        for index in array.count..<6 {
            newArray.append(index == 2 ? "01" : "00")
        }
        return format.date(from: newArray.joined(separator: "-"))!
    }
    
    /// 格式化数字
    static func format(_ number: Int) -> String {
        if number < 10 {
            return "0\(number)"
        }
        return "\(number)"
    }
    
    /// 根据年月获取月份中的天数
    static func getDays(forMonth month: Int, inYear year: Int) -> Int {
        switch month {
        case 1,3,5,7,8,10,12:
            return 31
        case 4,6,9,11:
            return 30
        case 2:
            return ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) ? 29 : 28
        default:
            return 30
        }
    }
    
    /// 根据起始参数获取范围
    static func getRange(withStart start: Int, andEnd end: Int) -> [String] {
        return [Int](start...end).map { value in
            return value > 1000 ? "\(value)" : format(value)
        }
    }
    
    static func getTimePerRange(fromStartTime startTime: [Int], toEndTime endTime: [Int], whenCurrentTime currentTime: [Int], andType type: Int) -> [String] {
        var start: Int
        var end: Int
        switch type {
        case 4,5:
            start = 0
            end = 59
        case 3:
            start = 0
            end = 23
        case 2:
            start = 1
            end = getDays(forMonth: currentTime[1], inYear: currentTime[0])
        case 1:
            start = 1
            end = 12
        default:
            start = startTime[0]
            end = endTime[0]
        }
        
        if startTime[0...type-1] == currentTime[0...type-1] {
            if endTime[0...type-1] == currentTime[0...type-1] {
                return getRange(withStart: startTime[type], andEnd: endTime[type])
            } else {
                return getRange(withStart: startTime[type], andEnd: end)
            }
        } else {
            if endTime[0...type-1] == currentTime[0...type-1] {
                return getRange(withStart: start, andEnd: endTime[type])
            } else {
                return getRange(withStart: start, andEnd: end)
            }
        }
    }
    
    /// 获取秒的范围
    static func getSecondRange(fromStartTime startTime: [Int], toEndTime endTime: [Int], whenCurrentTime currentTime: [Int]) -> [String] {
        return getTimePerRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime, andType: 5)
    }
    
    /// 获取分钟的范围
    static func getMinuteRange(fromStartTime startTime: [Int], toEndTime endTime: [Int], whenCurrentTime currentTime: [Int]) -> [String] {
        return getTimePerRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime, andType: 4)
    }
    
    /// 获取小时的范围
    static func getHourRange(fromStartTime startTime: [Int], toEndTime endTime: [Int], whenCurrentTime currentTime: [Int]) -> [String] {
        return getTimePerRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime, andType: 3)
    }
    
    /// 获取日的范围
    static func getDayRange(fromStartTime startTime: [Int], toEndTime endTime: [Int], whenCurrentTime currentTime: [Int]) -> [String] {
        return getTimePerRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime, andType: 2)
    }
    
    /// 获取月的范围
    static func getMonthRange(fromStartTime startTime: [Int], toEndTime endTime: [Int], whenCurrentTime currentTime: [Int]) -> [String] {
        return getTimePerRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime, andType: 1)
    }
    
    /// 获取年的范围
    static func getYearRange(fromStartTime startTime: [Int], toEndTime endTime: [Int]) -> [String] {
        return getRange(withStart: startTime[0], andEnd: endTime[0])
    }
    
    /// 根据时间数组获取选择器时间范围
    static func getDateTimeRangeByArray(type: MZDatePickerType, startDate: Date, endDate: Date, currentTime: [Int]) -> [[String]] {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let startTime: [Int] = format.string(from: startDate).components(separatedBy: "-").map { item in
            return Int(item)!
        }
        let endTime: [Int] = format.string(from: endDate).components(separatedBy: "-").map { item in
            return Int(item)!
        }
        switch type {
        case .yyyyMM:
            return [getYearRange(fromStartTime: startTime, toEndTime: endTime), getMonthRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime)]
        case .yyyyMMdd:
            return [getYearRange(fromStartTime: startTime, toEndTime: endTime), getMonthRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getDayRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime)]
        case .yyyyMMddHH:
            return [getYearRange(fromStartTime: startTime, toEndTime: endTime), getMonthRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getDayRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getHourRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime)]
        case .yyyyMMddHHmm:
            return [getYearRange(fromStartTime: startTime, toEndTime: endTime), getMonthRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getDayRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getHourRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getMinuteRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime)]
        case .yyyyMMddHHmmss:
            return [getYearRange(fromStartTime: startTime, toEndTime: endTime), getMonthRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getDayRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getHourRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getMinuteRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime), getSecondRange(fromStartTime: startTime, toEndTime: endTime, whenCurrentTime: currentTime)]
        }
    }
    
    /// 根据日期获取选择器时间范围
    static func getDateTimeRangeByDate(type: MZDatePickerType, startDate: Date, endDate: Date, currentDate: Date) -> [[String]] {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let currentTime: [Int] = format.string(from: currentDate).components(separatedBy: "-").map { item in
            return Int(item)!
        }
        return getDateTimeRangeByArray(type: type, startDate: startDate, endDate: endDate, currentTime: currentTime)
    }
    
    /// 根据时间数组获取选择器选中行
    static func getRowsByTime(dateTimeRange: [[String]], currentTime: [Int]) -> [Int] {
        var rows = [Int]()
        for i in 0..<dateTimeRange.count {
            let subRange = dateTimeRange[i]
            let item = currentTime[i]
            for j in 0..<subRange.count {
                if item == Int(subRange[j])! {
                    rows.append(j)
                    break
                }
            }
            if rows.count == i {
                rows.append(subRange.count - 1)
            }
        }
        return rows
    }
    
    /// 根据日期获取选择器选中行
    static func getRowsByDate(dateTimeRange: [[String]], currentDate: Date) -> [Int] {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let currentTime: [Int] = format.string(from: currentDate).components(separatedBy: "-").map { string in
            return Int(string)!
        }
        return getRowsByTime(dateTimeRange: dateTimeRange, currentTime: currentTime)
    }
}

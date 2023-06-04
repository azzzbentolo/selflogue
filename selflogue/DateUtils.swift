//
//  DateUtils.swift
//  selflogue
//
//  Created by Chew Jun Pin on 4/6/2023.
//

import Foundation

func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd, yyyy HH:mm"
    return formatter.string(from: date)
}

func formatDay(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd"
    return formatter.string(from: date)
}

func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM dd"
    return formatter.string(from: date)
}



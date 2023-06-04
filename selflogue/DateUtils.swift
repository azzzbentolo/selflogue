//
//  DateUtils.swift
//  selflogue
//
//  Created by Chew Jun Pin on 4/6/2023.
//

import Foundation

func format(date: Date) -> String {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    return formatter.string(from: date)
    
}


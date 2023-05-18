//
//  Habit+CoreDataProperties.swift
//  
//
//  Created by Chew Jun Pin on 18/5/2023.
//
//

import Foundation
import CoreData


extension Habit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Habit> {
        return NSFetchRequest<Habit>(entityName: "Habit")
    }

    @NSManaged public var color: String?
    @NSManaged public var dateAdded: Date?
    @NSManaged public var isRemainderOn: Bool
    @NSManaged public var notificationDate: Date?
    @NSManaged public var notificationIDs: [String]?
    @NSManaged public var remainderText: String?
    @NSManaged public var title: String?
    @NSManaged public var weekDays: [String]?

}

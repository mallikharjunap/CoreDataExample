//
//  TodoList+CoreDataProperties.swift
//  CoreDataExample
//
//  Created by Apple on 13/02/24.
//
//

import Foundation
import CoreData


extension TodoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
        return NSFetchRequest<TodoList>(entityName: "TodoList")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdate: Date?

}

extension TodoList : Identifiable {

}

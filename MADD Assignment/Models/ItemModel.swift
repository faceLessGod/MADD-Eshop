//
//  Item+CoreDataClass.swift
//  MADD Assignment
//
//  Created by Aruna Lakmal2 on 9/26/19.
//  Copyright © 2019 Aruna Lakmal2. All rights reserved.
//
//

import Foundation
import CoreData


public class Item: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var price: Float
    @NSManaged public var location: String?
    @NSManaged public var itemDesciption: String?
    @NSManaged public var image: NSData?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
}

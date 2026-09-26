//
//  Entity+CoreDataProperties.swift
//  ecommerceUI
//
//  Created by iPHTech4 on 11/11/25.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var size: String?
    @NSManaged public var color: String?
    @NSManaged public var quantity: Int64
    @NSManaged public var imageURL: String?
    @NSManaged public var price: Double
    @NSManaged public var title: String?
    @NSManaged public var id: Int64

}

extension Entity : Identifiable {

}

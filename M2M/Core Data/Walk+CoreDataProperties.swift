//
//  Walk+CoreDataProperties.swift
//  thePrototype
//
//  Created by Tran Sam on 11/23/17.
//  Copyright © 2017 Tran Sam. All rights reserved.
//
//

import Foundation
import CoreData


extension Walk {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Walk> {
        return NSFetchRequest<Walk>(entityName: "Walk")
    }

    @NSManaged public var startDate: NSDate?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var repetition: Int16
    @NSManaged public var avgAngle: Float
    @NSManaged public var rawData: URL?
    @NSManaged public var exerciseID: String?
    @NSManaged public var dog: Dog?

}

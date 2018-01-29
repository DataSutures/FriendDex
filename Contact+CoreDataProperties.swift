//
//  Contact+CoreDataProperties.swift
//  FriendDex
//
//  Created by Kimberly Smith on 12/1/17.
//  Copyright © 2017 Smith Kimberly. All rights reserved.
//
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?

}

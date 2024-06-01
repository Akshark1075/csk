//
//  User+CoreDataProperties.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var image: String?
    @NSManaged public var lastName: String?
    @NSManaged public var password: String?
    @NSManaged public var team: Team?

}

extension User : Identifiable {

}

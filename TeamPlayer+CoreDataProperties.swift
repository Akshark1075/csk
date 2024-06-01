//
//  TeamPlayer+CoreDataProperties.swift
//  csk
//
//  Created by Arvind K on 03/04/24.
//
//

import Foundation
import CoreData


extension TeamPlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamPlayer> {
        return NSFetchRequest<TeamPlayer>(entityName: "TeamPlayer")
    }

    @NSManaged public var role: String?
    @NSManaged public var isSubstitute: Bool
    @NSManaged public var player: Player?
    @NSManaged public var team: Team?

}

extension TeamPlayer : Identifiable {

}
